----------------------------------------------------------------------------------
-- Company: SAL- Virginia Tech
-- Engineer: Behnaz Rezvani
-- Project Name: HOKSTER Core
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.SomeFunction.all;
--use work.design_pkg.all;
--use work.HLoader_pkg.all;
use work.SoftCoreConstants.all;

-- Entity
----------------------------------------------------------------------------------
entity Wrapper is
    Port(
        cipher          : in integer;
        clk             : in std_logic;
        rst             : in std_logic;
        -- Data Input
        key             : in std_logic_vector(31 downto 0); -- SW = 32
        bdi             : in std_logic_vector(31 downto 0); -- W = 32
        -- Key Control
        key_valid       : in std_logic;
        key_ready       : out std_logic;
        key_update      : in std_logic;
        -- BDI Control
        bdi_valid       : in std_logic;
        bdi_ready       : out std_logic;
        bdi_pad_loc     : in std_logic_vector(3 downto 0); -- W/8 = 4
        bdi_valid_bytes : in std_logic_vector(3 downto 0); -- W/8 = 4
        bdi_size        : in std_logic_vector(2 downto 0); -- W/(8+1) = 3
        bdi_eot         : in std_logic;
        bdi_eoi         : in std_logic;
        bdi_type        : in std_logic_vector(3 downto 0);
        decrypt_in      : in std_logic;
        -- Data Output
        bdo             : out std_logic_vector(31 downto 0); -- W = 32
        -- BDO Control
        bdo_valid       : out std_logic;
        bdo_ready       : in std_logic;
        bdo_valid_bytes : out std_logic_vector(3 downto 0); -- W/8 = 4
        end_of_block    : out std_logic;
        bdo_type        : out std_logic_vector(3 downto 0);
        -- Tag Verification
        msg_auth        : out std_logic;
        msg_auth_valid  : out std_logic;
        msg_auth_ready  : in std_logic    
    );
end Wrapper;

-- Architecture
----------------------------------------------------------------------------------
architecture Behavioral of Wrapper is

    -- Signals -------------------------------------------------------
    signal HL_start         : std_logic;
    signal HL_ready         : std_logic;
    signal HL_done          : std_logic;   
    signal HL_header        : headerType;
    signal HL_mux_sel       : std_logic_vector(1 downto 0);
    signal HL_din, HL_dout  : std_logic_vector(7 downto 0);

    signal HL_dinReg_rst    : std_logic;
    signal HL_dinReg_en     : std_logic;

    signal Ek_in_mux_sel    : std_logic;
    signal bdo_t_mux_sel    : std_logic;

    signal KeyReg128_rst    : std_logic;
    signal KeyReg128_en     : std_logic;
     
    signal iDataReg_rst     : std_logic;
    signal iDataReg_en      : std_logic;
    signal iData_mux_sel    : std_logic_vector(1 downto 0);
    
    signal DstateReg_rst    : std_logic;
    signal DstateReg_en     : std_logic;
    signal Dstate_mux_sel   : std_logic_vector(1 downto 0);
    
    signal ZstateReg_rst    : std_logic;
    signal ZstateReg_en     : std_logic;
    signal Zstate_mux_sel   : std_logic_vector(2 downto 0);
    signal Z_ctrl_mux_sel   : std_logic_vector(2 downto 0);

    signal YstateReg_rst    : std_logic;
    signal YstateReg_en     : std_logic;
    signal Ystate_mux_sel   : std_logic_vector(1 downto 0);

    signal ctr_words        : std_logic_vector(1 downto 0);
    signal ctr_bytes        : std_logic_vector(4 downto 0);
    signal ctr_HL           : std_logic_vector(3 downto 0);

----------------------------------------------------------------------------------    
begin

    HardLoader: entity work.lwc_loader
    Port map(
        clk             => clk,
        rst             => rst,
        start           => HL_start,
        header          => HL_header,
        din             => HL_dout,
        ready           => HL_ready,
        done            => HL_done,
        dout            => HL_din
    );

    DathaPath: entity work.Wrapper_Datapath
    Port map(
        cipher          => cipher,
        clk             => clk,
        bdi             => bdi,
        bdi_size        => bdi_size,
        bdi_eot         => bdi_eot,
        key             => key,
        bdo             => bdo,
        msg_auth        => msg_auth,
        HL_din          => HL_din,
        HL_header       => HL_header,
        HL_dout         => HL_dout,
        Ek_in_mux_sel   => Ek_in_mux_sel,
        ctr_words       => ctr_words,
        ctr_bytes       => ctr_bytes,
        ctr_HL          => ctr_HL,
        KeyReg128_rst   => KeyReg128_rst,
        KeyReg128_en    => KeyReg128_en,
        HL_dinReg_rst   => HL_dinReg_rst,
        HL_dinReg_en    => HL_dinReg_en,
        DstateReg_rst   => DstateReg_rst,
        DstateReg_en    => DstateReg_en,
        Dstate_mux_sel  => Dstate_mux_sel,
        ZstateReg_rst   => ZstateReg_rst, 
        ZstateReg_en    => ZstateReg_en,
        Zstate_mux_sel  => Zstate_mux_sel,
        Z_ctrl_mux_sel  => Z_ctrl_mux_sel,
        YstateReg_rst   => YstateReg_rst, 
        YstateReg_en    => YstateReg_en,
        Ystate_mux_sel  => Ystate_mux_sel,
        iDataReg_rst    => iDataReg_rst,
        iDataReg_en     => iDataReg_en,
        iData_mux_sel   => iData_mux_sel,
        bdo_t_mux_sel   => bdo_t_mux_sel,
        HL_mux_sel      => HL_mux_sel
    );
    
    Controller: entity work.Wrapper_Controller
    Port map(
        cipher          => cipher,
        clk             => clk,
        rst             => rst,
        key             => key,
        bdi             => bdi,
        key_valid       => key_valid,
        key_ready       => key_ready,
        key_update      => key_update,
        bdi_valid       => bdi_valid,
        bdi_ready       => bdi_ready,
        bdi_valid_bytes => bdi_valid_bytes,
        bdi_size        => bdi_size,
        bdi_eot         => bdi_eot,
        bdi_eoi         => bdi_eoi,
        bdi_type        => bdi_type,
        decrypt_in      => decrypt_in,
        bdo_valid       => bdo_valid,
        bdo_ready       => bdo_ready,
        bdo_valid_bytes => bdo_valid_bytes,
        end_of_block    => end_of_block,
        msg_auth_valid  => msg_auth_valid,
        msg_auth_ready  => msg_auth_ready,
        HL_ready        => HL_ready,
--        HL_ready        => '1',
        HL_start        => HL_start,
        HL_done         => HL_done,
        Ek_in_mux_sel   => Ek_in_mux_sel,
        DstateReg_rst   => DstateReg_rst,
        DstateReg_en    => DstateReg_en,
        Dstate_mux_sel  => Dstate_mux_sel,
        ctr_words       => ctr_words,
        ctr_bytes       => ctr_bytes,
        ctr_HL          => ctr_HL,
        KeyReg128_rst   => KeyReg128_rst,
        KeyReg128_en    => KeyReg128_en,
        HL_dinReg_rst   => HL_dinReg_rst,
        HL_dinReg_en    => HL_dinReg_en,
        ZstateReg_rst   => ZstateReg_rst,
        ZstateReg_en    => ZstateReg_en,
        Zstate_mux_sel  => Zstate_mux_sel,
        Z_ctrl_mux_sel  => Z_ctrl_mux_sel,
        YstateReg_rst   => YstateReg_rst,
        YstateReg_en    => YstateReg_en,
        Ystate_mux_sel  => Ystate_mux_sel,
        iDataReg_rst    => iDataReg_rst,
        iDataReg_en     => iDataReg_en,
        iData_mux_sel   => iData_mux_sel,
        bdo_t_mux_sel   => bdo_t_mux_sel,
        HL_mux_sel      => HL_mux_sel
    );
    

end Behavioral;
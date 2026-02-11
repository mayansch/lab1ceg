library ieee;
use ieee.std_logic_1164.all;

entity FloatingPointMultiplier is
    port (
        -- input signals
        i_clock, i_reset         : in  std_logic;
        i_signA, i_signB         : in  std_logic;
        i_mantissaA, i_mantissaB : in  std_logic_vector(7 downto 0);
        i_exponentA, i_exponentB : in  std_logic_vector(6 downto 0);
        -- output signals
        o_sign, o_overflow       : out std_logic;
        o_mantissa               : out std_logic_vector(7 downto 0);
        o_exponent               : out std_logic_vector(6 downto 0)
    );
end entity;

architecture rtl of FloatingPointMultiplier is

    -- control unit component declaration
    component MultiplierControlUnit is
        port (
            i_clock, i_reset  : in  std_logic;
            i_INCPM, i_EXPVLD : in  std_logic;
            o_LDPE, o_LDAM    : out std_logic;
            o_LDBM, o_overflow : out std_logic;
            o_SHFTPM, o_INCPE : out std_logic;
            o_LDPM            : out std_logic;
            o_s0, o_s1, o_s2, o_s3, o_s4 : out std_logic
        );
    end component;

    -- datapath component declaration
    component MultiplierDataPath is
        port (
            SignA, SignB         : in  std_logic;
            MantissaA, MantissaB : in  std_logic_vector(7 downto 0);
            ExponentA, ExponentB : in  std_logic_vector(6 downto 0);
            GClock, GReset       : in  std_logic;
            SignOut              : out std_logic;
            MantissaOut          : out std_logic_vector(7 downto 0);
            ExponentOut          : out std_logic_vector(6 downto 0);
            Overflow             : out std_logic;
            o_INCPM, o_EXPVLD    : out std_logic;
            i_LDPE, i_LDAM, i_LDBM, i_overflow, i_SHFTPM, i_INCPE, i_LDPM : in std_logic
        );
    end component;

    -- internal connection signals
    signal s_incpm, s_expvld : std_logic;
    signal s_ldpe, s_ldam    : std_logic;
    signal s_ldbm, s_ovfl    : std_logic;
    signal s_shftpm, s_incpe : std_logic;
    signal s_ldpm            : std_logic;

begin

    -- instantiation of the datapath
    dp: MultiplierDataPath
        port map (
            -- inputs from top-level
            SignA       => i_signA,
            SignB       => i_signB,
            MantissaA   => i_mantissaA,
            MantissaB   => i_mantissaB,
            ExponentA   => i_exponentA,
            ExponentB   => i_exponentB,
            GClock      => i_clock,
            GReset      => i_reset,
            -- outputs to top-level
            SignOut     => o_sign,
            MantissaOut => o_mantissa,
            ExponentOut => o_exponent,
            Overflow    => o_overflow,
            -- control links (outputs from DP to CP)
            o_INCPM     => s_incpm, 
            o_EXPVLD    => s_expvld,
            -- control links (inputs from CP to DP)
            i_LDPE      => s_ldpe,
            i_LDAM      => s_ldam,
            i_LDBM      => s_ldbm,
            i_overflow  => s_ovfl,
            i_SHFTPM    => s_shftpm,
            i_INCPE     => s_incpe,
            i_LDPM      => s_ldpm
        );

    -- instantiation of the control unit
    cp: MultiplierControlUnit
        port map (
            -- inputs from top-level and DP
            i_clock    => i_clock,
            i_reset    => i_reset,
            i_INCPM    => s_incpm,
            i_EXPVLD   => s_expvld,
            -- outputs to DP
            o_LDPE     => s_ldpe,
            o_LDAM     => s_ldam,
            o_LDBM     => s_ldbm,
            o_overflow => s_ovfl,
            o_SHFTPM   => s_shftpm,
            o_INCPE    => s_incpe,
            o_LDPM     => s_ldpm,
            -- debug state outputs (open because not tied to top ports)
            o_s0 => open, o_s1 => open, o_s2 => open, o_s3 => open, o_s4 => open
        );

end architecture;
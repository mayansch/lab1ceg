library ieee;
use ieee.std_logic_1164.all;

entity FloatingPointAdder is
    port (
        -- System Inputs
        i_clock, i_reset : in  std_logic;
        i_signA, i_signB : in  std_logic;
        i_mantissaA, i_mantissaB : in  std_logic_vector(7 downto 0);
        i_exponentA, i_exponentB : in  std_logic_vector(6 downto 0);
        
        -- System Outputs
        o_sign, o_overflow : out std_logic;
        o_mantissa         : out std_logic_vector(7 downto 0);
        o_exponent         : out std_logic_vector(6 downto 0);
        
        -- State Monitoring
        o_s0, o_s1, o_s2, o_s3, o_s4, o_s5, o_s6 : out std_logic
    );
end entity;

architecture rtl of FloatingPointAdder is

    component AdderDataPath is
        port (
            SignA, SignB         : in  std_logic;
            MantissaA, MantissaB : in  std_logic_vector(7 downto 0);
            ExponentA, ExponentB : in  std_logic_vector(6 downto 0);
            GClock, GResetBAR    : in  std_logic;
            SignOut              : out std_logic;
            MantissaOut          : out std_logic_vector(7 downto 0);
            ExponentOut          : out std_logic_vector(6 downto 0);
            Overflow             : out std_logic;
            SHFTM                : in  std_logic;
            LDDC, DECDC          : in  std_logic;
            LDAM, LDBM           : in  std_logic;
            LDSM, LSHFTM, RSHFTM : in  std_logic;
            LDSE, INCSE, DECSE   : in  std_logic;
            CLRS, LDAS           : in  std_logic;
            DCEMT, MantissaCarry, MantissaSumMSB : out std_logic;
            -- FIXED: Matching these port names to the dp entity
            o_reg_Am, o_reg_Bm : out std_logic_vector(8 downto 0)
        );
    end component;

    component AdderControlUnit is
        port (
            i_clock, i_reset : in  std_logic;
            i_downCounterEmpty, i_mantissaCarry, i_mantissaSumMSB : in std_logic;
            o_loadA, o_loadB : out std_logic;
            o_loadDownCounter, o_decrementDownCounter : out std_logic;
            o_smallerMantissaLeftShift : out std_logic;
            o_loadSumE, o_loadSumM, o_loadSumS, o_rightShiftSum : out std_logic;
            o_incrementSumExponent, o_leftShiftSum, o_decrementSumExponent : out std_logic;
            o_s0, o_s1, o_s2, o_s3, o_s4, o_s5, o_s6 : out std_logic
        );
    end component;

    -- Internal signals
    signal int_SHFTM, int_LDDC, int_DECDC, int_LDAM, int_LDBM : std_logic;
    signal int_LDSM, int_LSHFTM, int_RSHFTM, int_LDSE, int_INCSE, int_DECSE : std_logic;
    signal int_CLRS, int_LDAS, i_reset_BAR : std_logic;
    signal int_DCEMT, int_MantissaCarry, int_MantissaSumMSB : std_logic;
    signal int_s0, int_s1, int_s2, int_s3, int_s4, int_s5, int_s6 : std_logic; 
    signal int_regAm, int_regBm : std_logic_vector(8 downto 0);

begin

    i_reset_BAR <= not i_reset;

    dp : AdderDataPath
        port map (
            SignA           => i_signA,
            SignB           => i_signB,
            MantissaA       => i_mantissaA,
            MantissaB       => i_mantissaB,
            ExponentA       => i_exponentA,
            ExponentB       => i_exponentB,
            GClock          => i_clock,
            GResetBAR       => i_reset_BAR,
            SignOut         => o_sign,
            MantissaOut     => o_mantissa,
            ExponentOut     => o_exponent,
            Overflow        => o_overflow,
            SHFTM           => int_SHFTM,
            LDDC            => int_LDDC,
            DECDC           => int_DECDC,
            LDAM            => int_LDAM,
            LDBM            => int_LDBM, 
            LDSM            => int_LDSM,
            LSHFTM          => int_LSHFTM,
            RSHFTM          => int_RSHFTM,
            LDSE            => int_LDSE,
            INCSE           => int_INCSE,
            DECSE           => int_DECSE,
            CLRS            => int_CLRS,
            LDAS            => int_LDAS,
            DCEMT           => int_DCEMT,
            MantissaCarry   => int_MantissaCarry,
            MantissaSumMSB  => int_MantissaSumMSB,
            -- FIXED: Mapping to the corrected port names
            o_reg_Am        => int_regAm,
            o_reg_Bm        => int_regBm
        );

    cp : AdderControlUnit
        port map (
            i_clock                    => i_clock,
            i_reset                    => i_reset,
            i_downCounterEmpty         => int_DCEMT,
            i_mantissaCarry            => int_MantissaCarry,
            i_mantissaSumMSB           => int_MantissaSumMSB,
            o_loadA                    => int_LDAM,
            o_loadB                    => int_LDBM,
            o_loadDownCounter          => int_LDDC,
            o_decrementDownCounter     => int_DECDC,
            o_smallerMantissaLeftShift => int_SHFTM,
            o_loadSumE                 => int_LDSE,
            o_loadSumM                 => int_LDSM,
            o_loadSumS                 => open,
            o_rightShiftSum            => int_RSHFTM,
            o_incrementSumExponent     => int_INCSE,
            o_leftShiftSum             => int_LSHFTM,
            o_decrementSumExponent     => int_DECSE,
            o_s0                       => int_s0,
            o_s1                       => int_s1,
            o_s2                       => int_s2,
            o_s3                       => int_s3,
            o_s4                       => int_s4,
            o_s5                       => int_s5,
            o_s6                       => int_s6
        );

    -- Outputs
    o_s0 <= int_s0; o_s1 <= int_s1; o_s2 <= int_s2; o_s3 <= int_s3;
    o_s4 <= int_s4; o_s5 <= int_s5; o_s6 <= int_s6;

end architecture;
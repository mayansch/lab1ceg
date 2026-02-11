library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MultiplierDataPath is
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
end entity;

architecture rtl of MultiplierDataPath is
    -- Component declarations for registers, adders, and comparators
    component EightBitComparator is
        port (i_Ai, i_Bi : in std_logic_vector(7 downto 0); o_GT, o_LT, o_EQ : out std_logic);
    end component;
    component EightBitAdderSubtractor is
        port (InputA, InputB : in std_logic_vector(7 downto 0); Operation : in std_logic; Result : out std_logic_vector(7 downto 0); CarryOUT : out std_logic);
    end component;
    component EightBitGPRegister is
        port (i_resetBar, i_load, i_shiftLeft, i_shiftRight, i_decrement, i_increment, i_serial_in_left, i_serial_in_right, i_clock : in std_logic; i_Value : in std_logic_vector(7 downto 0); o_Value : out std_logic_vector(7 downto 0));
    end component;
    component NineBitGPRegister is
        port (i_resetBar, i_load, i_shiftLeft, i_shiftRight, i_decrement, i_increment, i_serial_in_left, i_serial_in_right, i_clock : in std_logic; i_Value : in std_logic_vector(8 downto 0); o_Value : out std_logic_vector(8 downto 0));
    end component;

    signal int_exponentsum, int_finalexponent, int_finalexponentregister : std_logic_vector(7 downto 0);
    signal int_mantissaAReg, int_mantissaBReg : std_logic_vector(8 downto 0);
    signal int_product : std_logic_vector(17 downto 0);
    signal s_resetBar : std_logic;

begin
    s_resetBar <= not GReset;

    exponentAdder: EightBitAdderSubtractor port map (('0' & ExponentA), ('0' & ExponentB), '0', int_exponentsum, open);
    exponentSubtractor: EightBitAdderSubtractor port map (int_exponentsum, "00111111", '1', int_finalexponent, open);

    productExponent: EightBitGPRegister port map (s_resetBar, i_LDPE, '0', '0', '0', i_INCPE, '0', '0', GClock, int_finalexponent, int_finalexponentregister);
    exponentComparator: EightBitComparator port map (int_finalexponentregister, "01111111", open, o_EXPVLD, open);

    mantissaARegister: NineBitGPRegister port map (s_resetBar, i_LDAM, '0', '0', '0', '0', '0', '0', GClock, '1' & MantissaA, int_mantissaAReg);
    mantissaBRegister: NineBitGPRegister port map (s_resetBar, i_LDBM, '0', '0', '0', '0', '0', '0', GClock, '1' & MantissaB, int_mantissaBReg);

    int_product <= std_logic_vector(unsigned(int_mantissaAReg) * unsigned(int_mantissaBReg));
    o_INCPM     <= int_product(17);

    SignOut     <= SignA xor SignB;
    ExponentOut <= int_finalexponentregister(6 downto 0);
    MantissaOut <= int_product(15 downto 8) when i_LDPM = '1' else "00000000";
    Overflow    <= i_overflow;
end architecture;
library ieee;
use ieee.std_logic_1164.all;

entity AdderDataPath is
    port (
        GClock, GResetBAR : in  std_logic;
        SignA, SignB      : in  std_logic;
        MantissaA, MantissaB : in  std_logic_vector(7 downto 0);
        ExponentA, ExponentB : in  std_logic_vector(6 downto 0);
        SignOut     : out std_logic;
        MantissaOut : out std_logic_vector(7 downto 0);
        ExponentOut : out std_logic_vector(6 downto 0);
        Overflow    : out std_logic;
        SHFTM, LDDC, DECDC, LDAM, LDBM, LDSM, LSHFTM, RSHFTM, LDSE, INCSE, DECSE, CLRS, LDAS : in std_logic;
        DCEMT, MantissaCarry, MantissaSumMSB : out std_logic;
        o_reg_Am, o_reg_Bm : out std_logic_vector(8 downto 0);
        o_mantissa_sum     : out std_logic_vector(8 downto 0)
    );
end entity;

architecture rtl of AdderDataPath is
    -- Signal declarations
    signal s_AgtB, s_AltB, s_dc_empty, s_sign_xor, s_add_carry : std_logic;
    signal s_shftA, s_shftB : std_logic;
    signal v_expA, v_expB, v_sub, v_abs, v_dc, v_large_exp, v_regSe : std_logic_vector(7 downto 0);
    signal v_mA, v_mB, v_rAm, v_rBm, v_sum, v_comp, v_regSm : std_logic_vector(8 downto 0);

    -- Component definitions
    component EightBitComparator port(i_Ai, i_Bi: in std_logic_vector(7 downto 0); o_GT, o_LT, o_EQ: out std_logic); end component;
    component EightBitAdderSubtractor port(InputA, InputB: in std_logic_vector(7 downto 0); Operation: in std_logic; Result: out std_logic_vector(7 downto 0); CarryOUT: out std_logic); end component;
    component EightBitGPRegister port(i_resetBar, i_load, i_shiftLeft, i_shiftRight, i_decrement, i_increment, i_serial_in_left, i_serial_in_right, i_clock: in std_logic; i_Value: in std_logic_vector(7 downto 0); o_Value: out std_logic_vector(7 downto 0)); end component;
    component NineBitAdderSubtractor port(InputA, InputB: in std_logic_vector(8 downto 0); Operation: in std_logic; Result: out std_logic_vector(8 downto 0); CarryOUT: out std_logic); end component;
    component NineBitGPRegister port(i_resetBar, i_load, i_shiftLeft, i_shiftRight, i_decrement, i_increment, i_serial_in_left, i_serial_in_right, i_clock: in std_logic; i_Value: in std_logic_vector(8 downto 0); o_Value: out std_logic_vector(8 downto 0)); end component;
    component TwoToOne8BitMux port(i_muxIn0, i_muxIn1: in std_logic_vector(7 downto 0); o_mux: out std_logic_vector(7 downto 0); sel: in std_logic); end component;
    component mux_2to1_top port(SEL, A, B: in std_logic; X: out std_logic); end component;

begin

    -- Bit-width extension and shift logic
    v_expA      <= '0' & ExponentA; 
    v_expB      <= '0' & ExponentB;
    v_mA        <= '1' & MantissaA; 
    v_mB        <= '1' & MantissaB;
    s_sign_xor  <= SignA xor SignB;
    s_shftA     <= SHFTM and s_AltB; 
    s_shftB     <= SHFTM and s_AgtB;

    -- Exponent handling logic
    C0: EightBitComparator      port map ( i_Ai => v_expA, i_Bi => v_expB, o_GT => s_AgtB, o_LT => s_AltB, o_EQ => open );
    S0: EightBitAdderSubtractor port map ( InputA => v_expA, InputB => v_expB, Operation => '1', Result => v_sub, CarryOUT => open );
    N0: EightBitAdderSubtractor port map ( InputA => (others=>'0'), InputB => v_sub, Operation => s_AltB, Result => v_abs, CarryOUT => open );

    -- Mantissa alignment and storage
    DC: EightBitGPRegister      port map ( i_resetBar => GResetBAR, i_load => LDDC, i_shiftLeft => '0', i_shiftRight => '0', i_decrement => DECDC, i_increment => '0', i_serial_in_left => '0', i_serial_in_right => '0', i_clock => GClock, i_Value => v_abs, o_Value => v_dc );
    C1: EightBitComparator      port map ( i_Ai => v_dc, i_Bi => (others=>'0'), o_GT => open, o_LT => open, o_EQ => s_dc_empty );
    RA: NineBitGPRegister       port map ( i_resetBar => GResetBAR, i_load => LDAM, i_shiftLeft => '0', i_shiftRight => s_shftA, i_decrement => '0', i_increment => '0', i_serial_in_left => '0', i_serial_in_right => '0', i_clock => GClock, i_Value => v_mA, o_Value => v_rAm );
    RB: NineBitGPRegister       port map ( i_resetBar => GResetBAR, i_load => LDBM, i_shiftLeft => '0', i_shiftRight => s_shftB, i_decrement => '0', i_increment => '0', i_serial_in_left => '0', i_serial_in_right => '0', i_clock => GClock, i_Value => v_mB, o_Value => v_rBm );

    -- Addition and Sign Normalization
    ADD: NineBitAdderSubtractor port map ( InputA => v_rAm, InputB => v_rBm, Operation => '0', Result => v_sum, CarryOUT => s_add_carry );
    CMP: NineBitAdderSubtractor port map ( InputA => (others=>'0'), InputB => v_sum, Operation => s_sign_xor, Result => v_comp, CarryOUT => Overflow );
    RSM: NineBitGPRegister      port map ( i_resetBar => GResetBAR, i_load => LDSM, i_shiftLeft => LSHFTM, i_shiftRight => RSHFTM, i_decrement => '0', i_increment => '0', i_serial_in_left => '0', i_serial_in_right => '1', i_clock => GClock, i_Value => v_comp, o_Value => v_regSm );

    -- Output selection muxes and registers
    MXE: TwoToOne8BitMux        port map ( i_muxIn0 => v_expB, i_muxIn1 => v_expA, o_mux => v_large_exp, sel => s_AgtB );
    RSE: EightBitGPRegister      port map ( i_resetBar => GResetBAR, i_load => LDSE, i_shiftLeft => '0', i_shiftRight => '0', i_decrement => DECSE, i_increment => INCSE, i_serial_in_left => '0', i_serial_in_right => '0', i_clock => GClock, i_Value => v_large_exp, o_Value => v_regSe );
    MXS: mux_2to1_top           port map ( SEL => s_AgtB, A => SignA, B => SignB, X => SignOut );

    -- Assignments
    MantissaOut    <= v_regSm(7 downto 0);
    ExponentOut    <= v_regSe(6 downto 0);
    DCEMT          <= s_dc_empty; 
    MantissaCarry  <= s_add_carry; 
    MantissaSumMSB <= v_regSm(8);
    o_reg_Am       <= v_rAm; 
    o_reg_Bm       <= v_rBm; 
    o_mantissa_sum <= v_sum;

end architecture;
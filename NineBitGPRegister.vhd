library ieee;
use ieee.std_logic_1164.all;

entity NineBitGPRegister is
    port (
        -- Register Operations
        i_resetBar : in std_logic;
        i_load, i_shiftLeft, i_shiftRight : in std_logic;
        i_decrement, i_increment : in std_logic;

        -- Register Signals
        i_serial_in_left, i_serial_in_right : in std_logic;
        i_clock : in std_logic;
        i_Value : in std_logic_vector(8 downto 0);
        o_Value : out std_logic_vector(8 downto 0)
    );
end entity;

architecture structural of NineBitGPRegister is

    component enARdFF_2 port (
        i_d, i_clock, i_enable, i_resetBar : in std_logic; 
        o_q, o_qBar : out std_logic
    ); end component;

    component EightToOneMux port (
        i_mux : in std_logic_vector(7 downto 0); 
        o_mux : out std_logic; 
        sel0, sel1, sel2 : in std_logic
    ); end component;

    component EightToThreeEncoder port (
        inputs : in std_logic_vector(7 downto 0); 
        outputs : out std_logic_vector(2 downto 0)
    ); end component;

    component NineBitAdderSubtractor port (
        InputA, InputB : in std_logic_vector(8 downto 0); 
        Operation : in std_logic; 
        Result : out std_logic_vector(8 downto 0); 
        CarryOUT : out std_logic
    ); end component;

    signal d_in, q_out, inc_res, dec_res : std_logic_vector(8 downto 0);
    signal enable_reg : std_logic;
    signal sel : std_logic_vector(2 downto 0);
    signal op_dec : std_logic_vector(7 downto 0);

    -- Operation result matrices
    type mux_array is array (0 to 8) of std_logic_vector(7 downto 0);
    signal m_in : mux_array;

begin

    -- Control Logic
    enable_reg <= i_load or i_shiftLeft or i_shiftRight or i_increment or i_decrement;
    op_dec     <= (5 => i_decrement, 4 => i_increment, 3 => i_shiftRight, 2 => i_shiftLeft, 1 => i_load, others => '0');

    -- Arithmetic Units
    INC: NineBitAdderSubtractor port map (q_out, "000000001", '0', inc_res, open);
    DEC: NineBitAdderSubtractor port map (q_out, "000000001", '1', dec_res, open);
    ENC: EightToThreeEncoder    port map (op_dec, sel);

    -- Mux Input Mapping (Logic Table)
    m_in(0) <= (0=>q_out(0), 1=>i_Value(0), 2=>i_serial_in_right, 3=>q_out(1), 4=>inc_res(0), 5=>dec_res(0), others=>'1');
    m_in(1) <= (0=>q_out(1), 1=>i_Value(1), 2=>q_out(0),          3=>q_out(2), 4=>inc_res(1), 5=>dec_res(1), others=>'1');
    m_in(2) <= (0=>q_out(2), 1=>i_Value(2), 2=>q_out(1),          3=>q_out(3), 4=>inc_res(2), 5=>dec_res(2), others=>'1');
    m_in(3) <= (0=>q_out(3), 1=>i_Value(3), 2=>q_out(2),          3=>q_out(4), 4=>inc_res(3), 5=>dec_res(3), others=>'1');
    m_in(4) <= (0=>q_out(4), 1=>i_Value(4), 2=>q_out(3),          3=>q_out(5), 4=>inc_res(4), 5=>dec_res(4), others=>'1');
    m_in(5) <= (0=>q_out(5), 1=>i_Value(5), 2=>q_out(4),          3=>q_out(6), 4=>inc_res(5), 5=>dec_res(5), others=>'1');
    m_in(6) <= (0=>q_out(6), 1=>i_Value(6), 2=>q_out(5),          3=>q_out(7), 4=>inc_res(6), 5=>dec_res(6), others=>'1');
    m_in(7) <= (0=>q_out(7), 1=>i_Value(7), 2=>q_out(6),          3=>q_out(8), 4=>inc_res(7), 5=>dec_res(7), others=>'1');
    m_in(8) <= (0=>q_out(8), 1=>i_Value(8), 2=>q_out(7),          3=>i_serial_in_left, 4=>inc_res(8), 5=>dec_res(8), others=>'1');

    -- Bit-Slice Instantiations
    MUX0: EightToOneMux port map ( m_in(0), d_in(0), sel(0), sel(1), sel(2) );
    DFF0: enARdFF_2     port map ( d_in(0), i_clock, enable_reg, i_resetBar, q_out(0), open );

    MUX1: EightToOneMux port map ( m_in(1), d_in(1), sel(0), sel(1), sel(2) );
    DFF1: enARdFF_2     port map ( d_in(1), i_clock, enable_reg, i_resetBar, q_out(1), open );

    MUX2: EightToOneMux port map ( m_in(2), d_in(2), sel(0), sel(1), sel(2) );
    DFF2: enARdFF_2     port map ( d_in(2), i_clock, enable_reg, i_resetBar, q_out(2), open );

    MUX3: EightToOneMux port map ( m_in(3), d_in(3), sel(0), sel(1), sel(2) );
    DFF3: enARdFF_2     port map ( d_in(3), i_clock, enable_reg, i_resetBar, q_out(3), open );

    MUX4: EightToOneMux port map ( m_in(4), d_in(4), sel(0), sel(1), sel(2) );
    DFF4: enARdFF_2     port map ( d_in(4), i_clock, enable_reg, i_resetBar, q_out(4), open );

    MUX5: EightToOneMux port map ( m_in(5), d_in(5), sel(0), sel(1), sel(2) );
    DFF5: enARdFF_2     port map ( d_in(5), i_clock, enable_reg, i_resetBar, q_out(5), open );

    MUX6: EightToOneMux port map ( m_in(6), d_in(6), sel(0), sel(1), sel(2) );
    DFF6: enARdFF_2     port map ( d_in(6), i_clock, enable_reg, i_resetBar, q_out(6), open );

    MUX7: EightToOneMux port map ( m_in(7), d_in(7), sel(0), sel(1), sel(2) );
    DFF7: enARdFF_2     port map ( d_in(7), i_clock, enable_reg, i_resetBar, q_out(7), open );

    MUX8: EightToOneMux port map ( m_in(8), d_in(8), sel(0), sel(1), sel(2) );
    DFF8: enARdFF_2     port map ( d_in(8), i_clock, enable_reg, i_resetBar, q_out(8), open );

    o_Value <= q_out;

end architecture;
library ieee;
use ieee.std_logic_1164.all;

entity EightBitGPRegister is
    port (
        -- Register Operations
        i_resetBar                        : in  std_logic;
        i_load, i_shiftLeft, i_shiftRight : in  std_logic;
        i_decrement, i_increment          : in  std_logic;

        -- Data and Control Signals
        i_serial_in_left, i_serial_in_right : in  std_logic;
        i_clock                             : in  std_logic;
        i_Value                             : in  std_logic_vector(7 downto 0);
        o_Value                             : out std_logic_vector(7 downto 0)
    );
end entity;

architecture structural of EightBitGPRegister is

    component enARdFF_2
        port (
            i_d        : in  std_logic;
            i_clock    : in  std_logic;
            i_enable   : in  std_logic;
            i_resetBar : in  std_logic;
            o_q, o_qBar : out std_logic
        );
    end component;

    component EightToOneMux
        port (
            i_mux            : in  std_logic_vector(7 downto 0);
            o_mux            : out std_logic;
            sel0, sel1, sel2 : in  std_logic
        );
    end component;

    component EightToThreeEncoder
        port (
            inputs  : in  std_logic_vector(7 downto 0);
            outputs : out std_logic_vector(2 downto 0)
        );
    end component;

    component EightBitAdderSubtractor 
        port (
            InputA, InputB : in  std_logic_vector(7 downto 0);
            Operation      : in  std_logic;
            Result         : out std_logic_vector(7 downto 0);
            CarryOUT       : out std_logic
        );
    end component;

    signal d_in                : std_logic_vector(7 downto 0);
    signal q_out               : std_logic_vector(7 downto 0);
    signal enable_reg          : std_logic;
    signal operation_selectors : std_logic_vector(2 downto 0);
    signal operation_decoder   : std_logic_vector(7 downto 0);

    -- Results of Arithmetic Operations
    signal incrementer_result : std_logic_vector(7 downto 0);
    signal decrementer_result : std_logic_vector(7 downto 0);

    -- Mux Inputs (Arrays of 8-bit vectors for each bit-slice)
    type mux_input_array is array (0 to 7) of std_logic_vector(7 downto 0);
    signal mux_inputs : mux_input_array;

begin

    -- Control Logic
    enable_reg        <= i_load or i_shiftLeft or i_shiftRight or i_increment or i_decrement;
    operation_decoder <= (5 => i_decrement, 4 => i_increment, 3 => i_shiftRight, 2 => i_shiftLeft, 1 => i_load, others => '0');

    -- Arithmetic Units
    inc_adder: EightBitAdderSubtractor port map (q_out, "00000001", '0', incrementer_result, open);
    dec_adder: EightBitAdderSubtractor port map (q_out, "00000001", '1', decrementer_result, open);

    op_encoder: EightToThreeEncoder port map (operation_decoder, operation_selectors);

    ---------------------------------------------------------------------------
    -- Bit-Slice Logic Generation
    ---------------------------------------------------------------------------
    -- Map logic for each bit slice (0 through 7)
    mux_inputs(0) <= (0 => q_out(0), 1 => i_Value(0), 2 => i_serial_in_right, 3 => q_out(1), 4 => incrementer_result(0), 5 => decrementer_result(0), others => '1');
    mux_inputs(1) <= (0 => q_out(1), 1 => i_Value(1), 2 => q_out(0), 3 => q_out(2), 4 => incrementer_result(1), 5 => decrementer_result(1), others => '1');
    mux_inputs(2) <= (0 => q_out(2), 1 => i_Value(2), 2 => q_out(1), 3 => q_out(3), 4 => incrementer_result(2), 5 => decrementer_result(2), others => '1');
    mux_inputs(3) <= (0 => q_out(3), 1 => i_Value(3), 2 => q_out(2), 3 => q_out(4), 4 => incrementer_result(3), 5 => decrementer_result(3), others => '1');
    mux_inputs(4) <= (0 => q_out(4), 1 => i_Value(4), 2 => q_out(3), 3 => q_out(5), 4 => incrementer_result(4), 5 => decrementer_result(4), others => '1');
    mux_inputs(5) <= (0 => q_out(5), 1 => i_Value(5), 2 => q_out(4), 3 => q_out(6), 4 => incrementer_result(5), 5 => decrementer_result(5), others => '1');
    mux_inputs(6) <= (0 => q_out(6), 1 => i_Value(6), 2 => q_out(5), 3 => q_out(7), 4 => incrementer_result(6), 5 => decrementer_result(6), others => '1');
    mux_inputs(7) <= (0 => q_out(7), 1 => i_Value(7), 2 => q_out(6), 3 => i_serial_in_left, 4 => incrementer_result(7), 5 => decrementer_result(7), others => '1');

    -- Structural Instantiation for each bit
    gen_bits: for i in 0 to 7 generate
        mux_inst: EightToOneMux 
            port map (
                i_mux => mux_inputs(i),
                o_mux => d_in(i),
                sel0  => operation_selectors(0),
                sel1  => operation_selectors(1),
                sel2  => operation_selectors(2)
            );

        dff_inst: enARdFF_2 
            port map (
                i_d        => d_in(i),
                i_clock    => i_clock,
                i_enable   => enable_reg,
                i_resetBar => i_resetBar,
                o_q        => q_out(i),
                o_qBar     => open
            );
    end generate;

    o_Value <= q_out;

end architecture;
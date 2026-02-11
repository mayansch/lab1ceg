library ieee;
use ieee.std_logic_1164.all;

entity EightBitAdderSubtractor is 
    port (
        InputA, InputB : in  std_logic_vector(7 downto 0);
        Operation      : in  std_logic; -- '0' for Add, '1' for Subtract
        Result         : out std_logic_vector(7 downto 0);
        CarryOUT       : out std_logic
    );
end entity;

architecture rtl of EightBitAdderSubtractor is

    component EightBitRippleAdder is
        port (
            InputA, InputB : in  std_logic_vector(7 downto 0);
            CarryIN        : in  std_logic;
            Sum            : out std_logic_vector(7 downto 0);
            CarryOUT       : out std_logic
        );
    end component;

    signal s_b_feed    : std_logic_vector(7 downto 0);
    signal s_op_vector : std_logic_vector(7 downto 0);

begin

    -- Logic for Two's Complement subtraction: 
    -- If Operation is '1', B is inverted and CarryIN becomes '1' (B + 1)
    s_op_vector <= (others => Operation);
    s_b_feed    <= InputB xor s_op_vector;

    RA: EightBitRippleAdder 
        port map (
            InputA   => InputA,
            InputB   => s_b_feed,
            CarryIN  => Operation,
            Sum      => Result,
            CarryOUT => CarryOUT
        );

end architecture;
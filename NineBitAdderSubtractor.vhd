library ieee;
use ieee.std_logic_1164.all;

entity NineBitAdderSubtractor is 
    port (
        InputA, InputB : in  std_logic_vector(8 downto 0);
        Operation      : in  std_logic;
        Result         : out std_logic_vector(8 downto 0);
        CarryOUT       : out std_logic
    );
end entity;

architecture rtl of NineBitAdderSubtractor is

    component NineBitRippleAdder is
        port (
            InputA, InputB : in  std_logic_vector(8 downto 0);
            CarryIN        : in  std_logic;
            Sum            : out std_logic_vector(8 downto 0);
            CarryOUT       : out std_logic
        );
    end component;

    signal s_b_feed    : std_logic_vector(8 downto 0);
    signal s_op_vector : std_logic_vector(8 downto 0);

begin

    -- Subtraction logic: XOR InputB with Operation bit and use Operation as CarryIN
    s_op_vector <= (others => Operation);
    s_b_feed    <= InputB xor s_op_vector;

    RA: NineBitRippleAdder 
        port map (
            InputA   => InputA,
            InputB   => s_b_feed,
            CarryIN  => Operation,
            Sum      => Result,
            CarryOUT => CarryOUT
        );

end architecture;
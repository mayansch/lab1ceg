library ieee;
use ieee.std_logic_1164.all;

entity EightBitComparator is
    port (
        i_Ai, i_Bi      : in  std_logic_vector(7 downto 0);
        o_GT, o_LT, o_EQ : out std_logic
    );
end entity;

architecture rtl of EightBitComparator is

    component oneBitComparator is
        port (
            i_GTPrevious, i_LTPrevious : in  std_logic;
            i_Ai, i_Bi                 : in  std_logic;
            o_GT, o_LT                 : out std_logic
        );
    end component;

    signal int_GT, int_LT : std_logic_vector(7 downto 0);
    signal gnd            : std_logic := '0';

begin

    -- Bit-slice instantiations (Cascaded from MSB to LSB)
    comp7: oneBitComparator port map ( gnd,       gnd,       i_Ai(7), i_Bi(7), int_GT(7), int_LT(7) );
    comp6: oneBitComparator port map ( int_GT(7), int_LT(7), i_Ai(6), i_Bi(6), int_GT(6), int_LT(6) );
    comp5: oneBitComparator port map ( int_GT(6), int_LT(6), i_Ai(5), i_Bi(5), int_GT(5), int_LT(5) );
    comp4: oneBitComparator port map ( int_GT(5), int_LT(5), i_Ai(4), i_Bi(4), int_GT(4), int_LT(4) );
    comp3: oneBitComparator port map ( int_GT(4), int_LT(4), i_Ai(3), i_Bi(3), int_GT(3), int_LT(3) );
    comp2: oneBitComparator port map ( int_GT(3), int_LT(3), i_Ai(2), i_Bi(2), int_GT(2), int_LT(2) );
    comp1: oneBitComparator port map ( int_GT(2), int_LT(2), i_Ai(1), i_Bi(1), int_GT(1), int_LT(1) );
    comp0: oneBitComparator port map ( int_GT(1), int_LT(1), i_Ai(0), i_Bi(0), int_GT(0), int_LT(0) );

    -- Output logic
    o_GT <= int_GT(0);
    o_LT <= int_LT(0);
    o_EQ <= int_GT(0) nor int_LT(0);

end architecture;
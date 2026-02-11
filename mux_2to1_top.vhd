library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_2to1_top is
    Port ( SEL : in  STD_LOGIC;
           A   : in  STD_LOGIC;
           B   : in  STD_LOGIC;
           X   : out STD_LOGIC);
end mux_2to1_top;

architecture rtl of mux_2to1_top is
SIGNAL int_t1, int_t2 : STD_LOGIC; 
begin
	int_t1 <= A and not SEL;
	int_t2 <= B and SEL;
	
	X <= int_t1 or int_t2;
end rtl;
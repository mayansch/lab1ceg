library ieee;
use ieee.std_logic_1164.all;

entity FullAdder is
	port(
		a, b, cin : in std_logic;
		cout, s : out std_logic
	);
	end FullAdder;
	
architecture rtl of FullAdder is 
	component HalfAdder is 
		port(
			a, b : in std_logic;
			s, c : out std_logic
		);
	end component;
	
	signal sum_low, c_high, c_low : std_logic;
	begin
		ha_high: HalfAdder
			port map(
				a => cin, b => sum_low, s => s, c => c_high
			);
			
		ha_low: HalfAdder
			port map(
				a => a, b => b, s => sum_low, c => c_low
			);
			
		cout <= c_high or c_low;
		
end rtl;
	
	
	
	
	
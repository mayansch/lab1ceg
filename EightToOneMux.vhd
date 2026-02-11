library ieee;
use ieee.std_logic_1164.all;

entity EightToOneMux is
    port (
        i_mux : in  std_logic_vector(7 downto 0);
        o_mux : out std_logic;
        sel0, sel1, sel2 : in std_logic
    );
end entity EightToOneMux;

architecture rtl of EightToOneMux is
    signal sel : std_logic_vector(2 downto 0);
begin
    sel <= sel2 & sel1 & sel0;

    with sel select
        o_mux <= i_mux(0) when "000",
                i_mux(1) when "001",
                i_mux(2) when "010",
                i_mux(3) when "011",
                i_mux(4) when "100",
                i_mux(5) when "101",
                i_mux(6) when "110",
                i_mux(7) when others;
end rtl;

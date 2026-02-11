library ieee;
use ieee.std_logic_1164.all;

entity dflipflop is
    port (
        i_d : in std_logic;
        i_clock : in std_logic;
        i_enable : in std_logic;
        i_async_reset : in std_logic;
        i_async_set : in std_logic;
        o_q, o_qBar : out std_logic
    );
end dflipflop;

architecture rtl of dflipflop is
    signal q_reg : std_logic;
begin

    process(i_clock, i_async_reset, i_async_set)
    begin
        if i_async_reset = '1' then
            q_reg <= '0';
        elsif i_async_set = '1' then
            q_reg <= '1';
        elsif rising_edge(i_clock) then
            if i_enable = '1' then
                q_reg <= i_d;
            end if;
        end if;
    end process;

    o_q    <= q_reg;
    o_qBar <= not q_reg;

end rtl;

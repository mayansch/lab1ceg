library ieee;
use ieee.std_logic_1164.all;

entity MultiplierControlUnit is
    port (
        i_clock, i_reset  : in  std_logic;
        i_INCPM, i_EXPVLD : in  std_logic;
        o_LDPE, o_LDAM    : out std_logic;
        o_LDBM, o_overflow : out std_logic;
        o_SHFTPM, o_INCPE : out std_logic;
        o_LDPM            : out std_logic;
        o_s0, o_s1, o_s2, o_s3, o_s4 : out std_logic
    );
end entity;

architecture rtl of MultiplierControlUnit is
    component dflipflop is
        port (
            i_d, i_clock, i_enable, i_async_reset, i_async_set : in std_logic;
            o_q, o_qBar : out std_logic
        );
    end component;
    signal int_s0, int_s1, int_s2, int_s3, int_s4 : std_logic;
begin
    s0: dflipflop port map (i_reset, i_clock, '1', '0', i_reset, int_s0, open);
    s1: dflipflop port map (int_s0, i_clock, '1', i_reset, '0', int_s1, open);
    s2: dflipflop port map ((int_s1 and i_INCPM and not i_EXPVLD) or int_s2, i_clock, '1', i_reset, '0', int_s2, open);
    s3: dflipflop port map ((int_s1 and i_INCPM and i_EXPVLD) or (int_s3 and i_EXPVLD), i_clock, '1', i_reset, '0', int_s3, open);
    s4: dflipflop port map ((int_s1 and not i_INCPM) or (int_s3 and not i_INCPM) or int_s4, i_clock, '1', i_reset, '0', int_s4, open);

    o_LDPE     <= int_s0;
    o_LDAM     <= int_s1;
    o_LDBM     <= int_s1;
    o_overflow <= int_s2;
    o_SHFTPM   <= int_s3;
    o_INCPE    <= int_s3;
    o_LDPM     <= int_s4;

    o_s0 <= int_s0; o_s1 <= int_s1; o_s2 <= int_s2; o_s3 <= int_s3; o_s4 <= int_s4;
end architecture;
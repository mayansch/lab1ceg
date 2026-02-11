library ieee;
use ieee.std_logic_1164.all;

entity NineBitRippleAdder is
    port (
        InputA, InputB : in  std_logic_vector(8 downto 0);
        CarryIN        : in  std_logic;
        Sum            : out std_logic_vector(8 downto 0);
        CarryOUT       : out std_logic
    );
end entity NineBitRippleAdder;

architecture rtl of NineBitRippleAdder is

    component FullAdder is
        port (
            A, B, Cin : in  std_logic;
            s, Cout   : out std_logic
        );
    end component;

    signal c : std_logic_vector(9 downto 0);

begin

    c(0) <= CarryIN;

    gen_adders : for i in 0 to 8 generate
        fa_i : FullAdder
            port map (
                A    => InputA(i),
                B    => InputB(i),
                Cin  => c(i),
                s    => Sum(i),
                Cout => c(i+1)
            );
    end generate;

    CarryOUT <= c(9);

end rtl;

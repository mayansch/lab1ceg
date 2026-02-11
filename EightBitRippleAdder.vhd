LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY EightBitRippleAdder IS
    PORT (
        InputA, InputB : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        CarryIN : IN STD_LOGIC;
        Sum : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        CarryOUT : OUT STD_LOGIC
    );
END ENTITY EightBitRippleAdder;

ARCHITECTURE rtl OF EightBitRippleAdder IS
    SIGNAL C : STD_LOGIC_VECTOR(7 DOWNTO 0);

    COMPONENT FullAdder IS
        PORT (
            A, B, Cin : IN STD_LOGIC;
            s, Cout : OUT STD_LOGIC
        );
    END COMPONENT;

BEGIN
    FA0: FullAdder 
    PORT MAP (
        A => InputA(0), B => InputB(0), Cin => CarryIN,
        s => Sum(0), Cout => C(0)
    );

    FA1: FullAdder 
    PORT MAP (
        A => InputA(1), B => InputB(1), Cin => C(0),
        s => Sum(1), Cout => C(1)
    );

    FA2: FullAdder 
    PORT MAP (
        A => InputA(2), B => InputB(2), Cin => C(1),
        s => Sum(2), Cout => C(2)
    );

    FA3: FullAdder 
    PORT MAP (
        A => InputA(3), B => InputB(3), Cin => C(2),
        s => Sum(3), Cout => C(3)
    );

    FA4: FullAdder 
    PORT MAP (
        A => InputA(4), B => InputB(4), Cin => C(3),
        s => Sum(4), Cout => C(4)
    );

    FA5: FullAdder 
    PORT MAP (
        A => InputA(5), B => InputB(5), Cin => C(4),
        s => Sum(5), Cout => C(5)
    );

    FA6: FullAdder 
    PORT MAP (
        A => InputA(6), B => InputB(6), Cin => C(5),
        s => Sum(6), Cout => C(6)
    );

    FA7: FullAdder 
    PORT MAP (
        A => InputA(7), B => InputB(7), Cin => C(6),
        s => Sum(7), Cout => C(7)
    );

    CarryOUT <= C(7) xor C(6);

END rtl;
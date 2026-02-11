LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY EightToThreeEncoder IS
    PORT 
    (
        inputs : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        outputs : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
END ENTITY EightToThreeEncoder;

ARCHITECTURE rtl OF EightToThreeEncoder IS

BEGIN

    outputs(2) <= inputs(7) or inputs(6) or inputs(5) or inputs(4);
    outputs(1) <= inputs(7) or inputs(6) or inputs(3) or inputs(2);
    outputs(0) <= inputs(7) or inputs(5) or inputs(3) or inputs(1); 

END rtl;
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY TwoToOne8BitMux IS
    PORT (
        i_muxIn0, i_muxIn1	: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        o_mux				: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        sel					: IN STD_LOGIC
    );
END ENTITY TwoToOne8BitMux;

ARCHITECTURE rtl OF TwoToOne8BitMux IS
			SIGNAL out_mux : STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
		out_mux(7) <= ((not sel) and (i_muxIn0(7))) or 
					  ((sel) and (i_muxIn1(7)));
						 
		out_mux(6) <= ((not sel) and (i_muxIn0(6))) or 
					  ((sel) and (i_muxIn1(6)));

		out_mux(5) <= ((not sel) and (i_muxIn0(5))) or 
					  ((sel) and (i_muxIn1(5)));

		out_mux(4) <= ((not sel) and (i_muxIn0(4))) or 
					  ((sel) and (i_muxIn1(4)));

		out_mux(3) <= ((not sel) and (i_muxIn0(3))) or 
					  ((sel) and (i_muxIn1(3)));

		out_mux(2) <= ((not sel) and (i_muxIn0(2))) or 
					  ((sel) and (i_muxIn1(2)));

		out_mux(1) <= ((not sel) and (i_muxIn0(1))) or 
					  ((sel) and (i_muxIn1(1)));

		out_mux(0) <= ((not sel) and (i_muxIn0(0))) or 
					  ((sel) and (i_muxIn1(0)));	
						
		o_mux <= out_mux;	
END rtl;
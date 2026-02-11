library ieee;
use ieee.std_logic_1164.all;

entity AdderControlUnit is
    port (
        -- Inputs
        i_clock, i_reset : in std_logic;
        i_downCounterEmpty, i_mantissaCarry, i_mantissaSumMSB : in std_logic;
        
        -- Control Outputs
        o_loadA, o_loadB : out std_logic;
        o_loadDownCounter, o_decrementDownCounter : out std_logic;
        o_smallerMantissaLeftShift : out std_logic;
        o_loadSumE, o_loadSumM, o_loadSumS, o_rightShiftSum : out std_logic;
        o_incrementSumExponent, o_leftShiftSum, o_decrementSumExponent : out std_logic;
        
        -- State Monitoring
        o_s0, o_s1, o_s2, o_s3, o_s4, o_s5, o_s6 : out std_logic
    );
end entity AdderControlUnit;

architecture rtl of AdderControlUnit is

    component dflipflop is
        port(
            i_d, i_clock, i_enable, i_async_reset, i_async_set : in std_logic;
            o_q, o_qBar : out std_logic
        );
    end component;

    -- Internal State Signals
    signal int_s0, int_s1, int_s2, int_s3, int_s4, int_s5, int_s6 : std_logic; 
    signal inp_s2, inp_s3, inp_s4, inp_s5, inp_s6 : std_logic;

begin

    -- State Transition Logic
    inp_s2 <= (int_s1 or int_s2) and not i_downCounterEmpty;
    inp_s3 <= (int_s1 or int_s2) and i_downCounterEmpty;
    inp_s4 <= int_s3 and i_mantissaCarry;
    inp_s5 <= (int_s3 or int_s5) and not i_mantissaSumMSB and not i_mantissaCarry;
    inp_s6 <= int_s4 or int_s6 or (int_s5 and i_mantissaSumMSB) or 
              (int_s3 and i_mantissaSumMSB and not i_mantissaCarry);

    -- State Register Instantiations (One-Hot Encoding)
    S0_REG: dflipflop port map ( i_d => i_reset, i_clock => i_clock, i_enable => '1', i_async_reset => '0',      i_async_set => i_reset, o_q => int_s0, o_qBar => open );
    S1_REG: dflipflop port map ( i_d => int_s0,  i_clock => i_clock, i_enable => '1', i_async_reset => i_reset,  i_async_set => '0',     o_q => int_s1, o_qBar => open );
    S2_REG: dflipflop port map ( i_d => inp_s2,  i_clock => i_clock, i_enable => '1', i_async_reset => i_reset,  i_async_set => '0',     o_q => int_s2, o_qBar => open );
    S3_REG: dflipflop port map ( i_d => inp_s3,  i_clock => i_clock, i_enable => '1', i_async_reset => i_reset,  i_async_set => '0',     o_q => int_s3, o_qBar => open );
    S4_REG: dflipflop port map ( i_d => inp_s4,  i_clock => i_clock, i_enable => '1', i_async_reset => i_reset,  i_async_set => '0',     o_q => int_s4, o_qBar => open );
    S5_REG: dflipflop port map ( i_d => inp_s5,  i_clock => i_clock, i_enable => '1', i_async_reset => i_reset,  i_async_set => '0',     o_q => int_s5, o_qBar => open );
    S6_REG: dflipflop port map ( i_d => inp_s6,  i_clock => i_clock, i_enable => '1', i_async_reset => i_reset,  i_async_set => '0',     o_q => int_s6, o_qBar => open );

    -- Output Signal Mapping
    o_loadA                    <= int_s0;
    o_loadB                    <= int_s0;
    
    o_loadDownCounter          <= int_s1;
    
    o_decrementDownCounter     <= int_s2;
    o_smallerMantissaLeftShift <= int_s2;
    
    o_loadSumE                 <= int_s3;
    o_loadSumM                 <= int_s3;
    o_loadSumS                 <= int_s3;
    
    o_rightShiftSum            <= int_s4;
    o_incrementSumExponent     <= int_s4;
    
    o_leftShiftSum             <= int_s5;
    o_decrementSumExponent     <= int_s5;

    -- State Debug Outputs
    o_s0 <= int_s0; o_s1 <= int_s1; o_s2 <= int_s2; o_s3 <= int_s3; 
    o_s4 <= int_s4; o_s5 <= int_s5; o_s6 <= int_s6;
    
end architecture;
library verilog;
use verilog.vl_types.all;
entity FloatingPointAdder_vlg_sample_tst is
    port(
        i_clock         : in     vl_logic;
        i_exponentA     : in     vl_logic_vector(6 downto 0);
        i_exponentB     : in     vl_logic_vector(6 downto 0);
        i_mantissaA     : in     vl_logic_vector(7 downto 0);
        i_mantissaB     : in     vl_logic_vector(7 downto 0);
        i_reset         : in     vl_logic;
        i_signA         : in     vl_logic;
        i_signB         : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end FloatingPointAdder_vlg_sample_tst;

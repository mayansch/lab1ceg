library verilog;
use verilog.vl_types.all;
entity FloatingPointAdder_vlg_check_tst is
    port(
        o_exponent      : in     vl_logic_vector(6 downto 0);
        o_mantissa      : in     vl_logic_vector(7 downto 0);
        o_overflow      : in     vl_logic;
        o_s0            : in     vl_logic;
        o_s1            : in     vl_logic;
        o_s2            : in     vl_logic;
        o_s3            : in     vl_logic;
        o_s4            : in     vl_logic;
        o_s5            : in     vl_logic;
        o_s6            : in     vl_logic;
        o_sign          : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end FloatingPointAdder_vlg_check_tst;

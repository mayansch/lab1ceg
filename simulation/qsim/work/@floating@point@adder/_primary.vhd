library verilog;
use verilog.vl_types.all;
entity FloatingPointAdder is
    port(
        i_clock         : in     vl_logic;
        i_reset         : in     vl_logic;
        i_signA         : in     vl_logic;
        i_signB         : in     vl_logic;
        i_mantissaA     : in     vl_logic_vector(7 downto 0);
        i_mantissaB     : in     vl_logic_vector(7 downto 0);
        i_exponentA     : in     vl_logic_vector(6 downto 0);
        i_exponentB     : in     vl_logic_vector(6 downto 0);
        o_sign          : out    vl_logic;
        o_overflow      : out    vl_logic;
        o_mantissa      : out    vl_logic_vector(7 downto 0);
        o_exponent      : out    vl_logic_vector(6 downto 0);
        o_s0            : out    vl_logic;
        o_s1            : out    vl_logic;
        o_s2            : out    vl_logic;
        o_s3            : out    vl_logic;
        o_s4            : out    vl_logic;
        o_s5            : out    vl_logic;
        o_s6            : out    vl_logic
    );
end FloatingPointAdder;

library verilog;
use verilog.vl_types.all;
entity AdderDataPath_vlg_sample_tst is
    port(
        CLRS            : in     vl_logic;
        DECDC           : in     vl_logic;
        DECSE           : in     vl_logic;
        ExponentA       : in     vl_logic_vector(6 downto 0);
        ExponentB       : in     vl_logic_vector(6 downto 0);
        GClock          : in     vl_logic;
        GResetBAR       : in     vl_logic;
        INCSE           : in     vl_logic;
        LDAM            : in     vl_logic;
        LDAS            : in     vl_logic;
        LDBM            : in     vl_logic;
        LDDC            : in     vl_logic;
        LDSE            : in     vl_logic;
        LDSM            : in     vl_logic;
        LSHFTM          : in     vl_logic;
        MantissaA       : in     vl_logic_vector(7 downto 0);
        MantissaB       : in     vl_logic_vector(7 downto 0);
        RSHFTM          : in     vl_logic;
        SHFTM           : in     vl_logic;
        SignA           : in     vl_logic;
        SignB           : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end AdderDataPath_vlg_sample_tst;

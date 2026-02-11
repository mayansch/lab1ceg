library verilog;
use verilog.vl_types.all;
entity AdderDataPath is
    port(
        SignA           : in     vl_logic;
        SignB           : in     vl_logic;
        MantissaA       : in     vl_logic_vector(7 downto 0);
        MantissaB       : in     vl_logic_vector(7 downto 0);
        ExponentA       : in     vl_logic_vector(6 downto 0);
        ExponentB       : in     vl_logic_vector(6 downto 0);
        GClock          : in     vl_logic;
        GResetBAR       : in     vl_logic;
        SignOut         : out    vl_logic;
        MantissaOut     : out    vl_logic_vector(7 downto 0);
        ExponentOut     : out    vl_logic_vector(6 downto 0);
        Overflow        : out    vl_logic;
        SHFTM           : in     vl_logic;
        LDDC            : in     vl_logic;
        DECDC           : in     vl_logic;
        LDAM            : in     vl_logic;
        LDBM            : in     vl_logic;
        LDSM            : in     vl_logic;
        LSHFTM          : in     vl_logic;
        RSHFTM          : in     vl_logic;
        LDSE            : in     vl_logic;
        INCSE           : in     vl_logic;
        DECSE           : in     vl_logic;
        CLRS            : in     vl_logic;
        LDAS            : in     vl_logic;
        DCEMT           : out    vl_logic;
        MantissaCarry   : out    vl_logic;
        MantissaSumMSB  : out    vl_logic;
        o_register_Am_result: out    vl_logic_vector(8 downto 0);
        o_register_Bm_result: out    vl_logic_vector(8 downto 0);
        o_mantissaAddResult: out    vl_logic_vector(8 downto 0)
    );
end AdderDataPath;

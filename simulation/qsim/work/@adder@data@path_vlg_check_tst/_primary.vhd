library verilog;
use verilog.vl_types.all;
entity AdderDataPath_vlg_check_tst is
    port(
        DCEMT           : in     vl_logic;
        ExponentOut     : in     vl_logic_vector(6 downto 0);
        MantissaCarry   : in     vl_logic;
        MantissaOut     : in     vl_logic_vector(7 downto 0);
        MantissaSumMSB  : in     vl_logic;
        o_mantissaAddResult: in     vl_logic_vector(8 downto 0);
        o_register_Am_result: in     vl_logic_vector(8 downto 0);
        o_register_Bm_result: in     vl_logic_vector(8 downto 0);
        Overflow        : in     vl_logic;
        SignOut         : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end AdderDataPath_vlg_check_tst;

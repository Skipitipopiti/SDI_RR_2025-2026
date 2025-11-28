library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FMC is
    port (
        CLK     : in  std_logic;
        RST_n   : in  std_logic; 

        NE1     : in  std_logic;
        NOE     : in  std_logic;
        NWE     : in  std_logic;
        AD      : inout  std_logic_vector(15 downto 0);

        CS      : out std_logic;
        RD      : out std_logic;
        WR      : out std_logic;

        Mem_Dout : in std_logic_vector(15 downto 0);
        Mem_Din  : out std_logic_vector(15 downto 0);
        Mem_A    : out std_logic_vector(15 downto 0)
    );
end entity FMC;

architecture Behavioral of FMC is
    component FMC_DP 
        port (
            CLK     : in  std_logic;
            AD      : inout std_logic_vector(15 downto 0);
            RST_n   : in  std_logic;

            Dout_En : in std_logic;
            A_En    : in std_logic;
            Din_En  : in std_logic;
            Din_OE  : in std_logic; -- tri-state

            Mem_Dout : in std_logic_vector(15 downto 0);
            Mem_Din  : out std_logic_vector(15 downto 0);
            Mem_A    : out std_logic_vector(15 downto 0)
        );
    end component;

    component FMC_CU 
        port (
            RST_n     : in  std_logic; -- async reset
            CLK       : in  std_logic;
            NE1       : in  std_logic;
            NOE       : in  std_logic;
            NWE       : in  std_logic;
    
            CS        : out std_logic;
            RD        : out std_logic;
            WR        : out std_logic;
            
            Dout_En   : out std_logic;
            A_En      : out std_logic;
            Din_En    : out std_logic;
            Din_OE    : out std_logic  -- tri-state
        );
    end component;
    signal Din_OE, Dout_En, A_En, Din_En : std_logic;

    begin
    CU_inst : FMC_CU
        port map (
            RST_n     => RST_n,
            CLK     => CLK,
            NE1     => NE1,
            NOE     => NOE,
            NWE     => NWE,
    
            CS      => CS,
            RD      => RD,
            WR      => WR,
            
            Dout_En => Dout_En,
            A_En    => A_En,
            Din_En  => Din_En,
            Din_OE  => Din_OE
        );
    DP_inst : FMC_DP
        port map (
            CLK     => CLK,
            AD      => AD,
            RST_n   => RST_n,
    
            Dout_En => Dout_En,
            A_En    => A_En,
            Din_En  => Din_En,
            Din_OE  => Din_OE,

            Mem_Dout => Mem_Dout,
            Mem_Din  => Mem_Din,
            Mem_A    => Mem_A
        );
end Behavioral;
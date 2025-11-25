library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library lpm;
use lpm.lpm_components.all;
library altera_mf;
use altera_mf.altera_mf_components.all;

entity user is
	port
	(
		-- Main reset input
		reset		: in std_logic;
		-- FMC interface
		FMC_CLK : in  std_logic;
		FMC_NE1, FMC_NOE, FMC_NWE : in  std_logic;
		FMC_AD : inout std_logic_vector(15 downto 0);
	);
end user;

architecture behavioural of user is
	component FMC_CU
		port (
			RST     : in  std_logic; -- async reset
			CLK     : in  std_logic;
			NE1     : in  std_logic;
			NOE     : in  std_logic;
			NWE     : in  std_logic;

			CS      : out std_logic;
			RD      : out std_logic;
			WR      : out std_logic;
			
			Dout_En : out std_logic;
			A_En    : out std_logic;
			Din_En  : out std_logic;
			Din_OE  : out std_logic  -- tri-state
		);
	end component;

	component FMC_DP
		port (
			CLK     : in  std_logic;
			AD      : inout std_logic_vector(15 downto 0);

			Dout_En : in std_logic;
			A_En    : in std_logic;
			Din_En  : in std_logic;
			Din_OE  : in std_logic; -- tri-state
			
			CS,RD,WR : in std_logic
		);
	end component;
	
	signal CS, RD, WR : std_logic;
	signal Dout_En, A_En, Din_En, Din_OE : std_logic;

begin
	FMC_CU_inst : FMC_CU
	port map
	(
		RST => reset,
		CLK => clk,
		NE1 => FMC_NE1,
		NOE => FMC_NOE,
		NWE => FMC_NWE,

		CS => CS,
		RD => RD,
		WR => WR,

		Dout_En => Dout_En,
		A_En => A_En,
		Din_En => Din_En,
		Din_OE => Din_OE
	);

	FMC_DP_inst : FMC_DP
	port map
	(
		CLK => FMC_CLK,
		AD => FMC_AD,
		Dout_En => Dout_En,
		A_En => A_En,
		Din_En => Din_En,
		Din_OE => Din_OE,
		CS => CS,
		RD => RD,
		WR => WR
	)
	
end behavioural;

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
		-- Main clock inputs
		mainClk	: in std_logic;
		slowClk	: in std_logic;
		-- Main reset input
		reset		: in std_logic;
		-- MCU interface (UART, I2C)
		mcuUartTx	: in std_logic;
		mcuUartRx	: out std_logic;
		mcuI2cScl	: in std_logic;
		mcuI2cSda	: inout std_logic;
		-- Logic state analyzer/stimulator
		lsasBus	: inout std_logic_vector( 0 to 31 );
		-- Dip switches
		switches	: in std_logic_vector( 7 downto 0 );
		-- LEDs
		leds		: out std_logic_vector( 3 downto 0 )
	);
end user;

architecture behavioural of user is

	signal clk: std_logic;
	signal pllLock: std_logic;


	component myAltPll
		PORT
		(
			areset		: IN STD_LOGIC  := '0';
			inclk0		: IN STD_LOGIC  := '0';
			c0		: OUT STD_LOGIC ;
			locked		: OUT STD_LOGIC 
		);
	end component;

	component FMC
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
	end component;

	component RF
	    generic (
	        WORD_SIZE : natural := 16;
	        ADDRESS_SIZE : natural := 4
	    );
	    port (
	        Clock : in std_logic;

	        ChipSelect : in std_logic;

	        Read  : in std_logic;
	        Write : in std_logic;

	        DataIn  : in  std_logic_vector(WORD_SIZE-1 downto 0);
	        DataOut : out std_logic_vector(WORD_SIZE-1 downto 0);
	        Address : in  std_logic_vector(ADDRESS_SIZE-1 downto 0)
	    );
	end component;

	signal sCS, sRD, sWR : std_logic;
	signal sMem_Dout, sMem_Din : std_logic_vector(15 downto 0);
	signal sMem_A : std_logic_vector(15 downto 0);

	signal sAD : std_logic_vector(15 downto 0);
	
begin

	sAD <= lsasBus(30 to 31) & lsasBus(16 to 17) & lsasBus(7 to 15) & lsasBus(24 to 26);

--**********************************************************************************
--* Main clock PLL
--**********************************************************************************

	myAltPll_inst : myAltPll PORT MAP (
		areset	 => reset,
		inclk0	 => mainClk,
		c0	 => clk,
		locked	 => pllLock
	);

--**********************************************************************************
--* LEDs
--**********************************************************************************

	leds <= switches( 3 downto 0 );
	
--**********************************************************************************
--* FMC	
--**********************************************************************************
	FMC_inst : FMC
		port map (
			CLK     => clk,
			RST_n   => reset, 

			NE1     => lsasBus(23),
			NOE     => lsasBus(20),
			NWE     => lsasBus(21),
			AD      => sAD,

			CS      => sCS,
			RD      => sRD,
			WR      => sWR,

			Mem_Dout => sMem_Dout,
			Mem_Din  => sMem_Din,
			Mem_A    => sMem_A
		);
--**********************************************************************************
--* Register File
--**********************************************************************************
	RF_inst : RF
		generic map (
			WORD_SIZE => 16,
			ADDRESS_SIZE => 16
		)
		port map (
			Clock => clk,

			ChipSelect => sCS,

			Read  => sRD,
			Write => sWR,

			DataIn  => sMem_Dout,
			DataOut => sMem_Din,
			Address => sMem_A
		);
	
	
end behavioural;

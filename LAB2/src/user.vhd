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

			AD_in   : in  std_logic_vector(15 downto 0);
			AD_out  : out std_logic_vector(15 downto 0);
			Din_OE  : out std_logic; -- tri-state

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
	        WORD_SIZE : natural;
	        ADDRESS_SIZE : natural
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
	signal sCLK, sNE1, sNOE, sNWE : std_logic;
	signal sMem_Dout, sMem_Din, sMem_A : std_logic_vector(15 downto 0);

	signal AD_in, AD_out : std_logic_vector(15 downto 0);
	signal sDin_OE : std_logic;
	
	-- Address mapping ottenuto usando la tabella nel lab2.pdf
	constant AD_MAP : integer_vector(15 downto 0) :=
		(26, 25, 24, 15, 14, 13, 12, 11, 10, 9, 8, 7, 17, 16, 31, 30);
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

	leds <= not switches( 3 downto 0 );
	
--**********************************************************************************
--* FMC	
--**********************************************************************************

	AD_InOutBus:
	for i in AD_in'range generate
		AD_in(i) <= lsasBus(AD_MAP(i));
		lsasBus(AD_MAP(i)) <= AD_out(i) when sDin_OE else 'Z';
	end generate;

	sNE1 <= lsasBus(23);
	sNOE <= lsasBus(20);
	sNWE <= lsasBus(21);
	sCLK <= lsasBus(19);

	FMC_inst : FMC
		port map (
			CLK     => sCLK,
			RST_n   => reset, 

			NE1     => sNE1,
			NOE     => sNOE,
			NWE     => sNWE,

			AD_In	=> AD_In,
			AD_Out	=> AD_Out,
			Din_OE  => sDin_OE,

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
			Clock => sCLK,

			ChipSelect => sCS,
			Read  => sRD,
			Write => sWR,

			DataIn  => sMem_Din,
			DataOut => sMem_Dout,
			Address => sMem_A(7 downto 0)
		);
	
	
end behavioural;

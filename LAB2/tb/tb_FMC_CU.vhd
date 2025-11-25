library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_FMC_CU is
end tb_FMC_CU;

architecture behavior of tb_FMC_CU is

    -- DUT
    component FMC_CU is
        port (
            RST_n     : in  std_logic; -- async reset
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

    -- Testbench signals
    signal CLK      : std_logic := '0';
    signal RST_n        : std_logic := '1';
    signal NE1, NOE, NWE : std_logic;
    signal CS, RD, WR   : std_logic;
    signal Dout_En, A_En, Din_En : std_logic;
    signal Din_OE      : std_logic;


    signal AD       : std_logic_vector(15 downto 0);

    constant Tck : time := 100 ns;
    constant tco : time := 5 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: FMC_CU
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

    -- Clock generation process
    clk_process: process
    begin
        clk <= '0';
        wait for Tck / 2;
        clk <= '1';
        wait for Tck / 2;
    end process;

    -- Stimulus process
    stimulus_process: process
    begin
        -- Initialize inputs
        RST_n <= '0';
        NE1 <= '1';
        NWE <= '1';
        NOE <= '1';
        AD <= (others => 'Z');

        RST_n <= '1' after tco;

        wait for Tck;

        NE1 <= '0' after tco;
        NWE <= '0' after 2*tco;
        AD <= "1010101010101010" after 3*tco;

        wait for 2*Tck;
        AD <= (others => 'Z');
        wait for Tck;
        AD <= "1111000011110000" after tco;
        wait for Tck;
        AD <= "1111000011110000" after tco;
        wait for 0.5*Tck;
        NE1 <= '1' after 3*tco;
        NWE <= '1' after 2*tco;

        wait for 5*Tck;
        AD <= (others => 'Z');

        --LETTURA
        wait for 4.5*Tck;

        -- Add test vectors here
        wait for Tck; -- fronte di discesa

        NE1 <= '0' after tco;
        AD <= "1010101010101010" after 3*tco;

        wait for 2*Tck;

        AD <= (others => 'Z');
        NOE <= '0' after 3*tco;

        wait for 2.5 * Tck;

        NE1 <= '1' after 2*tco;
        NOE <= '1' after 1*tco;

        wait for 5.5*Tck;

        RST_n <= '0' after tco;

        -- End simulation
        wait;
    end process;

end behavior;
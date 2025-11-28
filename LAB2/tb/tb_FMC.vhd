library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_FMC is
end tb_FMC;

architecture behavior of tb_FMC is

    -- DUT
    component FMC is
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

    component RF is
        generic (
            WORD_SIZE : natural;
            ADDRESS_SIZE : natural
        );
        port (
            Clock : in std_logic;

            -- Abilita operazioni di Read/Write solo se la memoria è selezionata
            ChipSelect : in std_logic;

            Read  : in std_logic;
            Write : in std_logic;

            DataIn  : in  std_logic_vector(WORD_SIZE-1 downto 0);
            DataOut : out std_logic_vector(WORD_SIZE-1 downto 0);
            Address : in  std_logic_vector(ADDRESS_SIZE-1 downto 0)
        );
    end component;

    -- Testbench signals
    signal CLK : std_logic := '0';
    signal RST_n : std_logic := '1';
    signal NE1, NOE, NWE : std_logic;
    signal CS, RD, WR   : std_logic;
    signal AD, Mem_Dout, Mem_Din, Mem_A : std_logic_vector(15 downto 0);

    constant Tck : time := 100 ns;
    constant tco : time := 5 ns;

begin
    DUT: FMC
        port map (
            RST_n   => RST_n,
            CLK     => CLK,
            NE1     => NE1,
            NOE     => NOE,
            NWE     => NWE,
            AD      => AD,

            CS      => CS,
            RD      => RD,
            WR      => WR,

            Mem_Dout => Mem_Dout,
            Mem_Din  => Mem_Din,
            Mem_A    => Mem_A
        );
    
    MEM_inst : RF
        generic map (
            WORD_SIZE => 16,
            ADDRESS_SIZE => 16
        )
        port map (
            Clock => CLK,
            ChipSelect => CS,
            Read => RD,
            Write => WR,
            DataIn => Mem_Din,
            DataOut => Mem_Dout,
            Address => Mem_A
        );

    -- Clock generation process
    clk_process: process
    begin
        clk <= '0';
        wait for Tck / 2;
        clk <= '1';
        wait for Tck / 2;
    end process;

    stimulus_process: process
    begin
        -- INIZIALIZZAZIONE
        RST_n <= '0';
        NE1 <= '1';
        NWE <= '1';
        NOE <= '1';
        AD <= (others => 'Z');

        RST_n <= '1' after tco;

        -- SCRITTURA A UN CICLO
        wait for Tck; -- fronte di discesa

        NE1 <= '0' after tco;
        NWE <= '0' after 2*tco;
        AD <= X"AAAA" after 3*tco; -- indirizzo

        wait for 2*Tck;
        AD <= (others => 'Z');
        wait for Tck;
        AD <= x"F00D" after tco; -- dato
        wait for Tck/2;
        NE1 <= '1' after 3*tco;
        NWE <= '1' after 2*tco;

        wait for 2*Tck;
        AD <= (others => 'Z');
        wait for Tck/2;

        -- SCRITTURA A DUE CICLI COSTANTE
        wait for Tck; -- fronte di discesa

        NE1 <= '0' after tco;
        NWE <= '0' after 2*tco;
        AD <= x"AAAB" after 3*tco; -- indirizzo

        wait for 2*Tck;
        AD <= (others => 'Z');
        wait for Tck;
        AD <= x"BABE" after tco; -- dato
        wait for Tck;
        AD <= x"BABE" after tco; -- dato (costante)
        wait for Tck/2;
        NE1 <= '1' after 3*tco;
        NWE <= '1' after 2*tco;

        wait for 2*Tck;
        AD <= (others => 'Z');
        wait for Tck/2;

        -- SCRITTURA A DUE CICLI VARIABILE
        wait for Tck; -- fronte di discesa

        NE1 <= '0' after tco;
        NWE <= '0' after 2*tco;
        AD <= X"AAAC" after 3*tco; -- indirizzo

        wait for 2*Tck;
        AD <= (others => 'Z');
        wait for Tck;
        AD <= x"BABE" after tco; -- dato 1 (sarà sovrascritto)
        wait for Tck;
        AD <= x"CAFE" after tco; -- dato finale
        wait for Tck/2;
        NE1 <= '1' after 3*tco;
        NWE <= '1' after 2*tco;

        wait for 2*Tck;
        AD <= (others => 'Z');
        wait for Tck/2;

        --

        wait for 4*Tck;

        -- LETTURA 1
        wait for Tck; -- fronte di discesa

        NE1 <= '0' after tco;
        AD <= x"AAAA" after 3*tco;

        wait for 2*Tck;

        AD <= (others => 'Z');
        NOE <= '0' after 3*tco;

        wait for 2.5*Tck;

        NE1 <= '1' after 2*tco;
        NOE <= '1' after 1*tco;

        wait for 1.5*Tck;

        -- LETTURA 2
        wait for Tck; -- fronte di discesa

        NE1 <= '0' after tco;
        AD <= x"AAAB" after 3*tco;

        wait for 2*Tck;

        AD <= (others => 'Z');
        NOE <= '0' after 3*tco;

        wait for 4.5*Tck; -- lettura prolungata

        NE1 <= '1' after 2*tco;
        NOE <= '1' after 1*tco;

        wait for 1.5*Tck;

        -- LETTURA 3
        wait for Tck; -- fronte di discesa

        NE1 <= '0' after tco;
        AD <= x"AAAC" after 3*tco;

        wait for 2*Tck;

        AD <= (others => 'Z');
        NOE <= '0' after 3*tco;

        wait for 2.5*Tck;

        NE1 <= '1' after 2*tco;
        NOE <= '1' after 1*tco;

        -- FINE SIMULAZIONE
        wait for 5.5*Tck;
        RST_n <= '0' after tco;
        wait;
    end process;

end behavior;
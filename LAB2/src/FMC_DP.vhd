library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FMC_DP is
    port (
        CLK     : in  std_logic;
        AD      : inout std_logic_vector(15 downto 0);
        RST_n   : in  std_logic;

        Dout_En : in std_logic;
        A_En    : in std_logic;
        Din_En  : in std_logic;
        Din_OE  : in std_logic; -- tri-state
        
        CS,RD,WR : in std_logic
        
    );
end FMC_DP;

architecture Behavioral of FMC_DP is

    signal Mem_A : std_logic_vector(15 downto 0);
    signal Mem_Din : std_logic_vector(15 downto 0);
    signal Mem_Dout : std_logic_vector(15 downto 0);
    signal Din_Buffer : std_logic_vector(15 downto 0);

    component regn
        generic (N : integer:=4; RISING : boolean := true);
        port (
            R       : in std_logic_vector(N-1 downto 0);
            Clock, Resetn, Enable : in std_logic; -- rst sincrono, enable attivo alto
            Q       : out std_logic_vector(N-1 downto 0)
        );
    end component;

    component RF
        generic (
            WORD_SIZE : natural := 16;
            ADDRESS_SIZE : natural := 16
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

begin
    A_REG : regn generic map(N => 16, RISING => true)
    port map
    (
        R => AD,
        Clock => CLK,
        Resetn => RST_n,
        Enable => A_En,
        Q => Mem_A
    );

    Dout_REG : regn generic map(N => 16, RISING => true)
    port map
    (
        R => AD,
        Clock => CLK,
        Resetn => RST_n,
        Enable => Dout_En,
        Q => Mem_Din
    );

    Din_REG : regn generic map(N => 16, RISING => false)
    port map
    (
        R => Mem_Dout,
        Clock => CLK,
        Resetn => RST_n,
        Enable => Din_En,
        Q => Din_Buffer
    );
    
    AD <= Din_Buffer when Din_OE = '1' else (others => 'Z');

    MEM_RF : RF generic map(WORD_SIZE => 16, ADDRESS_SIZE => 16)
    port map
    (
        Clock => CLK,
        ChipSelect => CS,
        Read => RD,
        Write => WR,
        DataIn => Mem_Din,
        DataOut => Mem_Dout,
        Address => Mem_A
    );
end Behavioral;


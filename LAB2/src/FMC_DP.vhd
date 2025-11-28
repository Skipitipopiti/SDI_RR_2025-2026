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
        Din_OE  : in std_logic; -- tri-state enable

        Mem_Dout : in std_logic_vector(15 downto 0);
        Mem_Din  : out std_logic_vector(15 downto 0);
        Mem_A    : out std_logic_vector(15 downto 0)
    );
end FMC_DP;

architecture Behavioral of FMC_DP is

    signal Din : std_logic_vector(15 downto 0);

    component regn
        generic (N : integer:=4; RISING : boolean := true);
        port (
            R       : in std_logic_vector(N-1 downto 0);
            Clock, Resetn, Enable : in std_logic; -- rst sincrono, enable attivo alto
            Q       : out std_logic_vector(N-1 downto 0)
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
        Q => Din
    );
    
    AD <= Din when Din_OE = '1' else (others => 'Z');

end Behavioral;


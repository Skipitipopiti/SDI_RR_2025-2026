library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FMC_DP is
    port (
        CLK     : in  std_logic;
        RST_n   : in  std_logic;

        AD_in   : in  std_logic_vector(15 downto 0);
        AD_out  : out std_logic_vector(15 downto 0);

        Dout_En : in std_logic;
        A_En    : in std_logic;
        Din_En  : in std_logic;

        Mem_Dout : in std_logic_vector(15 downto 0);
        Mem_Din  : out std_logic_vector(15 downto 0);
        Mem_A    : out std_logic_vector(15 downto 0)
    );
end FMC_DP;

architecture Behavioral of FMC_DP is

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
        R => AD_in,
        Clock => CLK,
        Resetn => RST_n,
        Enable => A_En,
        Q => Mem_A
    );

    Dout_REG : regn generic map(N => 16, RISING => true)
    port map
    (
        R => AD_in,
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
        Q => AD_out
    );

end Behavioral;


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all;

entity regn is
	generic (N : integer:=4; RISING : boolean := true);
	port (
		R 					  : in std_logic_vector(N-1 downto 0);
		Clock, Resetn, Enable : in std_logic; -- rst sincrono, enable attivo alto
		Q 					  : out std_logic_vector(N-1 downto 0)
	);
end regn;

architecture Behavior of regn is
begin
	process (Clock, Resetn)
	begin
		if (Resetn = '0') then
			Q <= (others => '0');
		elsif RISING = true then
			if (rising_edge(Clock)) then
				if Enable = '1' then
					Q <= R;
				end if;
			end if;
		elsif RISING = false then
			if falling_edge(Clock) then
				if Enable = '1' then
					Q <= R;
				end if;
			end if;
		end if;
	end process;
end Behavior;

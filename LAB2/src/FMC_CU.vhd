library ieee;
use ieee.std_logic_1164.all;

entity FMC_CU is
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
end FMC_CU;

architecture Behavioral of FMC_CU is
    type state_type is (IDLE, GET_ADDR, WRITE_WAIT, SAMPLE, SAMPLE_WRITE, WRITE, MEM_READ, D_OUT);
    signal state : state_type;
begin
    process (CLK, RST_n)
    begin
        if RST_n = '0' then
            state <= IDLE;
        elsif falling_edge(CLK) then
            case state is
                when IDLE =>
                    if NE1 = '0' then
                        state <= GET_ADDR;
                    else
                        state <= IDLE;
                    end if;
                when GET_ADDR =>
                    if NWE = '0' then
                        state <= WRITE_WAIT;
                    else
                        state <= MEM_READ;
                    end if;
                when WRITE_WAIT =>
                    state <= SAMPLE;
                when SAMPLE =>
                    if NE1 = '0' then
                        state <= SAMPLE_WRITE;
                    else
                        state <= WRITE;
                    end if;
                when SAMPLE_WRITE =>
                    if NE1 = '0' then
                        state <= SAMPLE_WRITE;
                    else
                        state <= WRITE;
                    end if;
                when WRITE =>
                    state <= IDLE;
                when MEM_READ =>
                    state <= D_OUT;
                when D_OUT =>
                    if NE1 = '0' then
                        state <= D_OUT;
                    else
                        state <= IDLE;
                    end if;
                when others =>
                    state <= IDLE;
            end case;
        end if;
    end process;

    -- Output logic
    process (state, NE1, NOE) is
    begin
        CS <= '0';
        WR <= '0';
        RD <= '0';
        Dout_En <= '0';
        A_En <= '0';
        Din_En <= '0';
        Din_OE <= '0';

        case state is
            when IDLE =>
                null;
            when GET_ADDR =>
                A_En <= '1';
            when WRITE_WAIT =>
                null;
            when SAMPLE =>
                Dout_En <= '1';
            when SAMPLE_WRITE =>
                Dout_En <= '1';
                CS <= '1';
                WR <= '1';
            when WRITE =>
                CS <= '1';
                WR <= '1';
            when MEM_READ =>
                CS <= '1';
                RD <= '1';
                Din_En <= '1';
            when D_OUT =>
                if NOE = '0' and NE1 = '0' then
                    Din_OE <= '1';
                end if;
        end case;
    end process;
end Behavioral;
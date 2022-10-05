library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;



entity DA2_SPI is
-- spi_clk_f is limited to 30 MHz for DA2
generic(m_clk_f : in integer := 100e6;
            spi_clk_f : in integer := 10e6);
port ( clk : in std_logic; -- clock input
reset : in std_logic; -- reset, active high
load : in std_logic; -- notification to send data
data_in : in std_logic_vector(15 downto 0); -- pdata in
sdata_0 : out std_logic; -- serial data out 1
sdata_1 : out std_logic; -- serial data out 2
spi_clk : out std_logic; -- clk out to SPI devices
CS0_n : out std_logic); -- chip select 1, active low
end DA2_SPI;

architecture Behavioral of DA2_SPI is

signal baud_timer : integer := m_clk_f/spi_clk_f;
signal baud_load : std_logic := '0';
signal baud_load_val : integer;
signal BIT_COUNT : integer := 0;
signal bit_rst : std_logic := '0';
signal BIT_En : std_logic := '0';

type STATES is (idle, tx1, tx2);

signal state_spi :STATES := idle;
signal flag_out: std_logic := '0';
constant FULL_COUNT : integer:= 100e6 / 115200;
constant HALF_COUNT : integer:= FULL_COUNT/2;

begin
baud_load_val <= HALF_COUNT when STATE_SPI = IDLE else FULL_COUNT;  --What is Half_count and Full_count
CS0_n <= '0' when state_spi = tx1  or state_spi = tx2 else '1';
--Case Process
process(clk,reset)
begin
    if reset='1' then 
        state_spi <= IDLE;
       CS0_n<='1';
    elsif rising_edge(clk) then
        case state_spi is
            when IDLE=>
               if flag_out = '1' then
                    CS0_n <= '1';
               else
                    flag_out<= '0';
               if load = '1' then
                    state_spi<=tx1;
               else 
                    state_spi<=IDLE;
               end if;
               end if;
               
            when tx1=>
                --Figure out what to put into the tx1
                --This state should be the buffer function so load stuff in
               
                if something then
                    something
                else
                    something
                end if;
            when tx2=>
            --This should be the shift function
                if something then
                    something
                else
                    something
                end if;
        end case;
    end if;
end process;
--Baud counter
process (clk, reset)
begin
    if reset = '1' then
        baud_timer <= HALF_COUNT;
    elsif falling_edge(clk) then
        if baud_load = '1' then
            baud_timer <= baud_load_val;
        elsif baud_timer > 0 then
            baud_timer <= baud_timer - 1;
        else
            baud_timer <= 0; -- prevents baud timer from going negative
        end if;
    end if;
end process;
--bit counter
process (clk, reset)
begin
    if reset = '1' then
        BIT_COUNT <= 0;
    elsif falling_edge(clk) then
        if bit_rst = '1' then
            BIT_COUNT <= 0;
        elsif BIT_COUNT < 8 AND BIT_En = '1' then --BC can't exceed 8
            BIT_COUNT <= BIT_COUNT + 1;
        else
            BIT_COUNT <= BIT_COUNT;
        end if;
    end if;
end process;
end Behavioral;

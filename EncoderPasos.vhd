library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity EncoderPasos is port (
	salsl, sals: out std_logic_vector(3 downto 0);
	led : out std_logic_vector(1 downto 0);
	en1,en2,clock : in std_logic;
	sensor1,sensor2,sensor3 : in std_logic;
	buz2 : out std_logic;
	buz : out std_logic);
end EncoderPasos;

architecture Behavioral of EncoderPasos is
	signal clk,uhr0,uhr1: std_logic := '1';
	signal ent1,ent2: std_logic := '1';
	signal delay1,delay2,delay3,delay4: std_logic := '1';
	signal delay5,delay6,delay7,delay8: std_logic := '1';
	signal cont0,cont1 : integer:= 1;
	signal sal: std_logic_vector (2 downto 0):= "001";
	signal motor: std_logic_vector (3 downto 0):= "0001";
begin
clk <= clock; --Señal de reloj
sals<= motor; --Señal para electroimanes del motor
salsl<= motor;--Señales a leds para monitoreo
buz <= sensor1 or sensor2 or sensor3;--sensores a le de monitoreo
buz2<= sensor1 or sensor2 or sensor3;--sensores a buzer

---------Main process---------
process (uhr1,ent1,ent2) begin
	if uhr1'event and uhr1 = '1' then
		if ent1'event and ent1 = '0' then
		--Caso de giro en sentido horario
			if ent2 = '1' and sensor3 = '0' then
				sal <= sal + "001";
				led <= "10";
		--Caso de limite en sentido horario
			elsif ent2 = '1' and sensor3 = '1' then
				sal <= sal;
				led <= "10";
		--Caso de giro en sentido antihorario
			elsif ent2 = '0' and sensor1 = '0' then
				sal <= sal - "001";
				led <= "01";
		--Caso de limite en sentido antihorario
			elsif ent2 = '0' and sensor1 = '1' then
				sal <= sal;
				led <= "01";
			else
				sal <= sal;
				led <= "11";
			end if;
		else
			sal <= sal;
		end if;
	end if;
end process;

----Proceso de secuencia de electroimanes----
process(sal) begin
	case sal is
		when "000" => motor <= "0001";
		when "001" => motor <= "0011";
		when "010" => motor <= "0010";
		when "011" => motor <= "0110";
		when "100" => motor <= "0100";
		when "101" => motor <= "1100";
		when "110" => motor <= "1000";
		when "111" => motor <= "1001";
		when others => motor <= "0000";
	end case;
end process;

---------Filtro 1 y 2 ---------
--Filtro entrada encoder 1 de 4 flipflops
process(uhr0,en1,delay1,delay2,delay3,delay4) begin
	if (uhr0'event and uhr0 = '1') then
		delay1 <= en1;
		delay2 <= delay1;
		delay3 <= delay2;
		delay4 <= delay3;
	end if;
	ent1 <= delay1 and delay2 and delay3 and delay4;
end process;
--Filtro entrada encoder 2 de 4 flipflops
process(uhr0,en2,delay5,delay6,delay7,delay8) begin
	if (uhr0'event and uhr0 = '1') then
		delay5 <= en2;
		delay6 <= delay5;
		delay7 <= delay6;
		delay8 <= delay7;
	end if;
	ent2 <= delay5 and delay6 and delay7 and delay8;
end process;

---------Div. Frec. 1---------
process (clk) begin--Para filtro de señal
	if clk'event and clk = '1' then
		if cont0 = 42828 then --583.73Hz
			cont0 <= 1;
			uhr0 <= not uhr0;
		else
			cont0 <= cont0 + 1;
		end if;
	end if;
end process;
---------Div. Frec. 2---------
process (clk) begin--Para Main process
	if clk'event and clk = '1' then
		if cont1 = 125000 then --2kHz
			cont1 <= 1;
			uhr1 <= not uhr1;
		else
			cont1 <= cont1 + 1;
		end if;
	end if;
end process;
end Behavioral;
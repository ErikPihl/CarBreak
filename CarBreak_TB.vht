----------------------------------------------------------------------------------------------
-- Modulen CarBreak_TB används som testbänk för modulen CarBreak, som utgör ett bromssystem 
-- för en bil. I denna modul deklareras signaler med samma namn som i toppmodulen, där 
-- simulering sker för att verifiera så att bilen bromsar ifall föraren trycker ned 
-- bromspedalen eller om ADAS-systemet fungerar och indikerar att ett större föremål närmar
-- sig bilen.
--
-- Simulering sker under 160 ns enligt nedan, där break utgör förväntad utsignal:
--
-- Tid (ns)     driver     camera     sensor     ADAS_OK     break
----------------------------------------------------------------------------------------------
--   10           0          0          0           0          0
--   20           0          0          0           1          0
--   30           0          0          1           0          0
--   40           0          0          1           1          0
--   50           0          1          0           0          0
--   60           0          1          0           1          0
--   70           0          1          1           0          0
--   80           0          1          1           1          1
--   90           1          0          0           0          1
--   100          1          0          0           1          1
--   110          1          0          1           0          1
--   120          1          0          1           1          1
--   130          1          1          0           0          1
--   140          1          1          0           1          1
--   150          1          1          1           0          1
--   160          1          1          1           1          1
----------------------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity CarBreak_TB is
end entity;

architecture Behaviour of CarBreak_TB is

----------------------------------------------------------------------------------------------
-- Nedanstående signaler används för simulering av in- och utportar med samma namn i 
-- toppmodulen genom sammankoppling via en instans av toppmodulen döpt CarBreak1.
----------------------------------------------------------------------------------------------
signal driver  : std_logic; -- Simulerar bromssignal från förare.
signal camera  : std_logic; -- Indikerar större föremål nära bilen.
signal radar   : std_logic; -- Indikerar att ett föremål närmar sig bilen.
signal ADAS_OK : std_logic; -- Indikerar att ADAS-systemet är okej.
signal break   : std_logic; -- Bromsar bilen.

----------------------------------------------------------------------------------------------
-- Komponenten CarBreak används för att instansiera konstruktionens toppmodul, vilket görs
-- för att kunna simulera denna. Notera att denna komponent är identisk med toppmodulens
-- entitet CarBreak. Efter att denna entitet har deklarerats som en komponent så kan en
-- instans av denna skapas, följt av sammankoppling av dess in- och utsignaler med
-- signaler med samma namn för simulering.
----------------------------------------------------------------------------------------------
component CarBreak is
	port
	(
      driver  : in std_logic; -- Bromssignal från förare.
		camera  : in std_logic; -- Indikerar större föremål framför bilen.
		radar   : in std_logic; -- Indikerar att ett föremål närmar sig bilen.
		ADAS_OK : in std_logic; -- Indikerar att ADAS-systemet är okej.
      break   : out std_logic -- Bromsar bilen.						 : out std_logic
	);
end component;

begin

	------------------------------------------------------------------------------------
	-- Instansen CarBreak1 används för att skapa en instans (ett objekt) av toppmodulen
	-- CarBreak, där in- och utportarna i toppmodulen sammankopplas med signaler med
	-- samma namn. Därmed gäller att ifall de simulerade insignalerna tilldelas ett
	-- värde, så tilldelas detta till insignalerna i toppmodulen. Då uppdateras
	-- toppmodulens utsignal break, vars signal tilldelas till den simulerade 
	-- insignalen med samma namn. Därmed kan konstruktionen enkelt simuleras.
	------------------------------------------------------------------------------------
	CarBreak1 : CarBreak port map
	(
		driver  => driver,
		camera  => camera,
		radar   => radar,
		ADAS_OK => ADAS_OK,
		break   => break
	);
	
	DRIVER_PROCESS: process is
	begin
		driver <= '0';
		wait for 80 ns;
		driver <= '1';
		wait for 80 ns;
		wait;
	end process;
	
	CAMERA_PROCESS: process is
	begin
		for i in 0 to 1 loop
			camera <= '0';
			wait for 40 ns;
			camera <= '1';
			wait for 40 ns;
		end loop;
		wait;
	end process;
	
	RADAR_PROCESS: process is 
	begin
		for i in 0 to 3 loop
			radar <= '0';
			wait for 20 ns;
			radar <= '1';
			wait for 20 ns;
		end loop;
		wait;
	end process;
	
	ADAS_OK_PROCESS: process is
	begin
		for i in 0 to 7 loop
			ADAS_OK <= '0';
			wait for 10 ns;
			ADAS_OK <= '1';
			wait for 10 ns;
		end loop;
		wait;
	end process;

end architecture;
----------------------------------------------------------------------------------------------
-- Modulen CarBreak används som bromssystem för en bil. Bilen bromsar ifall föraren trycker
-- ned bromspedalen eller om ADAS-systemet indikerar detta, vilket sker ifall ett större 
-- föremål närmar sig framför bilen. En kamera används för att avgöra ifall ett större föremål 
-- är placerad framför bilen, medan en radar indikerar ifall ett givet föremål närmar sig. 
-- Hög signal från ADAS-systemet innebär därmed att en bil eller ett annat stort föremål
-- närmar sig bilen. Ifall ADAS-systemet inte fungerar som det ska så kan enbart föraren 
-- bromsa; insignaler från kameran och radarn kommer då ignoreras tills ADAS-systemet 
-- fungerar som det skall igen.
----------------------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity CarBreak is
   port
   (
      driver  : in std_logic; -- Bromssignal från förare.
		camera  : in std_logic; -- Indikerar större föremål framför bilen.
		radar   : in std_logic; -- Indikerar att ett föremål närmar sig bilen.
		ADAS_OK : in std_logic; -- Indikerar att ADAS-systemet är okej.
      break   : out std_logic -- Bromsar bilen.
   );
end entity;

architecture Behaviour of CarBreak is
signal ADAS : std_logic; -- Utsignal från ADAS-systemet, hög ifall bilen skall bromsas.
begin

	------------------------------------------------------------------------------------
	-- Processen ADAS_PROCESS används för att realisera utsignalen från ADAS-systemet,
	-- som blir hög för att bromsa bilen ifall kameran indikerar ett större föremål
	-- framför bilen samtidigt som radarn indikerar att föremålet närmar sig. Annars
	-- blir utsignalen från ADAS_systemet låg, vilket också gäller vid fel på 
	-- ADAS-systemet då signalerna från kameran samt sensorn ignoreras.
	------------------------------------------------------------------------------------
	ADAS_PROCESS: process (camera, radar, ADAS_OK) is
	begin
		if (camera = '1' and radar = '1' and ADAS_OK = '1') then
			ADAS <= '1';
		else
			ADAS <= '0';
		end if;
	end process;
	
	------------------------------------------------------------------------------------
	-- Processen BREAK_PROCESS används för att bromsa bilen ifall föraren trycker ned
	-- bromspedan eller om ADAS-systemet indikerar att ett stort föremål närmar sig
	-- bilen. Annars sker ingen inbromsning.
	------------------------------------------------------------------------------------
	BREAK_PROCESS: process (driver, ADAS) is
	begin
		if (driver = '1' or ADAS = '1') then
			break <= '1';
		else
			break <= '0';
		end if;
	end process;
	
end architecture;
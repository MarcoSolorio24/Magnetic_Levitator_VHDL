Library IEEE;
Use IEEE.Std_Logic_1164.All;
Use IEEE.Numeric_Std.all;

Entity Timer is
	GENERIC(
	   Ticks : integer := 10
	);
	PORT(
		RST : in Std_Logic;
		CLK : in Std_Logic;
		EOT : out Std_Logic
	);
End Timer;

Architecture Behavioral of Timer is	  
Signal Cp, Cn : integer := 0;
Begin 
	
	Combinational : Process(Cp)	 
	Begin			  
		if Cp = (Ticks - 1) then
			Cn <= 0;
			EOT <= '1';
		else
			Cn <= Cp + 1;
			EOT <= '0';
		End if;
	End Process Combinational;
	
	Sequential : Process(RST,CLK)
	Begin	  
		if RST = '0' then
			Cp <= 0;
		elsif CLK'event and CLK = '1' then
			Cp <= Cn;
		end if;
	End Process Sequential;
	
End Architecture Behavioral;


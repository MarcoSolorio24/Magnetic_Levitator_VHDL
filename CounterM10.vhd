Library IEEE;
Use IEEE.numeric_Std.all;
Use IEEE.Std_Logic_1164.all;

Entity CounterM10 is 
	PORT(
	RST : in Std_Logic;
	CLK : in Std_Logic;
	ENI : in Std_Logic;
	ENO : out Std_Logic;
	CNT : out Std_Logic_vector(3 downto 0)
	);
End Entity CounterM10;

Architecture Behavioral of CounterM10 is  
Signal Cn, Cp : integer := 0;--bit_Vector(nBits - 1 downto 0;)
Begin	
	
	Combinational : Process(Cp, ENI)
	Begin
		--if Cp = 9 and ENI = '1' then
--			ENO <= '1';
--			Cn <= 0;
--		elsif ENI = '1' then
--			Cn <= Cp + 1;
--			ENO <= '0';
--		else 
--			Cn <= Cp;
--			ENO <= '0';
--		end if;	
		if ENI = '1' then
			if Cp = 9 then
				Cn <= 0;
				ENO<= '1';
			else
				Cn <= Cp + 1;
				ENO <= '0';
			end if;
		else
			Cn <= Cp; 
			ENO <= '0';
		end if;
		CNT <= Std_Logic_vector(to_unsigned(Cp,4));
	End Process Combinational;
	
	Sequential : Process(CLK,RST)
	Begin	
		if RST = '0' then  
			Cp <= 0;   --(others => '0');
		elsif CLK'event and CLK  = '1' then
			Cp <= Cn;	
		end if;
	End Process Sequential;
End Architecture Behavioral;



--if ENI = '1' then
--	if Cp = 9 then
--		Cn <= 0;
--		ENO = '1';
--	else
--		Cn = Cp + 1;
--		ENO <= '0';
--	end if;
--else
--	Cn <= Cp; 
--	ENO <= '0';
--end if;

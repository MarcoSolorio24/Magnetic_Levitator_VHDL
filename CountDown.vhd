Library IEEE;
Use IEEE.Std_logic_1164.all;
Use IEEE.Numeric_Std.all;
Use IEEE.STD_LOGIC_Arith.All;

Entity CountDown is
	GENERIC(
	
		  Num : integer := 10
	);
	PORT(
		RST : in Std_Logic;
		CLK : in Std_Logic;
		DEC : in Std_Logic;
		RDY : out Std_Logic
	);
End CountDown;

Architecture Behavioral of CountDown is	
Signal Cn, Cp : integer := Num;
Begin					
	
--	Combinational : Process(Cp,DEC)
--	Begin
--		if(DEC = '1')then  
--			if(Cp = 0)then
--				RDY <= '1'; 
--				Cn <= Cp;
--			else
--				Cn <= Cp - 1; 
--				RDY <= '0';
--			end if;
--		else   
--			Cn <= Cp;
--			RDY <= '0';
--		end if;	
--	End Process Combinational;
	
	
	Combinational : Process(Cp,DEC)
	Begin
		if(Cp = 0) then
			Cn <= Cp; 
			RDY <= '1';
		elsif (DEC = '0')then
			Cn <= Cp;
			RDY <= '0';
		else 
			Cn <= Cp - 1;
			RDY <= '0';
		end if;	

	End Process Combinational;
	
	
	FF : Process(RST, CLK)
    Begin	 
		if RST = '0' then
			Cp <= Num;
		elsif CLK'event and CLK = '1' then	  
			Cp <= Cn;
		end if;	
	End Process FF;
	
End Architecture Behavioral; 

--	Combinational : Process(Cp,DEC)
--	Begin
--		if Cp = 0 then
--			EOC <= '1';
--			Cn <= 0
--		elsif DEC = '1' then
--			EOC <= '0'
--			Cn <= Cp  - 1;
--		else	 
--			EOC <= '0';
--			Cn <= Cp;
--		end if;
--
--	End Process Combinational;
--
Library IEEE;
Use IEEE.Std_logic_1164.all;
Use IEEE.Numeric_Std.all;

Entity FreeRunCounter is 
	GENERIC(
		nBits : integer := 8
	);
	PORT(
	RST : in Std_Logic;
	CLK : in Std_Logic;
	INC : in Std_Logic;
	CNT : out Std_Logic_Vector(nBits-1 Downto 0)
	);
End FreeRunCounter;

Architecture Behavioral of FreeRunCounter is   
Signal Cp, Cn : integer := 0;
Begin		
	
	Combinational : Process(Cp, INC)
	Begin	 	
		if(INC = '1')then
			Cn <= Cp + 1;
		else   
			Cn <= Cp;
		end if;
		  CNT <= Std_Logic_vector(to_unsigned(Cp,nBits));
	End Process Combinational;
	
	
	FF : Process(RST,CLK)
	Begin  
		if(RST = '0') then
			Cp <= 0;
	    elsif CLK'event and CLK = '1' then
			Cp <= Cn;
		end if;	
	End Process FF;
End Behavioral;

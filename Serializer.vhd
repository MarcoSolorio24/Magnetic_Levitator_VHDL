Library IEEE;
Use IEEE.Std_logic_1164.all;
Use IEEE.Numeric_Std.all;
Use IEEE.STD_LOGIC_Arith.All;

Entity Serializer is
	GENERIC(
		BusWidth : Integer := 7	
	);
	PORT(
	RST : in Std_Logic;
	CLK : in Std_Logic;
	LDR : in Std_Logic;
	SHF : in Std_Logic;
	DIN : in Std_Logic_Vector(BusWidth - 1 downto 0);
	BOUT : out Std_Logic
	);											
End Entity Serializer;

Architecture Behavioral of Serializer is
Signal Qp, Qn : Std_Logic_Vector(BusWidth - 1 downto 0) := (Others => '1');
Signal Flag : Std_Logic_Vector(1 downto 0):= (Others => '0');
Begin  
	
	Flag <= LDR & SHF; 
	
	Combinational : Process(Qp,LDR,DIN,Flag)
	Begin  
		Case Flag is
			When "00" => 
				Qn <= Qp;
			When "01"=>	  
				Qn <= '1' & Qp(Qp'left downto 1) ;
			When Others => 
				Qn <= DIN;
		End Case;  
		
		BOUT <= Qp(0);
		
	End Process Combinational;
	
	Sequential : Process(RST, CLK)
	Begin 
		if RST = '0' then
				 Qp <= (Others => '0');
		elsif CLK'event and CLK = '1' then 
			   Qp <= Qn;
		end if;
		
	End Process Sequential;
	
End Architecture Behavioral;
Library IEEE;
Use IEEE.Std_logic_1164.all;
Use IEEE.Numeric_Std.all;
use IEEE.STD_LOGIC_Arith.All;

Entity Deserializer is
	GENERIC(
		BusWidth : Integer := 7	
	);
	PORT(
	RST : in Std_logic;
	CLK : in Std_logic;
	SHF : in Std_logic;
	BIN : in Std_logic;
	BOUT : out Std_logic_Vector(BusWidth - 1 downto 0)
	);											
End Entity Deserializer;

Architecture Behavioral of Deserializer is
Signal Qp, Qn : Std_logic_Vector(BusWidth - 1 downto 0) := (Others => '0'); 
Begin 
	
	
	Combinational : Process(SHF, BIN, Qp)
	Begin  
		if SHF = '0' then
			Qn <= Qp; 
		else 
			Qn <=  Qp(BusWidth - 2 downto 0) & BIN;
		end if;
		BOUT <= Qp;
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
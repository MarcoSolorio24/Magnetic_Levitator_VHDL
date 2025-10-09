Library IEEE;
Use IEEE.Std_logic_1164.all;
--Use IEEE.Numeric_Std.all;
--Use IEEE.STD_LOGIC_Arith.All;

Entity Toggle is 
	PORT(
	RST : in Std_Logic;
	CLK : in Std_Logic;
	TOG : in Std_Logic;
	TGS : out Std_Logic
	);
End Toggle;	

Architecture Behavioral of Toggle is 
Signal Qp,Qn : Std_Logic;
Begin
	
	Operacion : Process(TOG,Qp)
	begin		
		Qn <= Qp xor TOG;
		TGS <= Qp;
	End Process Operacion;
	
	
	FF : Process(RST, CLK)
	begin
		if RST = '0'then
			Qp <= '0';
		elsif CLK'event and CLK = '1' then 
			 Qp <= Qn;
		end if;				 
	end Process FF;
	
End Behavioral;

Library IEEE;
Use IEEE.Std_logic_1164.all;
Use IEEE.Numeric_Std.all;

Entity Delay is 
	GENERIC(
		N : integer := 10
	);
	PORT(
		RST : in Std_Logic;
		CLK : in Std_Logic;
		XIN : in Std_Logic;
		XRE : out Std_Logic
	);
End Entity Delay;

Architecture Behavioral of Delay is
Signal Qn,Qp: Std_Logic_vector(N-1 downto 0) := (others => '0');		
Constant Aux : Std_Logic_vector(N-1 downto 0) := (others => '1');
Begin	 
	
	XRE <= '1'when Qp = Aux else '0';
		
	Combinational : Process(Qp,XIN)
	begin	
		Qn <= XIN & Qp(N-1 downto 1);  	
	End Process Combinational;
	
	FF : Process(CLK, RST)
	begin 		
		if(RST = '0') then	 
			Qp <= (others => '0');
		elsif CLK'event and CLK = '1' then
			Qp <= Qn;
		end if;
	End Process FF;
End Behavioral;
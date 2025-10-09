Library IEEE; 
Use IEEE.Std_Logic_1164.all;
Use IEEE.Numeric_Std.all;

Entity FallingEdgeDetector is 
	GENERIC(
		N : integer := 10
	);
	PORT(
	RST : in Std_Logic;
	CLK : in Std_Logic;
	XIN : in Std_Logic;
	XRE : out Std_Logic
	);
End FallingEdgeDetector;

Architecture Behavioral of FallingEdgeDetector is
Signal Qn,Qp: Std_Logic_vector(N-1 downto 0) := (others => '1');		
Constant Aux : Std_Logic_vector(N-1 downto 0) := (others => '0');
Begin	 
	XRE <= '1' when (Qp(N-1 downto 1) = Aux(N-1 downto 1)) and (not Qp(0)) = '0'  else '0';
	
	Combinational : Process(Qp,XIN)
	begin	
		Qn <= XIN & Qp(N-1 downto 1);  	
		
		--XRE <= Qp(2) AND Qp(1) AND (NOT (Qp(0)));
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
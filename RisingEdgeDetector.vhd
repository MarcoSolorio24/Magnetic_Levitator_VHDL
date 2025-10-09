Library IEEE;
Use IEEE.Std_Logic_1164.All;
Use IEEE.Numeric_Std.all;
use IEEE.STD_LOGIC_Arith.All;

Entity RisingEdgeDetector is 
	GENERIC(
		N : integer := 10
	);
	PORT(
	RST : in Std_Logic;
	CLK : in Std_Logic;
	XIN : in Std_Logic;
	XRE : out Std_Logic
	);
End RisingEdgeDetector;

Architecture Behavioral of RisingEdgeDetector is
Signal Qn,Qp: Std_Logic_Vector(N-1 downto 0) := (others => '0');		
Constant Aux : Std_logic_Vector(N-1 downto 0) := (others => '1');
Begin	 
	XRE <= '1' when (Qp(N-1 downto 1) = Aux(N-1 downto 1)) and (not Qp(0)) = '1'  else '0';
	
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





--Library IEEE;
--Use IEEE.Std_Logic_1164.All;
--use IEEE.STD_LOGIC_Arith.All;
--
--Entity RisingEdgeDetector is 
--	GENERIC(
--		N : integer := 10
--	);
--	PORT(
--	RST : in bit;
--	CLK : in bit;
--	XIN : in bit;
--	XRE : out bit
--	);
--End RisingEdgeDetector;
--
--Architecture Behavioral of RisingEdgeDetector is
--Signal Qn,Qp: bit_vector(N-1 downto 0) := (others => '0');		
--Constant Aux : bit_vector(N-1 downto 0) := (others => '1');
--Begin	 
--	XRE <= '1' when (Qp(N-1 downto 1) = Aux(N-1 downto 1)) and (not Qp(0)) = '1'  else '0';
--	
--	Combinational : Process(Qp,XIN)
--	begin	
--		Qn <= XIN & Qp(N-1 downto 1);  	
--		
--		--XRE <= Qp(2) AND Qp(1) AND (NOT (Qp(0)));
--	End Process Combinational;
--	
--	FF : Process(CLK, RST)
--	begin 		
--		if(RST = '0') then	 
--			Qp <= (others => '0');
--		elsif CLK'event and CLK = '1' then
--			Qp <= Qn;
--		end if;
--	End Process FF;
--End Behavioral;	
	  





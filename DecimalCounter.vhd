Library IEEE;
Use IEEE.Std_Logic_1164.all;
Use IEEE.Numeric_Std.all;

Entity DecimalCounter is
	PORT(
	RST : in Std_Logic;
	CLK : in Std_Logic;
	ENI : in Std_Logic;
	ONES : out Std_Logic_vector(3 downto 0);
	TENS : out Std_Logic_vector(3 downto 0);
	HUND : out Std_Logic_vector(3 downto 0);
	THOU : out Std_Logic_vector(3 downto 0)
	);
End Entity DecimalCounter;


Architecture Structural of DecimalCounter is
-- Component Declaration-------------------------------------------------------------------
Component CounterM10 is 
	PORT(
	RST : in Std_Logic;
	CLK : in Std_Logic;
	ENI : in Std_Logic;
	ENO : out Std_Logic;
	CNT : out Std_Logic_vector(3 downto 0)
	);
End Component;
-- Signals Declaration ---------------------------------------------------------------------
Signal EN1, EN2, EN3 : Std_Logic;
Begin			   
-- Component Instances -------------------------------------------------------------------
	U01 : CounterM10 Port Map(RST, CLK, ENI, EN1, ONES);	
	U02 : CounterM10 Port Map(RST, CLK, EN1, EN2, TENS);
	U03 : CounterM10 Port Map(RST, CLK, EN2, EN3, HUND);
	U04 : CounterM10 Port Map(RST, CLK, EN3, OPEN, THOU);
	
	
	
	
	
End Architecture Structural;

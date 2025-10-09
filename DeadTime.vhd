Library IEEE;
Use IEEE.Std_logic_1164.all;
Use IEEE.Numeric_Std.all;


Entity DeadTime is
	GENERIC(
		DT : integer := 10
	);
	PORT(
		RST : in Std_logic;
		CLK : in Std_logic;
		PWM : in Std_logic;
		HO : out Std_logic;
		LO : out Std_logic
	);
End Entity DeadTime;


Architecture Structural of DeadTime is 

Component Delay is 
	GENERIC(
		N : integer := 10
	);
	PORT(
		RST : in Std_Logic;
		CLK : in Std_Logic;
		XIN : in Std_Logic;
		XRE : out Std_Logic
	);
End Component Delay;

Signal PWMN : Std_logic;

Begin	
	
	
	PWMN <= NOT(PWM);
	U01 : Delay Generic Map(DT) Port Map(RST, CLK, PWM, HO);   
	U02 : Delay Generic Map(DT) Port Map(RST, CLK, PWMN, LO);
	
End Architecture Structural;

	
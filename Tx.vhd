Library IEEE;
Use IEEE.Numeric_std.all;
Use IEEE.Std_Logic_1164.all;


Entity Tx is
	GENERIC(
		nBits : integer := 8;
		BusWidth : integer := 9;
		Ticks : integer := 434;
		NFF : integer := 10
	);
	PORT(
		RST : in Std_Logic;
		CLK : in Std_Logic;
		STR : in Std_Logic;
		DIN : in Std_Logic_Vector(nBits - 1 downto 0);
		RDY : out Std_Logic;
		BAUDIOS : out Std_Logic;
		TXD : out Std_Logic
	
	);
End Entity Tx;

Architecture Structural of Tx is
--========= Componentes Instanciations ==================================
Component Serializer is
	GENERIC(
		BusWidth : Integer := 7	
	);
	PORT(
		RST : in Std_Logic;
		CLK : in Std_Logic;
		LDR : in Std_Logic;
		SHF : in Std_Logic;
		DIN : in Std_Logic_Vector(BusWidth - 1 downto 0);
		BOUT: out Std_Logic
	);											
End Component Serializer;

Component CountDown is
	GENERIC(
	
		  Num : integer := 10
	);
	PORT(
		RST : in Std_Logic;
		CLK : in Std_Logic;
		DEC : in Std_Logic;
		RDY : out Std_Logic
	);
End Component CountDown;

Component Timer is
	GENERIC(
	   Ticks : integer := 10
	);
	PORT(
		RST : in Std_Logic;
		CLK : in Std_Logic;
		EOT : out Std_Logic
	);
End Component Timer;

Component LatchSR is
	PORT(
		RST : in Std_Logic;
		CLK : in Std_Logic;
		SET : in Std_Logic;
		CLR : in Std_Logic;
		SOUT: out Std_Logic
	);
End Component LatchSR;

Component RisingEdgeDetector is 
	GENERIC(
		N : integer := 10
	);
	PORT(
	RST : in Std_Logic;
	CLK : in Std_Logic;
	XIN : in Std_Logic;
	XRE : out Std_Logic
	);
End Component RisingEdgeDetector;

--========= Signals Instanciations ======================================
Signal EOC, ENA, SYN, TX, NSTR, START: Std_Logic;
Signal DATA : Std_Logic_Vector(BusWidth - 1 downto 0) := (Others => '1');
Begin

 
	U01 : LatchSR Port Map(RST, CLK, START, EOC, ENA);
	U02 : Timer Generic Map(Ticks) Port Map(ENA, CLK, SYN);
	U03 : Serializer Generic Map(BusWidth) Port Map(RST,CLK,START,SYN,DATA,TXD);
	U04 : CountDown Generic Map(nBits) Port Map(ENA, CLK, SYN, EOC);
	U05 : RisingEdgeDetector Generic Map(NFF) Port Map(RST, CLK, NSTR, START);
	
	DATA <=  DIN & '0';
	RDY <= not(ENA);
	BAUDIOS <= SYN;
	NSTR <= not(STR);

End Architecture Structural;

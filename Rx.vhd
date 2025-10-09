Library IEEE;
Use IEEE.NUmeric_Std.all; 
Use IEEE.Std_Logic_1164.all;

Entity Rx is
	GENERIC(
		nBits : integer := 9;
		Ticks : integer := 215;
		Flip_Flops : integer := 3
	);
	PORT(
		RST : in Std_Logic;
		CLK : in Std_Logic;
		RXD : in Std_Logic;
		ACK : in Std_Logic;
		INT : out Std_Logic;
		Baudios : out Std_Logic;
		DOUT : out Std_Logic_Vector(7 downto 0)
	);
End Entity Rx;


Architecture Structural of Rx IS

--=========== Component Instanciations ===================================================================
Component FallingEdgeDetector is 
	GENERIC(
		N : integer := 10
	);
	PORT(
	RST : in Std_Logic;
	CLK : in Std_Logic;
	XIN : in Std_Logic;
	XRE : out Std_Logic
	);
End Component FallingEdgeDetector;

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

Component Deserializer is
	GENERIC(
		BusWidth : Integer := 7	
	);
	PORT(
	RST : in Std_Logic;
	CLK : in Std_Logic;
	SHF : in Std_Logic;
	BIN : in Std_Logic;
	BOUT : out Std_Logic_Vector(BusWidth - 1 downto 0)
	);											
End Component Deserializer;

Component Toggle is 
	PORT(
	RST : in Std_Logic;
	CLK : in Std_Logic;
	TOG : in Std_Logic;
	TGS : out Std_Logic
	);
End Component Toggle;	

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
		CLK	: in Std_Logic;
		SET : in Std_Logic;
		CLR : in Std_Logic;
		SOUT : out Std_Logic
	);
End Component LatchSR;

--========== Signal Instanciations ==============================================================================
Signal FED, EOC, ENA, SYN, TOG, NTOG, SHF, NACK : Std_Logic := '0';
Signal Data : Std_Logic_Vector(nBits - 1 downto 0);

Begin

--========== Instanciations =====================================================================================0
   	
	
	U01 : FallingEdgeDetector Generic Map(Flip_Flops) Port Map(RST, CLK, RXD, FED);
	U02 : LatchSR Port Map(RST, CLK, FED, EOC, ENA);
	U03 : Timer Generic Map(Ticks) Port Map(ENA, CLK, SYN);
	U04 : Toggle Port Map(ENA, CLK, SYN, TOG);
	U05 : Deserializer Generic Map(nBits - 1) Port Map(RST, CLK, SHF, RXD, DOUT);
	U06 : CountDown Generic Map(nBits) Port Map(ENA, CLK, SHF, EOC);
	U07 : LatchSR Port Map(RST, CLK, EOC, NACK, INT);

	NTOG <= Not(TOG);
	SHF <= SYN and NTOG;
	NACK <= not(ACK);
	Baudios <= FED;
	
End Architecture Structural;
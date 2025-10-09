Library IEEE;
Use IEEE.Std_logic_1164.all;
Use IEEE.Numeric_Std.all;
Use IEEE.STD_LOGIC_Arith.All;

Entity SPI_Master is
	GENERIC(
		nBits : integer := 8;
		F_CSK : integer := 1_000_000
	);
	PORT(
		RST 	: in Std_Logic;
		CLK 	: in Std_Logic;
		STR 	: in Std_Logic;
		MISO  : in Std_logic;
		CSE 	: out Std_Logic;
		CSK  	: out Std_Logic;
		RDY 	: out Std_Logic;
		DOUT  : out Std_logic_Vector(nBits - 1 downto 0)
	);	
End Entity SPI_Master;


Architecture Structural of SPI_Master is

--=================== Components Declarations ====================================================================
Component Deserializer is
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
End Component Deserializer;

Component LatchSR is
	PORT(
	RST : in Std_Logic;
	CLK	: in Std_Logic;
	SET : in Std_Logic;
	CLR : in Std_Logic;
	SOUT : out Std_Logic
	);
End Component LatchSR;

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

Component Toggle is 
	PORT(
	RST : in Std_Logic;
	CLK : in Std_Logic;
	TOG : in Std_Logic;
	TGS : out Std_Logic
	);
End Component Toggle;
--========================== Signal Declarations ===========================================================================

Signal EOC, SHF, TOG, SYN, ENA, NSTR, NTOG: Std_Logic := '0';

Begin

--========================== Instances ======================================================================================
	U01 : LatchSR Port Map(RST, CLK, STR, EOC, ENA);
	U02 : Timer Generic Map(50e6 / (F_CSK * 2)) Port Map(ENA, CLK, SYN);
	U03 : Toggle Port Map(ENA, CLK, SYN, TOG);
	U04 : Deserializer Generic Map(nBits) Port Map(RST, CLK, SHF, MISO, DOUT);
	U05 : CountDown Generic Map(nBits) Port Map(ENA, CLK, SHF, EOC);
	
	NSTR <= NOT(STR);	
	NTOG <= NOT(TOG);
	CSK <= TOG;
	SHF <= SYN and NTOG;
	CSE <= NOT(ENA);
	RDY <= NOT(ENA);

End Architecture Structural;
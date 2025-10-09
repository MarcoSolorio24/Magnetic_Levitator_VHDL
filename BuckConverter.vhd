Library IEEE;
Use IEEE.Std_Logic_1164.all;
Use IEEE.Numeric_Std.all;

Entity BuckConverter is
	GENERIC(
		Timer_10us : integer := 5000; 
		DT : integer := 12;
		nBits : integer := 10;
		BitsSPI : integer := 16;
		Freq_ADC :integer := 2_000_000;
		Counter10bits : integer := 10
	);
	PORT(
		RST 	: in Std_Logic;
		CLK 	: in Std_Logic;
		MISO  : in Std_logic;
		Vref  : in Std_Logic_Vector(nBits - 1 downto 0);
		Debug_CSK : out Std_Logic;
		Debug_CSE : out Std_Logic;
		Debug_MISO : out Std_Logic;
		Debug_LO : out Std_Logic;
		Debug_HO : out Std_Logic;
		CSE 	: out Std_Logic;
		SCK  	: out Std_Logic;
		SD    : out Std_Logic;
		HO 	: out Std_logic;
		LO 	: out Std_logic;
		ADC   : out Std_Logic_Vector(nBits - 1 downto 0)
	);
End Entity BuckConverter;


Architecture Structural of BuckConverter is

-- ======================= Componentes Declarations ===================================================================================
Component SPI_Master is
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
End Component SPI_Master;
--------------------------------------------------------------------------------------------------------------------------------------------
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
--------------------------------------------------------------------------------------------------------------------------------------------

Component FreeRunCounter is 
	GENERIC(
		nBits : integer := 8
	);
	PORT(
	RST : in Std_Logic;
	CLK : in Std_Logic;
	INC : in Std_Logic;
	CNT : out Std_Logic_Vector(nBits-1 Downto 0)
	);
End Component FreeRunCounter;

--------------------------------------------------------------------------------------------------------------------------------------------

Component BidirectionalCounter is
	GENERIC(
	
			BusWidth : Integer := 8
	);
	PORT(
		RST : in Std_logic;
		CLK : in Std_logic;
		ENA : in Std_logic;
		DIR : in Std_logic;
		CNT : out Std_logic_vector(BusWidth - 1 downto 0)	
	);
End Component BidirectionalCounter;
--------------------------------------------------------------------------------------------------------------------------------------------
Component DeadTime is
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
End Component DeadTime;

Component LoadRegister is
	GENERIC(
		BusWidth : Integer := 7	
	);
	PORT(
	RST : in Std_Logic;
	CLK : in Std_Logic;
	LDR : in Std_Logic;
	DIN : in Std_Logic_Vector(BusWidth - 1 downto 0);
	DOUT : out Std_Logic_Vector(BusWidth - 1 downto 0)
	);											
End Component LoadRegister;

-- ======================= Signals Declarations ===================================================================================

Signal SYN : Std_Logic;
SignaL RSS : Std_Logic;
Signal DIR : Std_Logic;
Signal PWM, CSE_Signal, SCK_Signal, PWMH, PWML: Std_Logic;
Signal DUTY, CNT, VIN: Std_Logic_Vector(nBits - 1 downto 0) := (Others => '0');
Signal DATA, DREC : Std_Logic_Vector(BitsSPI - 1 downto 0) := (Others => '0');
Constant REF  : Std_Logic_Vector(nBits - 1 downto 0) := "1011111100";
Begin


	U01 : Timer Generic Map(Timer_10Us) Port Map(RST, CLK, SYN);
	U02 : SPI_Master Generic Map(BitsSPI,Freq_ADC) Port Map(RST, CLK, SYN, MISO, CSE_Signal, SCK_Signal, OPEN, DREC);
	U03 : LoadRegister Generic Map(BitsSPI) Port Map(RST, CLK, SYN, DREC, DATA);
	U04 : BidirectionalCounter Generic Map(Counter10bits) Port Map(RST, CLK, SYN, DIR, DUTY);
	U05 : FreeRunCounter Generic Map(Counter10bits) Port Map(RSS, CLK, '1', CNT); 
	U06 : DeadTime Generic Map(DT) Port Map(RST, CLK, PWM, PWMH, PWML);
	

	PWM <= '1' when DUTY >= CNT else '0';
	DIR <= '1' when Vref > VIN else '0';
	VIN <= DATA(12 downto 8) & DATA(7 downto 3);
	ADC <= DATA(12 downto 8) & DATA(7 downto 3);
	RSS <= NOT(SYN) AND RST;
	SD <= NOT(RST);
	

--==================================================================================================================================================
	
	CSE <= CSE_Signal;
	SCK <= SCK_Signal;
	Debug_CSE <= CSE_Signal;
	Debug_CSK <= SCK_Signal;
	Debug_MISO <= MISO;
	
--=================================================================================================================================================
	
	Debug_HO <= PWMH;
	Debug_LO <= PWML;
	HO <= PWMH;
	LO <= PWML;
	
End Architecture Structural;

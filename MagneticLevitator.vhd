Library IEEE;
Use IEEE.Std_logic_1164.all;
Use IEEE.Numeric_Std.all;


Entity MagneticLevitator is
	GENERIC(
		TIMER_10US : integer := 5000; 
		NBITS : integer := 10;
		BITS_SPI : integer := 16;
		FREQ_ADC :integer := 2_000_000;
		BAUD_RS232 : integer := 115_200;
		FREQ_PWM : integer := 50_000; 
		DEAD_TIME : integer := 1;
		COUNTER_10_BITS : integer := 10
	);
	PORT(
		RST 			: in Std_Logic;
		CLK 			: in Std_Logic;
		RXD  			: in Std_Logic;	
		MISO  		: in Std_logic;
		Vref  		: in Std_Logic_Vector(nBits - 1 downto 0);	
		TXD         : in Std_logic;
		Debug_CSK 	: out Std_Logic;
		Debug_CSE 	: out Std_Logic;
		Debug_MISO 	: out Std_Logic;
		Debug_HO 	: out Std_Logic;
		CSE 			: out Std_Logic;
		SCK  			: out Std_Logic;
		PWMA     	: out Std_logic;
		ADC   		: out Std_Logic_Vector(nBits - 1 downto 0)
	);
End Entity MagneticLevitator;

Architecture Structural of MagneticLevitator is			 

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

Signal SYN : Std_Logic;
SignaL RSS : Std_Logic;
Signal DIR : Std_Logic;
Signal PWM, CSE_Signal, SCK_Signal, PWMH, PWML: Std_Logic;
Signal DUTY, CNT, VIN: Std_Logic_Vector(NBITS - 1 downto 0) := (Others => '0');
Signal DATA, DREC : Std_Logic_Vector(BITS_SPI - 1 downto 0) := (Others => '0');
Constant REF  : Std_Logic_Vector(nBits - 1 downto 0) := "1011111100";
Begin	  
	
	U01 : Timer Generic Map(TIMER_10US) Port Map(RST, CLK, SYN);
	U02 : SPI_Master Generic Map(BITS_SPI,FREQ_ADC) Port Map(RST, CLK, SYN, MISO, CSE_Signal, SCK_Signal, OPEN, DREC);
	U03 : LoadRegister Generic Map(BITS_SPI) Port Map(RST, CLK, SYN, DREC, DATA);
	U04 : BidirectionalCounter Generic Map(COUNTER_10_BITS) Port Map(RST, CLK, SYN, DIR, DUTY);
	U05 : FreeRunCounter Generic Map(COUNTER_10_BITS) Port Map(RSS, CLK, '1', CNT); 
	U06 : DeadTime Generic Map(DEAD_TIME) Port Map(RST, CLK, PWM, PWMH, PWML);
	

	PWM <= '1' when DUTY >= CNT else '0';
	DIR <= '1' when Vref < VIN else '0';
	VIN <= DATA(12 downto 8) & DATA(7 downto 3);
	ADC <= DATA(12 downto 8) & DATA(7 downto 3);
	RSS <= NOT(SYN) AND RST;
	

--==================================================================================================================================================
	
	CSE <= CSE_Signal;
	SCK <= SCK_Signal;
	Debug_CSE <= CSE_Signal;
	Debug_CSK <= SCK_Signal;
	Debug_MISO <= MISO;
	
--=================================================================================================================================================
	
	Debug_HO <= PWMH;
	PWMA <= PWMH;
	
	
	
End Architecture Structural;


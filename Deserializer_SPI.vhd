Library IEEE;
Use IEEE.Std_logic_1164.all;
Use IEEE.Numeric_Std.all;
use IEEE.STD_LOGIC_Arith.All;

Entity Deserializer_SPI is
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
End Entity Deserializer_SPI;


architecture Behavioral of Deserializer_SPI is
	Signal Qp, Qn : std_logic_vector(BusWidth-1 downto 0);
begin 
	
	Combinational : process(SHF, Qp, BIN)
	begin
		if SHF = '1' then
			--Qn <= BIN & Qp(BusWidth-1 downto 1);
			Qn <= Qp(BusWidth - 2 downto 0) & BIN;
		else 
			Qn <= Qp;
		end if;
		BOUT <= Qp;		
	end process Combinational;	
	
	Sequential : process(RST, CLK)
	begin
		if RST = '0' then
			Qp <= (others => '0');
		elsif CLK' event and CLK = '1' then
			Qp <= Qn;
		end if;	
	end process Sequential;
	
end Behavioral;

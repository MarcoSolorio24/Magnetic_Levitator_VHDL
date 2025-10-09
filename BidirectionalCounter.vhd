Library IEEE;
Use IEEE.Std_logic_1164.all;
Use IEEE.Numeric_Std.all;


Entity BidirectionalCounter is
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
End Entity BidirectionalCounter;

Architecture Behavioral of BidirectionalCounter is 
Signal Cp, Cn : Std_logic_vector(BusWidth - 1 downto 0) := (Others => '0');

Begin	 
	
	Combinational : Process(Cp, ENA, DIR)
	begin 		
		if ENA = '1' then 
			if DIR = '0' then
				if Cp >= "1111010100" then
					Cn <= (others => '1');
				else
					Cn <= "1111111111";
					--Cn <= Std_logic_vector(unsigned(Cp) + 1);
				end if;
			else
				if Cp <= "0000000010" then
					Cn <= "0000000100";
				else
					Cn <= "0000000100";
					--Cn <= Std_logic_vector(unsigned(Cp) - 1);
				end if;	
			end if;
		else  
			Cn <= Cp;
		end if;
		CNT <= Cp;
	End Process Combinational;
		
	Sequential : Process(CLK, RST)
	begin 		
		if(RST = '0') then
			Cp <= (others => '0');
		elsif CLK'event and CLK = '1' then
			Cp <= Cn;
		end if;
	End Process Sequential;

End Architecture Behavioral;


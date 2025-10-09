Library IEEE;
Use IEEE.Std_Logic_1164.all;
Use IEEE.Numeric_Std.all;


Entity AsciiToDecimal is
	PORT(
		RST : in Std_Logic;
		CLK : in Std_Logic;
		DIN : in Std_Logic_Vector(7 downto 0);
		DOUT : out Std_Logic_Vector(3 downto 0)
	);
End Entity AsciiToDecimal;

Architecture RTL of AsciiToDecimal is
Begin 

	Convertion : Process(CLK)
	Begin
	
	if Rising_edge(CLK) then
			Case DIN is
				When X"30" => DOUT <= "0000";
				When X"31" => DOUT <= "0001";
				When X"32" => DOUT <= "0010";
				When X"33" => DOUT <= "0011";
				When X"34" => DOUT <= "0100";
				When X"35" => DOUT <= "0101";
				When X"36" => DOUT <= "0110";
				When X"37" => DOUT <= "0111";
				When X"38" => DOUT <= "1000";
				When X"39" => DOUT <= "1001";
				When Others => DOUT <= "0000";
			End Case;
		end if;
	End Process Convertion;

End Architecture RTL;
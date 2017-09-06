----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:56:17 09/04/2017 
-- Design Name: 
-- Module Name:    VGA - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VGA is
	Port (
		clk 				: in  STD_LOGIC;
		reset 			: in  STD_LOGIC;
		red_in			: in STD_LOGIC_VECTOR (4 downto 0);
		green_in 		: in STD_LOGIC_VECTOR (5 downto 0);
		blue_in			: in STD_LOGIC_VECTOR (4 downto 0);
		col_out 			: out STD_LOGIC_VECTOR (9 downto 0);
		row_out	 		: out STD_LOGIC_VECTOR (9 downto 0);
		hsyncsig_out 	: out STD_LOGIC;
		vsyncsig_out 	: out STD_LOGIC;
		vgaRed 			: out STD_LOGIC_VECTOR (4 downto 0);
		vgaGreen 		: out STD_LOGIC_VECTOR (5 downto 0);
		vgaBlue 			: out STD_LOGIC_VECTOR (4 downto 0)
	);
end VGA;

architecture Behavioral of VGA is

	component VSYNC is
		Port (
			clk 				: in  STD_LOGIC;
			reset 			: in  STD_LOGIC;
			rowClockIn 		: in  STD_LOGIC;
			vsyncsig 		: out  STD_LOGIC;
			vvidon 			: out  STD_LOGIC;
			row 				: out  STD_LOGIC_VECTOR (9 downto 0)
		);
	end component;

	component HSYNC is
		Port ( 
			clk				: in  STD_LOGIC;
			reset 			: in  STD_LOGIC;
			hsyncsig 		: out  STD_LOGIC;
			column 			: out  STD_LOGIC_VECTOR (9 downto 0);
			rowclk 			: out  STD_LOGIC;
			hvidon 			: out  STD_LOGIC
		);
	end component;
	
	signal columnInside: STD_LOGIC_VECTOR (9 downto 0);
	signal rowInside : STD_LOGIC_VECTOR (9 downto 0);
	signal hsyncsigInside : STD_LOGIC := '0';
	signal vsyncsigInside : STD_LOGIC := '0';
	signal rowClkInside : STD_LOGIC := '0';
	signal hvidon : STD_LOGIC := '0';
	signal vvidon : STD_LOGIC := '0';

begin
	--column_out <= columnInside;
	--row_out <= rowInside;
	hsyncsig_out <= hsyncsigInside;
	vsyncsig_out <= vsyncsigInside;
	
	hsy: HSYNC PORT MAP (
		clk => clk,
		reset => reset,
		hsyncsig => hsyncsigInside,
		column => columnInside,
		rowclk => rowClkInside,
		hvidon => hvidon
	);
	vsy: VSYNC PORT MAP (
		clk => clk,
		reset => reset,
		rowClockIn => rowClkInside,
		vsyncsig => vsyncsigInside,
		vvidon => vvidon,
		row => rowInside
	);
	
	process(vvidon, hvidon, columnInside, rowInside)
	begin
		-- If we're in display area show display colors
		if (vvidon = '1') and (hvidon = '1') then
			vgaRed 	<= red_in;
			vgaGreen <= green_in;
			vgaBlue	<= blue_in;
		else
			vgaRed 	<= "00000";
			vgaGreen <= "000000";
			vgaBlue	<= "00000";
		end if;
		-- Set correct output row
		if (vvidon = '1') then
			row_out <= rowInside;
		else
			row_out <= (others => '0');
		end if;
		-- Set correct output column
		if (hvidon = '1') then
			col_out <= columnInside;
		else
			col_out <= (others => '0');
		end if;
		
	end process ;

end Behavioral;


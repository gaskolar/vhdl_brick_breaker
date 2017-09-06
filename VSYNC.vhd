----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:48:07 09/04/2017 
-- Design Name: 
-- Module Name:    VSYNC - Behavioral 
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
use IEEE. STD_LOGIC_ARITH. ALL;
use IEEE. STD_LOGIC_UNSIGNED. ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VSYNC is
	Port ( 
		clk 			: in  STD_LOGIC;
		reset 		: in  STD_LOGIC;
		rowClockIn 	: in  STD_LOGIC;
		vsyncsig 	: out  STD_LOGIC;
		vvidon 		: out  STD_LOGIC;
		row 			: out  STD_LOGIC_VECTOR (9 downto 0)
	);
end VSYNC;

architecture Behavioral of VSYNC is

	component counter_with_limit
		Generic (
			width 	: integer := 10;
			limit 	: integer := 800
		);
		Port ( 
			clk 		: in  STD_LOGIC;
			reset 	: in  STD_LOGIC;
			enable 	: in STD_LOGIC;
			count 	: out  STD_LOGIC_VECTOR (width-1 downto 0)
		);
	end component;
	
	signal r 	: STD_LOGIC_VECTOR (9 downto 0);
	constant dt : STD_LOGIC_VECTOR (9 downto 0) := "0111100000";--480
	constant xy : STD_LOGIC_VECTOR (9 downto 0) := "0000011101";--29
	constant fp : STD_LOGIC_VECTOR (9 downto 0) := "0000100001";--33
	constant bp : STD_LOGIC_VECTOR (9 downto 0) := "0000001010";--10
	constant sp : STD_LOGIC_VECTOR (9 downto 0) := "0000000010";--2
	
begin

	row <= r;
		
	cnt : counter_with_limit
		generic map(
			width => 10,
			limit => 525
		)
		port map(
			clk => clk,
			reset => reset,
			enable => rowClockIn,
			count => r
		);
	
	process(r)
	begin
		if (r >= dt) then
			vvidon <= '0';
		else
			vvidon <= '1';
		end if;
		
		if (r >= dt+ bp) and (r < dt + bp + sp) then
			vsyncsig <= '0';
		else
			vsyncsig <= '1';
		end if;
		
	end process ;

end Behavioral;


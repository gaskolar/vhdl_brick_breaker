----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:33:14 09/04/2017 
-- Design Name: 
-- Module Name:    HSYNC - Behavioral 
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

entity HSYNC is
	Port (
		clk 		: in  STD_LOGIC;
		reset 	: in  STD_LOGIC;
		hsyncsig : out  STD_LOGIC;
		column 	: out  STD_LOGIC_VECTOR (9 downto 0);
		rowclk 	: out  STD_LOGIC;
		hvidon 	: out  STD_LOGIC
	);
end HSYNC;

architecture Behavioral of HSYNC is

component prescaler
	Generic (
		width 	: integer := 27;
		value 	: integer :=100000000
	);				
	Port (
		clk 		: in  STD_LOGIC;
		reset 	: in  STD_LOGIC;
		enable 	: out  STD_LOGIC
	);
end component;

component counter_with_limit
	Generic (
		width 	: integer := 3;
		limit 	: integer := 799
	);
	Port (
		clk 		: in  STD_LOGIC;
		reset 	: in  STD_LOGIC;
		enable 	: in STD_LOGIC;
		count 	: out  STD_LOGIC_VECTOR (width-1 downto 0)
	);
end component;

	signal enableInside	: STD_LOGIC :='0';
	signal c 				: STD_LOGIC_VECTOR (9 downto 0);
	signal rowInside 		: STD_LOGIC := '0';
	
	constant dt : STD_LOGIC_VECTOR (9 downto 0) := "1010000000";--640
	constant fp : STD_LOGIC_VECTOR (9 downto 0) := "0000110000";--48
	constant bp : STD_LOGIC_VECTOR (9 downto 0) := "0000010000";--16
	constant sp : STD_LOGIC_VECTOR (9 downto 0) := "0001100000";--96


begin

	column <= c;
	rowclk <= rowInside;
	
	pr : prescaler
		generic map (
			width => 3,
			value => 4
		)
		port map (
			clk => clk,
			reset => reset,
			enable => enableInside
		);

	cnt : counter_with_limit
		generic map(
			width => 10,
			limit => 800
		)
		port map(
			clk => clk,
			reset => reset,
			enable => enableInside,
			count => c
		);

	process(c)
	begin
		if (c >= dt) then
			hvidon <= '0';
		else
			hvidon <= '1';
		end if;
		
		if (c >= dt+ bp) and (c < dt + bp + sp) then
			hsyncsig <= '0';
		else
			hsyncsig <= '1';
		end if;
	end process ;
	
	process(enableInside)
	begin
		if c = dt+bp+fp+sp-1 and enableInside = '1' then
			rowInside <= '1';
		else
			rowInside <= '0';
		end if;
	end process;


end Behavioral;


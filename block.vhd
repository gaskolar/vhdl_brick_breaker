----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:21:02 09/04/2017 
-- Design Name: 
-- Module Name:    block - Behavioral 
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

entity block is
	Generic (
		width : integer := 40;
		height : integer :=40;
		speed_prescaler : integer := 390625;
	);
	Port (
		clk 			: in STD_LOGIC;
		reset 		: in STD_LOGIC;
		col_i 		: in STD_LOGIC_VECTOR (9 downto 0);
		row_i 		: in STD_LOGIC_VECTOR (9 downto 0);
		pos_x			: out STD_LOGIC_VECTOR (9 downto 0);
		pos_y			: out STD_LOGIC_VECTOR (9 downto 0);
		draw_me		: out STD_LOGIC;
	);

end block;

architecture Behavioral of block is

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
	
	
	signal pos_x_internal	: STD_LOGIC_VECTOR (9 downto 0) := "0101000000";
	signal pos_y_internal	: STD_LOGIC_VECTOR (9 downto 0) := "0011110000";
	
	signal draw_me_internal : STD_LOGIC := '0';
	
	signal move_signal 		: STD_LOGIC := '0';
	signal move_right 		: STD_LOGIC := '1';
	signal move_up 			: STD_LOGIC := '1';

begin

	pos_x <= pos_x_internal;
	pos_y <= pos_y_internal;
	
	draw_me <= draw_me_internal;
	pr : prescaler
		generic map (
			width => 27,
			value => speed_prescaler
		)
		port map (
			clk => clk,
			reset => reset,
			enable => move_signal
		);
		
	process(move_signal)
	begin
		if move_signal = '1' then
			if move_right = '1' then
				pos_x_internal <= pos_x_internal + 1;
			else
				pos_x_internal <= pos_x_internal -1;
			end if;
			if move_up = '1' then
				pos_y_internal <= pos_y_internal + 1;
			else
				pos_y_internal <= pos_y_internal -1;
			end if;
		else
			pos_x_internal <= pos_x_internal;
			pos_y_internal <= pos_y_internal;
		end if;
	end process;
	
	process(col_i, row_i)
	begin
		if (col_i >= pos_x_internal) and (col_i < pos_x_internal+width) and (row_i >= pos_y_internal) and (row_i < pos_y_internal+height) then
			draw_me_internal <= '1';
		else
			draw_me_internal <= '0';
		end if;
	end process;


	process(reset)
	begin
		if reset = '1' then
			pos_x_internal <= "0101000000";
			pos_y_internal <= "0011110000";
		else
			pos_x_internal <= pos_x_internal;
			pos_y_internal <= pos_y_internal;
		end if;
	end process;

end Behavioral;


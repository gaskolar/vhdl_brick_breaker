----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:21:04 09/06/2017 
-- Design Name: 
-- Module Name:    paddle - Behavioral 
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

entity paddle is
	Generic (
		width : integer := 80;
		height : integer :=20;
		speed_prescaler : integer := 390625
	);
	Port (
		clk 				: in STD_LOGIC;
		reset 			: in STD_LOGIC;
		move_left		: in STD_LOGIC;
		move_right		: in STD_LOGIC;
		col_i 			: in STD_LOGIC_VECTOR (9 downto 0);
		row_i 			: in STD_LOGIC_VECTOR (9 downto 0);
		ball_x			: in STD_LOGIC_VECTOR (9 downto 0);
		ball_y			: in STD_LOGIC_VECTOR (9 downto 0);
		draw_me			: out STD_LOGIC;
		hit_ball			: out STD_LOGIC
	);
end paddle;

architecture Behavioral of paddle is

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
	signal pos_y_internal	: STD_LOGIC_VECTOR (9 downto 0) := "0110111000";
	
	signal move_signal 		: STD_LOGIC := '0';

begin

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

	process(clk, move_signal, reset)
	begin
		if clk'event and clk = '1' then
			if reset = '0' then 
				pos_x_internal <= "0101000000";
			else
				-- Move paddle
				if move_signal = '1' then
					if (move_right = '1') and (pos_x_internal + width <= 639) then
						pos_x_internal <= pos_x_internal + 1;
					elsif (move_left = '1') and (pos_x_internal >= 1) then
						pos_x_internal <= pos_x_internal - 1;
					else
						pos_x_internal <= pos_x_internal;
					end if;
				else
					pos_x_internal <= pos_x_internal;
				end if;
				
				-- Check collision
				if (ball_x+40 >= pos_x_internal) and (ball_x < pos_x_internal+width) and (ball_y+40 = pos_y_internal) then
					hit_ball <= '1';
				else
					hit_ball <= '0';
				end if;
			end if;
		end if;
	end process;
	
	process(col_i, row_i)
	begin
		if (col_i >= pos_x_internal) and (col_i < pos_x_internal+width) and (row_i >= pos_y_internal) and (row_i < pos_y_internal+height) then
			draw_me <= '1';
		else
			draw_me <= '0';
		end if;
	end process;

end Behavioral;


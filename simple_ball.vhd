----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:27:16 09/05/2017 
-- Design Name: 
-- Module Name:    simple_ball - Behavioral 
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
use IEEE.STD_LOGIC_ARITH. ALL;
use IEEE.STD_LOGIC_UNSIGNED. ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity simple_ball is
	Generic (
		width : integer := 40;
		height : integer :=40;
		speed_prescaler : integer := 390625
	);
	Port (
		clk 				: in STD_LOGIC;
		reset 			: in STD_LOGIC;
		col_i 			: in STD_LOGIC_VECTOR (9 downto 0);
		row_i 			: in STD_LOGIC_VECTOR (9 downto 0);
		hit_brick		: in STD_LOGIC;
		hit_paddle		: in STD_LOGIC;
		hit_brick_x		: in STD_LOGIC_VECTOR (9 downto 0);
		hit_brick_y		: in STD_LOGIC_VECTOR (9 downto 0);
		pos_x				: out STD_LOGIC_VECTOR (9 downto 0);
		pos_y				: out STD_LOGIC_VECTOR (9 downto 0);
		draw_me			: out STD_LOGIC;
		game_over		: out STD_LOGIC
	);
end simple_ball;

architecture Behavioral of simple_ball is

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
	signal pos_y_internal	: STD_LOGIC_VECTOR (9 downto 0) := "0101101101";
	
	signal draw_me_internal : STD_LOGIC;
	
	signal move_signal 		: STD_LOGIC := '0';
	signal move_right 		: STD_LOGIC := '1';
	signal move_up 			: STD_LOGIC := '1';
	
	signal game_over_internal 	: STD_LOGIC := '0';
	
begin

	pos_x <= pos_x_internal;
	pos_y <= pos_y_internal;
	game_over <= game_over_internal;
	
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
		
	process(clk, move_signal, reset)
	begin
		if clk'event and clk = '1' then
			if reset = '0' then 
				pos_x_internal <= "0101000000";
				pos_y_internal <= "0101101101";
				move_right 		<= '1';
				move_up 			<= '1';
				game_over_internal <= '0';
			else
				-- Check for collision
				if (hit_brick = '1') then
					if 	(move_right = '1') and (move_up = '1') then
						if (pos_y_internal >= hit_brick_y+37) then
							move_up <= not move_up;
							move_right <= move_right;
						else 
							move_up <= move_up;
							move_right <= not move_right;
						end if;
					elsif (move_right = '1') and (move_up = '0') then
						if (pos_y_internal+37 >= hit_brick_y) then
							move_up <= move_up;
							move_right <= not move_right;
						else 
							move_up <= not move_up;
							move_right <=  move_right;
						end if;
					elsif (move_right = '0') and (move_up = '1') then
						if (pos_y_internal >= hit_brick_y+37) then
							move_up <= not move_up;
							move_right <= move_right;
						else 
							move_up <= move_up;
							move_right <= not move_right;
						end if;
					else--(move_right = '0') and (move_up = '0') then
						if (pos_y_internal+37 >= hit_brick_y) then
							move_up <=  move_up;
							move_right <= not move_right;
						else 
							move_up <= not move_up;
							move_right <= move_right;
						end if;
					end if;
				elsif hit_paddle = '1' then
					move_right 	<= move_right;
					move_up 		<= '1';
				else 
					move_right 	<= move_right;
					move_up 		<= move_up;
				end if;
				if move_signal = '1' and game_over_internal = '0' then
					-- Update move righ if necesary
					if (pos_x_internal <= 1) and (move_right = '0') then
						move_right <= '1';
					elsif (pos_x_internal+width >= 639) and (move_right = '1') then
						move_right <= '0';
					else 
						move_right <= move_right;
					end if;
					
					-- Update move up if necesary
					if (pos_y_internal <= 1) and (move_up = '1') then
						move_up <= '0';
					elsif (pos_y_internal+height >= 479) and (move_up = '0') then
						move_up <= '1';
						game_over_internal <= '1';
					else 
						move_up <= move_up;
						game_over_internal <= '0';
					end if;
				
					-- Update position
					if move_right = '1' then
						pos_x_internal <= pos_x_internal + 1;
					else
						pos_x_internal <= pos_x_internal - 1;
					end if;
					if move_up = '1' then
						pos_y_internal <= pos_y_internal - 1;
					else
						pos_y_internal <= pos_y_internal + 1;
					end if;
				else
					pos_x_internal <= pos_x_internal;
					pos_y_internal <= pos_y_internal;
				end if;
			end if;
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
	

end Behavioral;


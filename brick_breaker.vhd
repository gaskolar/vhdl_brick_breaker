----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:06:44 09/04/2017 
-- Design Name: 
-- Module Name:    brick_breaker - Behavioral 
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

entity brick_breaker is
	Port (
		clk 				: in  STD_LOGIC;
		right_button 	: in  STD_LOGIC;
		left_button		: in  STD_LOGIC;
		reset_button	: in  STD_LOGIC;
		vga_hs		 	: out  STD_LOGIC;
		vga_vs		 	: out  STD_LOGIC;
		vga_r 			: out STD_LOGIC_VECTOR (4 downto 0);
		vga_g 			: out STD_LOGIC_VECTOR (5 downto 0);
		vga_b 			: out STD_LOGIC_VECTOR (4 downto 0)
	);
end brick_breaker;

architecture Behavioral of brick_breaker is

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

	component VGA is
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
	end component;
	
	component simple_ball is
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
	end component;
	
	
	component brick_maneger is
		Generic (
			width 		: integer := 80;
			height 		: integer := 40;
			ball_width 	: integer := 40;
			ball_height : integer := 40
		);
		Port (
			clk 				: in STD_LOGIC;
			reset 			: in STD_LOGIC;
			col_i 			: in STD_LOGIC_VECTOR (9 downto 0);
			row_i 			: in STD_LOGIC_VECTOR (9 downto 0);
			ball_x_i			: in STD_LOGIC_VECTOR (9 downto 0);
			ball_y_i			: in STD_LOGIC_VECTOR (9 downto 0);
			ball_hit			: out STD_LOGIC;
			hit_brick_x		: out STD_LOGIC_VECTOR (9 downto 0);
			hit_brick_y		: out STD_LOGIC_VECTOR (9 downto 0);
			draw_block		: out STD_LOGIC;
			game_win			: out STD_LOGIC
		);
	end component;
	
	component paddle is
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
	end component;
	
	
	signal reset_internal	: STD_LOGIC := '1';
	
	-- Colors
	signal red_internal 		: STD_LOGIC_VECTOR (4 downto 0) := "11111";
	signal green_internal 	: STD_LOGIC_VECTOR (5 downto 0) := "111111";
	signal blue_internal 	: STD_LOGIC_VECTOR (4 downto 0) := "11111";
	
	signal bg_red 				: STD_LOGIC_VECTOR (4 downto 0) := "01111";
	signal bg_green 			: STD_LOGIC_VECTOR (5 downto 0) := "011111";
	signal bg_blue 			: STD_LOGIC_VECTOR (4 downto 0) := "01111";
	
	signal bg_win_red 		: STD_LOGIC_VECTOR (4 downto 0) := "00000";
	signal bg_win_green 		: STD_LOGIC_VECTOR (5 downto 0) := "111111";
	signal bg_win_blue 		: STD_LOGIC_VECTOR (4 downto 0) := "00000";
	
	signal bg_lose_red 		: STD_LOGIC_VECTOR (4 downto 0) := "11111";
	signal bg_lose_green 	: STD_LOGIC_VECTOR (5 downto 0) := "000000";
	signal bg_lose_blue 		: STD_LOGIC_VECTOR (4 downto 0) := "00000";
	
	signal ball_red 			: STD_LOGIC_VECTOR (4 downto 0) := "11111";
	signal ball_green 		: STD_LOGIC_VECTOR (5 downto 0) := "000000";
	signal ball_blue 			: STD_LOGIC_VECTOR (4 downto 0) := "11111";
	
	signal brick_red 			: STD_LOGIC_VECTOR (4 downto 0) := "11111";
	signal brick_green 		: STD_LOGIC_VECTOR (5 downto 0) := "111111";
	signal brick_blue 		: STD_LOGIC_VECTOR (4 downto 0) := "00000";
	
	signal paddle_red 		: STD_LOGIC_VECTOR (4 downto 0) := "00000";
	signal paddle_green 		: STD_LOGIC_VECTOR (5 downto 0) := "111111";
	signal paddle_blue 		: STD_LOGIC_VECTOR (4 downto 0) := "11111";
	
	-- Position
	signal col_internal 		: STD_LOGIC_VECTOR (9 downto 0);
	signal row_internal 		: STD_LOGIC_VECTOR (9 downto 0);
	
	-- Moore machine state
	type state_type is (s_loop, s_game_over, s_game_win);
	signal state, next_state: state_type;
	signal game_over	: STD_LOGIC := '0';
	signal game_win	: STD_LOGIC := '0';
	
	
	-- Ball position
	signal ball_pos_x 		: STD_LOGIC_VECTOR (9 downto 0);
	signal ball_pos_y 		: STD_LOGIC_VECTOR (9 downto 0);
	signal draw_ball 			: STD_LOGIC;
	
	-- Brick maneger
	signal draw_brick 		: STD_LOGIC;
	signal ball_hit_brick 	: STD_LOGIC;
	signal ball_hit_brick_x	: STD_LOGIC_VECTOR (9 downto 0);
	signal ball_hit_brick_y	: STD_LOGIC_VECTOR (9 downto 0);
	
	-- Paddle
	signal draw_paddle 		: STD_LOGIC;
	signal paddle_hit_ball 	: STD_LOGIC;
begin

	reset_internal <= not reset_button;

	-- VGA module instance
	vga_inst : VGA PORT MAP (
		clk => clk,
		reset => '1',
		hsyncsig_out => vga_hs,
		vsyncsig_out => vga_vs,
		vgaRed => vga_r,
		vgaGreen => vga_g,
		vgaBlue => vga_b,
		red_in => red_internal,
		green_in => green_internal,
		blue_in => blue_internal,
		col_out => col_internal,
		row_out => row_internal
	);
	
	ball : simple_ball 
		Generic map (
			width 				=> 40,
			height 				=> 40,
			speed_prescaler 	=> 3125000
		)
		Port  map(
			clk 			=> clk,
			reset 		=> reset_internal,
			col_i 		=> col_internal,
			row_i 		=> row_internal,
			hit_brick	=> ball_hit_brick,
			hit_paddle	=> paddle_hit_ball,
			hit_brick_x	=> ball_hit_brick_x,
			hit_brick_y	=> ball_hit_brick_y,
			pos_x			=> ball_pos_x,
			pos_y			=> ball_pos_y,
			draw_me		=> draw_ball,
			game_over	=> game_over
		);
		
	paddle_isnt: paddle 
		Generic map(
			width 				=> 80,
			height 				=> 20,
			speed_prescaler 	=> 781250
		)
		Port map(
			clk 			=> clk,
			reset 		=> reset_internal,
			move_left	=> left_button,
			move_right	=> right_button,
			col_i 		=> col_internal,
			row_i 		=> row_internal,
			ball_x		=> ball_pos_x,
			ball_y		=> ball_pos_y,
			draw_me		=> draw_paddle,
			hit_ball		=> paddle_hit_ball
		);
		
	brick_maneger_inst: brick_maneger
		Generic map (
			width 		=> 80,
			height 		=> 40,
			ball_width 	=> 40,
			ball_height => 40
		)
		Port map(
			clk 			=> clk,
			reset 		=> reset_internal,
			col_i 		=> col_internal,
			row_i 		=> row_internal,
			ball_x_i		=> ball_pos_x,
			ball_y_i		=> ball_pos_y,
			ball_hit		=> ball_hit_brick,
			hit_brick_x	=> ball_hit_brick_x,
			hit_brick_y	=> ball_hit_brick_y,
			draw_block	=> draw_brick,
			game_win		=> game_win
		);
	
	-- Moore machine state sync
	state_machine_sync: process ( clk )
	begin
		if (clk'event and clk = '1') then
			if ( reset_internal = '0') then
				state <= s_loop;
			else
				state <= next_state;
			end if;
		end if;
	end process;
	-- Moore machine next state decode
	next_state_decode: process (state, game_over, game_win)
	begin
		next_state <= state;
		case (state) is
			when s_loop =>
					if game_over = '1' then 
						next_state <= s_game_over;
					elsif game_win = '1' then
						next_state <= s_game_win;
					else 
						next_state <= s_loop;
					end if;
			when s_game_over =>
					next_state <= s_game_over;
			when s_game_win =>
				next_state <= s_game_win;
			when others =>
					next_state <= s_loop;
		end case;
	end process;
	
	draw_ball_proc: process (draw_ball, draw_brick)
	begin
		if state = s_loop then
			if draw_ball = '1' then
				red_internal 	<= ball_red;
				green_internal <= ball_green;
				blue_internal 	<= ball_blue;
			elsif draw_brick = '1' then
				red_internal 	<= brick_red;
				green_internal <= brick_green;
				blue_internal 	<= brick_blue;
			elsif draw_paddle = '1' then
				red_internal 	<= paddle_red;
				green_internal <= paddle_green;
				blue_internal 	<= paddle_blue;
			else
				red_internal 	<= bg_red;
				green_internal <= bg_green;
				blue_internal 	<= bg_blue;
			end if;
		elsif state = s_game_win then 
			red_internal 	<= bg_win_red;
			green_internal <= bg_win_green;
			blue_internal 	<= bg_win_blue;
		else 
			red_internal 	<= bg_lose_red;
			green_internal <= bg_lose_green;
			blue_internal 	<= bg_lose_blue;
		end if;
	end process;
	
	-- Moore machine output decode
	--output_decode: process ( state ) -- logika za izhod
	--begin
	--	case ( state ) is
	--		when s_init => 
	--			red_internal <= bg_red;
	--			green_internal <= bg_green;
	--			blue_internal <= bg_blue;
	--		when s_loop => red_internal <= "11111";
	--		when others => red_internal <= "00000";
	--	end case;
	--end process;
	

end Behavioral;


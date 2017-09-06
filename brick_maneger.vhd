----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:34:56 09/05/2017 
-- Design Name: 
-- Module Name:    brick_maneger - Behavioral 
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

entity brick_maneger is
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
end brick_maneger;

architecture Behavioral of brick_maneger is
	
	-- Brick visibility state
	signal brick_visibility : STD_LOGIC_VECTOR (19 downto 0) := "11111111111111111111";
	
	-- Draw block signal
	signal draw_block_internal	: STD_LOGIC := '0';
	
	signal game_win_internal 	: STD_LOGIC := '0';
	
	
	-- Brick positions
	signal brick0_x : STD_LOGIC_VECTOR (9 downto 0) := "0000101000";
	signal brick0_y : STD_LOGIC_VECTOR (9 downto 0) := "0000101000";

	signal brick1_x : STD_LOGIC_VECTOR (9 downto 0) := "0010100000";
	signal brick1_y : STD_LOGIC_VECTOR (9 downto 0) := "0000101000";

	signal brick2_x : STD_LOGIC_VECTOR (9 downto 0) := "0100011000";
	signal brick2_y : STD_LOGIC_VECTOR (9 downto 0) := "0000101000";

	signal brick3_x : STD_LOGIC_VECTOR (9 downto 0) := "0110010000";
	signal brick3_y : STD_LOGIC_VECTOR (9 downto 0) := "0000101000";

	signal brick4_x : STD_LOGIC_VECTOR (9 downto 0) := "1000001000";
	signal brick4_y : STD_LOGIC_VECTOR (9 downto 0) := "0000101000";

	signal brick5_x : STD_LOGIC_VECTOR (9 downto 0) := "0000101000";
	signal brick5_y : STD_LOGIC_VECTOR (9 downto 0) := "0001111000";

	signal brick6_x : STD_LOGIC_VECTOR (9 downto 0) := "0010100000";
	signal brick6_y : STD_LOGIC_VECTOR (9 downto 0) := "0001111000";

	signal brick7_x : STD_LOGIC_VECTOR (9 downto 0) := "0100011000";
	signal brick7_y : STD_LOGIC_VECTOR (9 downto 0) := "0001111000";

	signal brick8_x : STD_LOGIC_VECTOR (9 downto 0) := "0110010000";
	signal brick8_y : STD_LOGIC_VECTOR (9 downto 0) := "0001111000";

	signal brick9_x : STD_LOGIC_VECTOR (9 downto 0) := "1000001000";
	signal brick9_y : STD_LOGIC_VECTOR (9 downto 0) := "0001111000";

	signal brick10_x : STD_LOGIC_VECTOR (9 downto 0) := "0000101000";
	signal brick10_y : STD_LOGIC_VECTOR (9 downto 0) := "0011001000";

	signal brick11_x : STD_LOGIC_VECTOR (9 downto 0) := "0010100000";
	signal brick11_y : STD_LOGIC_VECTOR (9 downto 0) := "0011001000";

	signal brick12_x : STD_LOGIC_VECTOR (9 downto 0) := "0100011000";
	signal brick12_y : STD_LOGIC_VECTOR (9 downto 0) := "0011001000";

	signal brick13_x : STD_LOGIC_VECTOR (9 downto 0) := "0110010000";
	signal brick13_y : STD_LOGIC_VECTOR (9 downto 0) := "0011001000";

	signal brick14_x : STD_LOGIC_VECTOR (9 downto 0) := "1000001000";
	signal brick14_y : STD_LOGIC_VECTOR (9 downto 0) := "0011001000";

	signal brick15_x : STD_LOGIC_VECTOR (9 downto 0) := "0000101000";
	signal brick15_y : STD_LOGIC_VECTOR (9 downto 0) := "0100011000";

	signal brick16_x : STD_LOGIC_VECTOR (9 downto 0) := "0010100000";
	signal brick16_y : STD_LOGIC_VECTOR (9 downto 0) := "0100011000";

	signal brick17_x : STD_LOGIC_VECTOR (9 downto 0) := "0100011000";
	signal brick17_y : STD_LOGIC_VECTOR (9 downto 0) := "0100011000";

	signal brick18_x : STD_LOGIC_VECTOR (9 downto 0) := "0110010000";
	signal brick18_y : STD_LOGIC_VECTOR (9 downto 0) := "0100011000";

	signal brick19_x : STD_LOGIC_VECTOR (9 downto 0) := "1000001000";
	signal brick19_y : STD_LOGIC_VECTOR (9 downto 0) := "0100011000";
	

begin

	draw_block 	<= draw_block_internal;
	game_win <= game_win_internal;

	process(clk, reset)
	begin
		if clk'event and clk = '1' then
			if (reset = '0') then
				brick_visibility <= "11111111111111111111";
			else
				if (brick_visibility(0) = '1' and (((ball_x_i > brick0_x) and (ball_x_i < brick0_x+width) and (ball_y_i > brick0_y) and (ball_y_i < brick0_y+height)) or
						 ((ball_x_i > brick0_x) and (ball_x_i < brick0_x+width) and (ball_y_i+ball_height > brick0_y) and (ball_y_i+ball_height < brick0_y+height)) or
						 ((ball_x_i+ball_height > brick0_x) and (ball_x_i+ball_height < brick0_x+width) and (ball_y_i > brick0_y) and (ball_y_i < brick0_y+height)) or
						 ((ball_x_i+ball_height > brick0_x) and (ball_x_i+ball_height < brick0_x+width) and (ball_y_i+ball_height > brick0_y) and (ball_y_i+ball_height < brick0_y+height)))) then
						  brick_visibility(0) <= '0';
						  ball_hit <= '1';
						  hit_brick_x <= brick0_x;
						  hit_brick_y <= brick0_y;
				elsif (brick_visibility(1) = '1' and (((ball_x_i > brick1_x) and (ball_x_i < brick1_x+width) and (ball_y_i > brick1_y) and (ball_y_i < brick1_y+height)) or
						 ((ball_x_i > brick1_x) and (ball_x_i < brick1_x+width) and (ball_y_i+ball_height > brick1_y) and (ball_y_i+ball_height < brick1_y+height)) or
						 ((ball_x_i+ball_height > brick1_x) and (ball_x_i+ball_height < brick1_x+width) and (ball_y_i > brick1_y) and (ball_y_i < brick1_y+height)) or
						 ((ball_x_i+ball_height > brick1_x) and (ball_x_i+ball_height < brick1_x+width) and (ball_y_i+ball_height > brick1_y) and (ball_y_i+ball_height < brick1_y+height)))) then
						  brick_visibility(1) <= '0';
						  ball_hit <= '1';
						  hit_brick_x <= brick1_x;
						  hit_brick_y <= brick1_y;
				elsif (brick_visibility(2) = '1' and (((ball_x_i > brick2_x) and (ball_x_i < brick2_x+width) and (ball_y_i > brick2_y) and (ball_y_i < brick2_y+height)) or
						 ((ball_x_i > brick2_x) and (ball_x_i < brick2_x+width) and (ball_y_i+ball_height > brick2_y) and (ball_y_i+ball_height < brick2_y+height)) or
						 ((ball_x_i+ball_height > brick2_x) and (ball_x_i+ball_height < brick2_x+width) and (ball_y_i > brick2_y) and (ball_y_i < brick2_y+height)) or
						 ((ball_x_i+ball_height > brick2_x) and (ball_x_i+ball_height < brick2_x+width) and (ball_y_i+ball_height > brick2_y) and (ball_y_i+ball_height < brick2_y+height)))) then
						  brick_visibility(2) <= '0';
						  ball_hit <= '1';
						  hit_brick_x <= brick2_x;
						  hit_brick_y <= brick2_y;
				elsif (brick_visibility(3) = '1' and (((ball_x_i > brick3_x) and (ball_x_i < brick3_x+width) and (ball_y_i > brick3_y) and (ball_y_i < brick3_y+height)) or
						 ((ball_x_i > brick3_x) and (ball_x_i < brick3_x+width) and (ball_y_i+ball_height > brick3_y) and (ball_y_i+ball_height < brick3_y+height)) or
						 ((ball_x_i+ball_height > brick3_x) and (ball_x_i+ball_height < brick3_x+width) and (ball_y_i > brick3_y) and (ball_y_i < brick3_y+height)) or
						 ((ball_x_i+ball_height > brick3_x) and (ball_x_i+ball_height < brick3_x+width) and (ball_y_i+ball_height > brick3_y) and (ball_y_i+ball_height < brick3_y+height)))) then
						  brick_visibility(3) <= '0';
						  ball_hit <= '1';
						  hit_brick_x <= brick3_x;
						  hit_brick_y <= brick3_y;
				elsif (brick_visibility(4) = '1' and (((ball_x_i > brick4_x) and (ball_x_i < brick4_x+width) and (ball_y_i > brick4_y) and (ball_y_i < brick4_y+height)) or
						 ((ball_x_i > brick4_x) and (ball_x_i < brick4_x+width) and (ball_y_i+ball_height > brick4_y) and (ball_y_i+ball_height < brick4_y+height)) or
						 ((ball_x_i+ball_height > brick4_x) and (ball_x_i+ball_height < brick4_x+width) and (ball_y_i > brick4_y) and (ball_y_i < brick4_y+height)) or
						 ((ball_x_i+ball_height > brick4_x) and (ball_x_i+ball_height < brick4_x+width) and (ball_y_i+ball_height > brick4_y) and (ball_y_i+ball_height < brick4_y+height)))) then
						  brick_visibility(4) <= '0';
						  ball_hit <= '1';
						  hit_brick_x <= brick4_x;
						  hit_brick_y <= brick4_y;
				elsif (brick_visibility(5) = '1' and (((ball_x_i > brick5_x) and (ball_x_i < brick5_x+width) and (ball_y_i > brick5_y) and (ball_y_i < brick5_y+height)) or
						 ((ball_x_i > brick5_x) and (ball_x_i < brick5_x+width) and (ball_y_i+ball_height > brick5_y) and (ball_y_i+ball_height < brick5_y+height)) or
						 ((ball_x_i+ball_height > brick5_x) and (ball_x_i+ball_height < brick5_x+width) and (ball_y_i > brick5_y) and (ball_y_i < brick5_y+height)) or
						 ((ball_x_i+ball_height > brick5_x) and (ball_x_i+ball_height < brick5_x+width) and (ball_y_i+ball_height > brick5_y) and (ball_y_i+ball_height < brick5_y+height)))) then
						  brick_visibility(5) <= '0';
						  ball_hit <= '1';
						  hit_brick_x <= brick5_x;
						  hit_brick_y <= brick5_y;
				elsif (brick_visibility(6) = '1' and (((ball_x_i > brick6_x) and (ball_x_i < brick6_x+width) and (ball_y_i > brick6_y) and (ball_y_i < brick6_y+height)) or
						 ((ball_x_i > brick6_x) and (ball_x_i < brick6_x+width) and (ball_y_i+ball_height > brick6_y) and (ball_y_i+ball_height < brick6_y+height)) or
						 ((ball_x_i+ball_height > brick6_x) and (ball_x_i+ball_height < brick6_x+width) and (ball_y_i > brick6_y) and (ball_y_i < brick6_y+height)) or
						 ((ball_x_i+ball_height > brick6_x) and (ball_x_i+ball_height < brick6_x+width) and (ball_y_i+ball_height > brick6_y) and (ball_y_i+ball_height < brick6_y+height)))) then
						  brick_visibility(6) <= '0';
						  ball_hit <= '1';
						  hit_brick_x <= brick6_x;
						  hit_brick_y <= brick6_y;
				elsif (brick_visibility(7) = '1' and (((ball_x_i > brick7_x) and (ball_x_i < brick7_x+width) and (ball_y_i > brick7_y) and (ball_y_i < brick7_y+height)) or
						 ((ball_x_i > brick7_x) and (ball_x_i < brick7_x+width) and (ball_y_i+ball_height > brick7_y) and (ball_y_i+ball_height < brick7_y+height)) or
						 ((ball_x_i+ball_height > brick7_x) and (ball_x_i+ball_height < brick7_x+width) and (ball_y_i > brick7_y) and (ball_y_i < brick7_y+height)) or
						 ((ball_x_i+ball_height > brick7_x) and (ball_x_i+ball_height < brick7_x+width) and (ball_y_i+ball_height > brick7_y) and (ball_y_i+ball_height < brick7_y+height)))) then
						  brick_visibility(7) <= '0';
						  ball_hit <= '1';
						  hit_brick_x <= brick7_x;
						  hit_brick_y <= brick7_y;
				elsif (brick_visibility(8) = '1' and (((ball_x_i > brick8_x) and (ball_x_i < brick8_x+width) and (ball_y_i > brick8_y) and (ball_y_i < brick8_y+height)) or
						 ((ball_x_i > brick8_x) and (ball_x_i < brick8_x+width) and (ball_y_i+ball_height > brick8_y) and (ball_y_i+ball_height < brick8_y+height)) or
						 ((ball_x_i+ball_height > brick8_x) and (ball_x_i+ball_height < brick8_x+width) and (ball_y_i > brick8_y) and (ball_y_i < brick8_y+height)) or
						 ((ball_x_i+ball_height > brick8_x) and (ball_x_i+ball_height < brick8_x+width) and (ball_y_i+ball_height > brick8_y) and (ball_y_i+ball_height < brick8_y+height)))) then
						  brick_visibility(8) <= '0';
						  ball_hit <= '1';
						  hit_brick_x <= brick8_x;
						  hit_brick_y <= brick8_y;
				elsif (brick_visibility(9) = '1' and (((ball_x_i > brick9_x) and (ball_x_i < brick9_x+width) and (ball_y_i > brick9_y) and (ball_y_i < brick9_y+height)) or
						 ((ball_x_i > brick9_x) and (ball_x_i < brick9_x+width) and (ball_y_i+ball_height > brick9_y) and (ball_y_i+ball_height < brick9_y+height)) or
						 ((ball_x_i+ball_height > brick9_x) and (ball_x_i+ball_height < brick9_x+width) and (ball_y_i > brick9_y) and (ball_y_i < brick9_y+height)) or
						 ((ball_x_i+ball_height > brick9_x) and (ball_x_i+ball_height < brick9_x+width) and (ball_y_i+ball_height > brick9_y) and (ball_y_i+ball_height < brick9_y+height)))) then
						  brick_visibility(9) <= '0';
						  ball_hit <= '1';
						  hit_brick_x <= brick9_x;
						  hit_brick_y <= brick9_y;
				elsif (brick_visibility(10) = '1' and (((ball_x_i > brick10_x) and (ball_x_i < brick10_x+width) and (ball_y_i > brick10_y) and (ball_y_i < brick10_y+height)) or
						 ((ball_x_i > brick10_x) and (ball_x_i < brick10_x+width) and (ball_y_i+ball_height > brick10_y) and (ball_y_i+ball_height < brick10_y+height)) or
						 ((ball_x_i+ball_height > brick10_x) and (ball_x_i+ball_height < brick10_x+width) and (ball_y_i > brick10_y) and (ball_y_i < brick10_y+height)) or
						 ((ball_x_i+ball_height > brick10_x) and (ball_x_i+ball_height < brick10_x+width) and (ball_y_i+ball_height > brick10_y) and (ball_y_i+ball_height < brick10_y+height)))) then
						  brick_visibility(10) <= '0';
						  ball_hit <= '1';
						  hit_brick_x <= brick10_x;
						  hit_brick_y <= brick10_y;
				elsif (brick_visibility(11) = '1' and (((ball_x_i > brick11_x) and (ball_x_i < brick11_x+width) and (ball_y_i > brick11_y) and (ball_y_i < brick11_y+height)) or
						 ((ball_x_i > brick11_x) and (ball_x_i < brick11_x+width) and (ball_y_i+ball_height > brick11_y) and (ball_y_i+ball_height < brick11_y+height)) or
						 ((ball_x_i+ball_height > brick11_x) and (ball_x_i+ball_height < brick11_x+width) and (ball_y_i > brick11_y) and (ball_y_i < brick11_y+height)) or
						 ((ball_x_i+ball_height > brick11_x) and (ball_x_i+ball_height < brick11_x+width) and (ball_y_i+ball_height > brick11_y) and (ball_y_i+ball_height < brick11_y+height)))) then
						  brick_visibility(11) <= '0';
						  ball_hit <= '1';
						  hit_brick_x <= brick11_x;
						  hit_brick_y <= brick11_y;
				elsif (brick_visibility(12) = '1' and (((ball_x_i > brick12_x) and (ball_x_i < brick12_x+width) and (ball_y_i > brick12_y) and (ball_y_i < brick12_y+height)) or
						 ((ball_x_i > brick12_x) and (ball_x_i < brick12_x+width) and (ball_y_i+ball_height > brick12_y) and (ball_y_i+ball_height < brick12_y+height)) or
						 ((ball_x_i+ball_height > brick12_x) and (ball_x_i+ball_height < brick12_x+width) and (ball_y_i > brick12_y) and (ball_y_i < brick12_y+height)) or
						 ((ball_x_i+ball_height > brick12_x) and (ball_x_i+ball_height < brick12_x+width) and (ball_y_i+ball_height > brick12_y) and (ball_y_i+ball_height < brick12_y+height)))) then
						  brick_visibility(12) <= '0';
						  ball_hit <= '1';
						  hit_brick_x <= brick12_x;
						  hit_brick_y <= brick12_y;
				elsif (brick_visibility(13) = '1' and (((ball_x_i > brick13_x) and (ball_x_i < brick13_x+width) and (ball_y_i > brick13_y) and (ball_y_i < brick13_y+height)) or
						 ((ball_x_i > brick13_x) and (ball_x_i < brick13_x+width) and (ball_y_i+ball_height > brick13_y) and (ball_y_i+ball_height < brick13_y+height)) or
						 ((ball_x_i+ball_height > brick13_x) and (ball_x_i+ball_height < brick13_x+width) and (ball_y_i > brick13_y) and (ball_y_i < brick13_y+height)) or
						 ((ball_x_i+ball_height > brick13_x) and (ball_x_i+ball_height < brick13_x+width) and (ball_y_i+ball_height > brick13_y) and (ball_y_i+ball_height < brick13_y+height)))) then
						  brick_visibility(13) <= '0';
						  ball_hit <= '1';
						  hit_brick_x <= brick13_x;
						  hit_brick_y <= brick13_y;
				elsif (brick_visibility(14) = '1' and (((ball_x_i > brick14_x) and (ball_x_i < brick14_x+width) and (ball_y_i > brick14_y) and (ball_y_i < brick14_y+height)) or
						 ((ball_x_i > brick14_x) and (ball_x_i < brick14_x+width) and (ball_y_i+ball_height > brick14_y) and (ball_y_i+ball_height < brick14_y+height)) or
						 ((ball_x_i+ball_height > brick14_x) and (ball_x_i+ball_height < brick14_x+width) and (ball_y_i > brick14_y) and (ball_y_i < brick14_y+height)) or
						 ((ball_x_i+ball_height > brick14_x) and (ball_x_i+ball_height < brick14_x+width) and (ball_y_i+ball_height > brick14_y) and (ball_y_i+ball_height < brick14_y+height)))) then
						  brick_visibility(14) <= '0';
						  ball_hit <= '1';
						  hit_brick_x <= brick14_x;
						  hit_brick_y <= brick14_y;
				elsif (brick_visibility(15) = '1' and (((ball_x_i > brick15_x) and (ball_x_i < brick15_x+width) and (ball_y_i > brick15_y) and (ball_y_i < brick15_y+height)) or
						 ((ball_x_i > brick15_x) and (ball_x_i < brick15_x+width) and (ball_y_i+ball_height > brick15_y) and (ball_y_i+ball_height < brick15_y+height)) or
						 ((ball_x_i+ball_height > brick15_x) and (ball_x_i+ball_height < brick15_x+width) and (ball_y_i > brick15_y) and (ball_y_i < brick15_y+height)) or
						 ((ball_x_i+ball_height > brick15_x) and (ball_x_i+ball_height < brick15_x+width) and (ball_y_i+ball_height > brick15_y) and (ball_y_i+ball_height < brick15_y+height)))) then
						  brick_visibility(15) <= '0';
						  ball_hit <= '1';
						  hit_brick_x <= brick15_x;
						  hit_brick_y <= brick15_y;
				elsif (brick_visibility(16) = '1' and (((ball_x_i > brick16_x) and (ball_x_i < brick16_x+width) and (ball_y_i > brick16_y) and (ball_y_i < brick16_y+height)) or
						 ((ball_x_i > brick16_x) and (ball_x_i < brick16_x+width) and (ball_y_i+ball_height > brick16_y) and (ball_y_i+ball_height < brick16_y+height)) or
						 ((ball_x_i+ball_height > brick16_x) and (ball_x_i+ball_height < brick16_x+width) and (ball_y_i > brick16_y) and (ball_y_i < brick16_y+height)) or
						 ((ball_x_i+ball_height > brick16_x) and (ball_x_i+ball_height < brick16_x+width) and (ball_y_i+ball_height > brick16_y) and (ball_y_i+ball_height < brick16_y+height)))) then
						  brick_visibility(16) <= '0';
						  ball_hit <= '1';
						  hit_brick_x <= brick16_x;
						  hit_brick_y <= brick16_y;
				elsif (brick_visibility(17) = '1' and (((ball_x_i > brick17_x) and (ball_x_i < brick17_x+width) and (ball_y_i > brick17_y) and (ball_y_i < brick17_y+height)) or
						 ((ball_x_i > brick17_x) and (ball_x_i < brick17_x+width) and (ball_y_i+ball_height > brick17_y) and (ball_y_i+ball_height < brick17_y+height)) or
						 ((ball_x_i+ball_height > brick17_x) and (ball_x_i+ball_height < brick17_x+width) and (ball_y_i > brick17_y) and (ball_y_i < brick17_y+height)) or
						 ((ball_x_i+ball_height > brick17_x) and (ball_x_i+ball_height < brick17_x+width) and (ball_y_i+ball_height > brick17_y) and (ball_y_i+ball_height < brick17_y+height)))) then
						  brick_visibility(17) <= '0';
						  ball_hit <= '1';
						  hit_brick_x <= brick17_x;
						  hit_brick_y <= brick17_y;
				elsif (brick_visibility(18) = '1' and (((ball_x_i > brick18_x) and (ball_x_i < brick18_x+width) and (ball_y_i > brick18_y) and (ball_y_i < brick18_y+height)) or
						 ((ball_x_i > brick18_x) and (ball_x_i < brick18_x+width) and (ball_y_i+ball_height > brick18_y) and (ball_y_i+ball_height < brick18_y+height)) or
						 ((ball_x_i+ball_height > brick18_x) and (ball_x_i+ball_height < brick18_x+width) and (ball_y_i > brick18_y) and (ball_y_i < brick18_y+height)) or
						 ((ball_x_i+ball_height > brick18_x) and (ball_x_i+ball_height < brick18_x+width) and (ball_y_i+ball_height > brick18_y) and (ball_y_i+ball_height < brick18_y+height)))) then
						  brick_visibility(18) <= '0';
						  ball_hit <= '1';
						  hit_brick_x <= brick18_x;
						  hit_brick_y <= brick18_y;
				elsif (brick_visibility(19) = '1' and (((ball_x_i > brick19_x) and (ball_x_i < brick19_x+width) and (ball_y_i > brick19_y) and (ball_y_i < brick19_y+height)) or
						 ((ball_x_i > brick19_x) and (ball_x_i < brick19_x+width) and (ball_y_i+ball_height > brick19_y) and (ball_y_i+ball_height < brick19_y+height)) or
						 ((ball_x_i+ball_height > brick19_x) and (ball_x_i+ball_height < brick19_x+width) and (ball_y_i > brick19_y) and (ball_y_i < brick19_y+height)) or
						 ((ball_x_i+ball_height > brick19_x) and (ball_x_i+ball_height < brick19_x+width) and (ball_y_i+ball_height > brick19_y) and (ball_y_i+ball_height < brick19_y+height)))) then
						  brick_visibility(19) <= '0';
						  ball_hit <= '1';
						  hit_brick_x <= brick19_x;
						  hit_brick_y <= brick19_y;
				else
						  brick_visibility <= brick_visibility;
						  ball_hit <= '0';
						  hit_brick_x <= (others => '0');
						  hit_brick_y <= (others => '0');
				end if;
			end if;
		end if;
	end process;
	
	-- Handle brick drawing
	process(col_i, row_i, brick_visibility)
	begin
		if (col_i >= brick0_x) and (col_i < brick0_x+width) and (row_i >= brick0_y) and (row_i < brick0_y+height) and brick_visibility(0) = '1' then
				  draw_block_internal <= '1';
		elsif (col_i >= brick1_x) and (col_i < brick1_x+width) and (row_i >= brick1_y) and (row_i < brick1_y+height) and brick_visibility(1) = '1' then
				  draw_block_internal <= '1';
		elsif (col_i >= brick2_x) and (col_i < brick2_x+width) and (row_i >= brick2_y) and (row_i < brick2_y+height) and brick_visibility(2) = '1' then
				  draw_block_internal <= '1';
		elsif (col_i >= brick3_x) and (col_i < brick3_x+width) and (row_i >= brick3_y) and (row_i < brick3_y+height) and brick_visibility(3) = '1' then
				  draw_block_internal <= '1';
		elsif (col_i >= brick4_x) and (col_i < brick4_x+width) and (row_i >= brick4_y) and (row_i < brick4_y+height) and brick_visibility(4) = '1' then
				  draw_block_internal <= '1';
		elsif (col_i >= brick5_x) and (col_i < brick5_x+width) and (row_i >= brick5_y) and (row_i < brick5_y+height) and brick_visibility(5) = '1' then
				  draw_block_internal <= '1';
		elsif (col_i >= brick6_x) and (col_i < brick6_x+width) and (row_i >= brick6_y) and (row_i < brick6_y+height) and brick_visibility(6) = '1' then
				  draw_block_internal <= '1';
		elsif (col_i >= brick7_x) and (col_i < brick7_x+width) and (row_i >= brick7_y) and (row_i < brick7_y+height) and brick_visibility(7) = '1' then
				  draw_block_internal <= '1';
		elsif (col_i >= brick8_x) and (col_i < brick8_x+width) and (row_i >= brick8_y) and (row_i < brick8_y+height) and brick_visibility(8) = '1' then
				  draw_block_internal <= '1';
		elsif (col_i >= brick9_x) and (col_i < brick9_x+width) and (row_i >= brick9_y) and (row_i < brick9_y+height) and brick_visibility(9) = '1' then
				  draw_block_internal <= '1';
		elsif (col_i >= brick10_x) and (col_i < brick10_x+width) and (row_i >= brick10_y) and (row_i < brick10_y+height) and brick_visibility(10) = '1' then
				  draw_block_internal <= '1';
		elsif (col_i >= brick11_x) and (col_i < brick11_x+width) and (row_i >= brick11_y) and (row_i < brick11_y+height) and brick_visibility(11) = '1' then
				  draw_block_internal <= '1';
		elsif (col_i >= brick12_x) and (col_i < brick12_x+width) and (row_i >= brick12_y) and (row_i < brick12_y+height) and brick_visibility(12) = '1' then
				  draw_block_internal <= '1';
		elsif (col_i >= brick13_x) and (col_i < brick13_x+width) and (row_i >= brick13_y) and (row_i < brick13_y+height) and brick_visibility(13) = '1' then
				  draw_block_internal <= '1';
		elsif (col_i >= brick14_x) and (col_i < brick14_x+width) and (row_i >= brick14_y) and (row_i < brick14_y+height) and brick_visibility(14) = '1' then
				  draw_block_internal <= '1';
		elsif (col_i >= brick15_x) and (col_i < brick15_x+width) and (row_i >= brick15_y) and (row_i < brick15_y+height) and brick_visibility(15) = '1' then
				  draw_block_internal <= '1';
		elsif (col_i >= brick16_x) and (col_i < brick16_x+width) and (row_i >= brick16_y) and (row_i < brick16_y+height) and brick_visibility(16) = '1' then
				  draw_block_internal <= '1';
		elsif (col_i >= brick17_x) and (col_i < brick17_x+width) and (row_i >= brick17_y) and (row_i < brick17_y+height) and brick_visibility(17) = '1' then
				  draw_block_internal <= '1';
		elsif (col_i >= brick18_x) and (col_i < brick18_x+width) and (row_i >= brick18_y) and (row_i < brick18_y+height) and brick_visibility(18) = '1' then
				  draw_block_internal <= '1';
		elsif (col_i >= brick19_x) and (col_i < brick19_x+width) and (row_i >= brick19_y) and (row_i < brick19_y+height) and brick_visibility(19) = '1' then
				  draw_block_internal <= '1';
		else
				  draw_block_internal <= '0';
		end if;
	
		if brick_visibility = "00000000000000000000" then		
			game_win_internal <= '1';
		else
			game_win_internal <= '0';
		end if;
	end process;

end Behavioral;


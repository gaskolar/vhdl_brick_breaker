----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:10:03 09/05/2017 
-- Design Name: 
-- Module Name:    brick - Behavioral 
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

entity brick is
	Port (
		ram_row_i 		: in STD_LOGIC_VECTOR (20 downto 0);
		pos_x				: out STD_LOGIC_VECTOR (9 downto 0);
		pos_y				: out STD_LOGIC_VECTOR (9 downto 0);
		visible			: out STD_LOGIC
	);
end brick;

architecture Behavioral of brick is

	signal pos_x_internal	: STD_LOGIC_VECTOR (9 downto 0);
	signal pos_y_internal	: STD_LOGIC_VECTOR (9 downto 0);
	signal visible_internal	: STD_LOGIC;

begin

	pos_x 	<= pos_x_internal;
	pos_y 	<= pos_y_internal;
	visible 	<= visible_internal;

	pos_x_internal 	<= ram_row_i(20 downto 11);
	pos_y_internal 	<= ram_row_i(10 downto 1);
	visible_internal 	<= ram_row_i(0);


end Behavioral;


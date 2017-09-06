----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:47:57 09/04/2017 
-- Design Name: 
-- Module Name:    RAM - Behavioral 
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


	-- to je dvokanalni RAM. Pisemo na naslov addrIN_i, istocasno lahko beremo z naslova addrOUT_i
	-- RAM ima asinhronski bralni dostop, tako da ga je easy za uporabit. Ko naslovis, takoj dobis podatke.
	-- pisalni dostop je sinhronski.

entity RAM is
	Generic (
		row_size 		: integer := 40;
		number_of_rows : integer := 30;
		addr_size		: integer := 5
	);
	Port (
		clk_i 		: in  STD_LOGIC;
		we_i 			: in  STD_LOGIC;
		addrIN_i 	: in  STD_LOGIC_VECTOR (addr_size-1 downto 0);
		addrOUT_i 	: in  STD_LOGIC_VECTOR (addr_size-1 downto 0);
		data_i 		: in  STD_LOGIC_VECTOR (row_size-1 downto 0);
		data_o 		: out  STD_LOGIC_VECTOR (row_size-1 downto 0)
	);
end RAM;

architecture Behavioral of RAM is

	type ram_type is array (number_of_rows-1 downto 0) of std_logic_vector (row_size-1 downto 0);
	signal RAM : ram_type;
	signal dataOUT : STD_LOGIC_VECTOR (row_size-1 downto 0);

begin

	data_o	<= dataOUT;
	
	process (clk_i)
	begin
		if (clk_i'event and clk_i = '1') then
			if (we_i = '1') then
				RAM(conv_integer(addrIN_i)) <= data_i;
			end if;
		end if;
	end process;

	dataOUT <= RAM(conv_integer(addrOUT_i));

end Behavioral;


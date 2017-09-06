----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:25:15 09/04/2017 
-- Design Name: 
-- Module Name:    prescaler - Behavioral 
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

entity prescaler is
	Generic (
		width : integer := 27;
		value : integer :=100000000
	);
	
	Port ( 
		clk 		: in  STD_LOGIC;
		reset 	: in  STD_LOGIC;
		enable	: out  STD_LOGIC
	);
end prescaler;

architecture Behavioral of prescaler is

	signal countMaster:std_logic_vector(width-1 downto 0);

begin

	process(clk)
	begin
		if clk'event and clk = '1' then
			if(reset = '0') then
				countMaster <= (others => '0');
				enable <= '0';
			else
				if (countMaster >= value) then
					enable <= '1';
					countMaster <= (others => '0');
				else
					enable <= '0';
					countMaster <= countMaster+1;
				end if;
			end if;
		end if ;
	end process ;

end Behavioral;


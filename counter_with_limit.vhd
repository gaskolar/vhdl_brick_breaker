----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:28:48 09/04/2017 
-- Design Name: 
-- Module Name:    counter_with_limit - Behavioral 
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

entity counter_with_limit is
	Generic (
		width : integer := 10;
		limit : integer := 800
	);
	Port (
		clk 		: in  STD_LOGIC;
		reset 	: in  STD_LOGIC;
		enable 	: in STD_LOGIC;
		count 	: out  STD_LOGIC_VECTOR (width-1 downto 0)
	);
end counter_with_limit;

architecture Behavioral of counter_with_limit is

	signal countMaster:std_logic_vector(width-1 downto 0);

begin

	count <= countMaster;

	process(clk)
	begin
		if clk'event and clk = '1' then
			if (reset = '0') then
				countMaster <= (others => '0');
			else
				if enable = '1' then
					if countMaster >= limit-1 then 
						countMaster <= (others => '0');
					else
						countMaster <= countMaster+1;
					end if;
				else
					countMaster <= countMaster;
				end if;
			end if;
		end if ;
	end process ;

end Behavioral;


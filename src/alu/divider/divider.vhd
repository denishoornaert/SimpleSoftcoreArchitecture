library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity divider is
    Port (
        mode     : IN  std_logic_vector(0 to 1); -- "00" : 32bits, "01" : 16bits and "10" : 8bits
        operand1 : IN  std_logic_vector(0 to 31);
        operand2 : IN  std_logic_vector(0 to 31);
        result   : OUT std_logic_vector(0 to 31);
        carries  : OUT std_logic_vector(0 to 3)
    );
end divider;

architecture arch of divider is
    
begin
    result  <= (others => '0');
    carries <= (others => '0');

end arch;

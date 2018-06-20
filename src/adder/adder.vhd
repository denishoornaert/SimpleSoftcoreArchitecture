library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity adder is
    Port (
        operand1 : IN  std_logic_vector(0 to 31);
        operand2 : IN  std_logic_vector(0 to 31);
        result   : OUT std_logic_vector(0 to 31);
        carry    : OUT std_logic
    );
end adder;

architecture arch of adder is
    signal internalOperand1 : std_logic_vector(0 to 32);
    signal internalOperand2 : std_logic_vector(0 to 32);
    signal internalResult   : std_logic_vector(0 to 32);
    
begin
    -- set-up
    internalOperand1 <= '0'&operand1;
    internalOperand2 <= '0'&operand2;
    
    -- perform
    internalResult <= internalOperand1 + internalOperand2;
    
    -- write
    carry <= internalResult(0);
    result <= internalResult(1 to 32);

end arch;

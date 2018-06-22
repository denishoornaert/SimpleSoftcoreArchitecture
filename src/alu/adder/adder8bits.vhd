library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity adder8bits is
    Port (
        carryin  : IN  std_logic;
        operand1 : IN  std_logic_vector(0 to 7);
        operand2 : IN  std_logic_vector(0 to 7);
        result   : OUT std_logic_vector(0 to 7);
        carryout : OUT std_logic
    );
end adder8bits;

architecture arch of adder8bits is
    signal internalOperand1 : std_logic_vector(0 to 8);
    signal internalOperand2 : std_logic_vector(0 to 8);
    signal internalResult   : std_logic_vector(0 to 8);

begin
    -- set-up
    internalOperand1 <= '0'&operand1;
    internalOperand2 <= '0'&operand2;
    
    -- perform
    internalResult <= internalOperand1 + internalOperand2 + (X"00"&carryin);
    
    -- write
    carryout <= internalResult(0);
    result <= internalResult(1 to 8);

end arch;

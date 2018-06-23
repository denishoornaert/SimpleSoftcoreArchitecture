library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity substractor is
    Port (
        mode     : IN  std_logic_vector(0 to 1); -- "00" : 32bits, "01" : 16bits and "10" : 8bits
        operand1 : IN  std_logic_vector(0 to 31);
        operand2 : IN  std_logic_vector(0 to 31);
        result   : OUT std_logic_vector(0 to 31);
        carries  : OUT std_logic_vector(0 to 3)
    );
end substractor;

architecture arch of substractor is
    component adder port(
        mode     : IN  std_logic_vector(0 to 1);
        operand1 : IN  std_logic_vector(0 to 31);
        operand2 : IN  std_logic_vector(0 to 31);
        result   : OUT std_logic_vector(0 to 31);
        carries  : OUT std_logic_vector(0 to 3)
    );
    end component;
    
    type list is array (0 to 7) of std_logic_vector(0 to 31);
    type bits is array (0 to 7) of std_logic;
    
    signal internalMode     : std_logic_vector(0 to 1);
    signal internalOperand1 : std_logic_vector(0 to 31);
    signal internalOperand2 : std_logic_vector(0 to 31);
    signal internalResult   : std_logic_vector(0 to 31);
    signal internalCarries    : std_logic_vector(0 to 3);
    
begin
    internalAdder : adder port map (mode=>internalMode, operand1=>internalOperand1, operand2=>internalOperand2, result=>internalResult, carries=>internalCarries);
    
    internalMode <= mode;
    internalOperand1 <= operand1;
    
    with mode select
        internalOperand2 <= (not operand2)+'1' when "00",
                            ((not operand2(0 to 15))+'1')&((not operand2(16 to 31))+'1') when "01",
                            ((not operand2(0 to 7))+'1')&((not operand2(8 to 15))+'1')&((not operand2(16 to 23))+'1')&((not operand2(24 to 31))+'1') when others;
    
    result <= internalResult;
    carries <= internalcarries;

end arch;

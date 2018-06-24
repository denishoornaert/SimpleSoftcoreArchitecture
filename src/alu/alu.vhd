library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu is
    Port (
        reset     : IN std_logic;
        clock     : IN std_logic;
        signalsIn : IN  std_logic_vector(0 to 4);
        operand1  : IN  std_logic_vector(0 to 31);
        operand2  : IN  std_logic_vector(0 to 31);
        result    : OUT std_logic_vector(0 to 31)
    );
end alu;

architecture arch of alu is
    component adder port(
        mode     : IN  std_logic_vector(0 to 1);
        operand1 : IN  std_logic_vector(0 to 31);
        operand2 : IN  std_logic_vector(0 to 31);
        result   : OUT std_logic_vector(0 to 31);
        carries  : OUT std_logic_vector(0 to 3)
    );
    end component;
    
    component substractor port(
        mode     : IN  std_logic_vector(0 to 1);
        operand1 : IN  std_logic_vector(0 to 31);
        operand2 : IN  std_logic_vector(0 to 31);
        result   : OUT std_logic_vector(0 to 31);
        carries  : OUT std_logic_vector(0 to 3)
    );
    end component;
    
    signal internalSignalsIn : std_logic_vector(0 to 4);
    signal internalMode      : std_logic_vector(0 to 1);
    signal internalOperand1  : std_logic_vector(0 to 31);
    signal internalOperand2  : std_logic_vector(0 to 31);
    signal internalAddResult : std_logic_vector(0 to 31);
    signal internalSubResult : std_logic_vector(0 to 31);
    signal internalMulResult : std_logic_vector(0 to 31);
    signal internalDivResult : std_logic_vector(0 to 31);

begin
    intAdder       : adder       port map (mode=>internalMode, operand1=>internalOperand1, operand2=>internalOperand2, result=>internalAddResult);
    intSubstractor : substractor port map (mode=>internalMode, operand1=>internalOperand1, operand2=>internalOperand2, result=>internalSubResult);
    
    internalMode <= internalSignalsIn(2 to 4); -- isolation of the three LSBs
    
    with internalSignalsIn select
        result <= internalAddResult                     when "00000"|"00001"|"00010", -- add, add16, add8
                  internalOperand1 and internalOperand2 when "00011",                 -- and
                  internalSubResult                     when "00100"|"00101"|"00110", -- sub, sub16, sub8
                  internalOperand1 xor internalOperand2 when "00111",                 -- xor
                  internalMulResult                     when "01000"|"01001"|"01010", -- mul, mul16, mul8
                  internalOperand1 or internalOperand2  when "01011",                 -- or
                  internalDivResult                     when "01100"|"01101"|"01110", -- div, div16, div8
                  not internalOperand1                  when "01111",                 -- not
                  internalOperand1                      when "10000",                 -- mov
                  (others => '0') when others;
    
    process (reset, clock)
    begin
        if(reset='1') then
            internalSignalsIn <= (others => '0');
            internalOperand1  <= (others => '0');
            internalOperand2  <= (others => '0');
        elsif(rising_edge(clock)) then
            internalSignalsIn <= signalsIn;
            internalOperand1  <= operand1;
            internalOperand2  <= operand2;
        end if;
    end process;

end arch;

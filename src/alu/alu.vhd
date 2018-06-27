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
    
    component multiplier port(
        mode     : IN  std_logic_vector(0 to 1);
        operand1 : IN  std_logic_vector(0 to 31);
        operand2 : IN  std_logic_vector(0 to 31);
        result   : OUT std_logic_vector(0 to 31);
        carries  : OUT std_logic_vector(0 to 3)
    );
    end component;
    
    component divider port(
        mode     : IN  std_logic_vector(0 to 1);
        operand1 : IN  std_logic_vector(0 to 31);
        operand2 : IN  std_logic_vector(0 to 31);
        result   : OUT std_logic_vector(0 to 31);
        carries  : OUT std_logic_vector(0 to 3)
    );
    end component;
    
    component comparator port(
        operand1    : IN  std_logic_vector(0 to 31);
        operand2    : IN  std_logic_vector(0 to 31);
        eqFlag      : OUT std_logic;
        bgUnFlag    : OUT std_logic;
        lwUnFlag    : OUT std_logic;
        bgSnFlag    : OUT std_logic;
        lwSnFlag    : OUT std_logic
    );
    end component;
    
    -- component interfaces
    signal internalSignalsIn           : std_logic_vector(0 to 4);  -- /!\ introduce FF !
    signal internalMode                : std_logic_vector(0 to 1);
    signal internalOperand1            : std_logic_vector(0 to 31); -- /!\ introduce FF !
    signal internalOperand2            : std_logic_vector(0 to 31); -- /!\ introduce FF !
    signal internalAddResult           : std_logic_vector(0 to 31);
    signal internalSubResult           : std_logic_vector(0 to 31);
    signal internalMulResult           : std_logic_vector(0 to 31);
    signal internalDivResult           : std_logic_vector(0 to 31);
    
    -- flag registers
    signal addCarries                  : std_logic_vector(0 to 3);
    signal subCarries                  : std_logic_vector(0 to 3);
    signal mulCarries                  : std_logic_vector(0 to 3);
    signal divCarries                  : std_logic_vector(0 to 3);
    signal FEQ                         : std_logic;
    signal FBU                         : std_logic;
    signal FSU                         : std_logic;
    signal FBS                         : std_logic;
    signal FSS                         : std_logic;

begin
    intAdder       : adder       port map (mode=>internalMode, operand1=>internalOperand1, operand2=>internalOperand2, result=>internalAddResult, carries=>addCarries);
    intSubstractor : substractor port map (mode=>internalMode, operand1=>internalOperand1, operand2=>internalOperand2, result=>internalSubResult, carries=>subCarries);
    intMultiplier  : multiplier  port map (mode=>internalMode, operand1=>internalOperand1, operand2=>internalOperand2, result=>internalMulResult, carries=>mulCarries);
    intDivider     : divider     port map (mode=>internalMode, operand1=>internalOperand1, operand2=>internalOperand2, result=>internalDivResult, carries=>divCarries);
    intComparator  : comparator  port map (operand1=>internalOperand1, operand2=>internalOperand2, eqFlag=>FEQ, bgUnFlag=>FBU, lwUnFlag=>FSU, bgSnFlag=>FBS, lwSnFlag=>FSS);
    
    internalMode <= internalSignalsIn(3 to 4); -- isolation of the three LSBs
    internalSignalsIn <= signalsIn;
    internalOperand1  <= operand1;
    internalOperand2  <= operand2;
    
    process (reset, clock)
    begin
        if(reset='1') then
            addCarries <= (others => '0');
            subCarries <= (others => '0');
            mulCarries <= (others => '0');
            divCarries <= (others => '0');
            FEQ <= '0';
            FBU <= '0';
            FSU <= '0';
            FBS <= '0';
            FSS <= '0';
            result <= (others => '0');
        elsif(rising_edge(clock)) then
            case(internalSignalsIn) is
                when "00000"|"00001"|"00010" => -- add, add16, add8
                    result <= internalAddResult;
                when "00011" =>                 -- and
                    result <= internalOperand1 and internalOperand2;
                when "00100"|"00101"|"00110" => -- sub, sub16, sub8
                    result <= internalSubResult;
                when "00111" =>                 -- xor
                    result <= internalOperand1 xor internalOperand2;
                when "01000"|"01001"|"01010" => -- mul, mul16, mul8
                    result <= internalMulResult;
                when "01011" =>                 -- or
                    result <= internalOperand1 or internalOperand2;
                when "01100"|"01101"|"01110" => -- div, div16, div8
                    result <= internalDivResult;
                when "01111" =>                 -- not
                    result <= not internalOperand1;
                when "10000" =>                 -- mov
                    result <= internalOperand1;
                when "10001" => 
                    result <= (others => '0');
                when others => result <= (others => '0');
            end case;
        end if;
    end process;

end arch;

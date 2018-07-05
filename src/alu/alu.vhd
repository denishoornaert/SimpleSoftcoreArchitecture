library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu is
    Port (
        reset       : IN std_logic;
        clock       : IN std_logic;
        signalsIn   : IN  std_logic_vector(0 to 5);
        operand1    : IN  std_logic_vector(0 to 31);
        operand2    : IN  std_logic_vector(0 to 31);
        result      : OUT std_logic_vector(0 to 31);
        branchTaken : OUT std_logic
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
    
    component brancher port(
        mode        : IN  std_logic_vector (0 to 5);
        operand1    : IN  std_logic_vector (0 to 31); -- addr of where to jump
        FEQ         : IN  std_logic;
        FBU         : IN  std_logic;
        FSU         : IN  std_logic;
        FBS         : IN  std_logic;
        FSS         : IN  std_logic;
        FC0         : IN  std_logic;
        FC1         : IN  std_logic;
        FC2         : IN  std_logic;
        FC3         : IN  std_logic;
        result      : OUT std_logic_vector (0 to 31);
        branchTaken : OUT std_logic
    );
    end component;
    
    -- component interfaces
    signal internalSignalsIn           : std_logic_vector(0 to 5);  -- /!\ introduce FF !
    signal internalMode                : std_logic_vector(0 to 1);
    signal internalBranchMode          : std_logic_vector(0 to 5);
    signal internalOperand1            : std_logic_vector(0 to 31); -- /!\ introduce FF !
    signal internalOperand2            : std_logic_vector(0 to 31); -- /!\ introduce FF !
    signal internalAddResult           : std_logic_vector(0 to 31);
    signal internalSubResult           : std_logic_vector(0 to 31);
    signal internalMulResult           : std_logic_vector(0 to 31);
    signal internalDivResult           : std_logic_vector(0 to 31);
    signal internalBranchResult        : std_logic_vector(0 to 31);
    signal intFEQ                      : std_logic;
    signal intFBU                      : std_logic;
    signal intFSU                      : std_logic;
    signal intFBS                      : std_logic;
    signal intFSS                      : std_logic;
    signal intFC0                      : std_logic;
    signal intFC1                      : std_logic;
    signal intFC2                      : std_logic;
    signal intFC3                      : std_logic;
    signal intBranchTaken              : std_logic;
    
    -- flag registers
    signal addCarries                  : std_logic_vector(0 to 3);
    signal subCarries                  : std_logic_vector(0 to 3);
    signal mulCarries                  : std_logic_vector(0 to 3);
    signal divCarries                  : std_logic_vector(0 to 3);
    signal regFEQ                      : std_logic;
    signal regFBU                      : std_logic;
    signal regFSU                      : std_logic;
    signal regFBS                      : std_logic;
    signal regFSS                      : std_logic;
    signal regFC0                      : std_logic;
    signal regFC1                      : std_logic;
    signal regFC2                      : std_logic;
    signal regFC3                      : std_logic;

begin
    intAdder       : adder       port map (mode=>internalMode, operand1=>internalOperand1, operand2=>internalOperand2, result=>internalAddResult, carries=>addCarries);
    intSubstractor : substractor port map (mode=>internalMode, operand1=>internalOperand1, operand2=>internalOperand2, result=>internalSubResult, carries=>subCarries);
    intMultiplier  : multiplier  port map (mode=>internalMode, operand1=>internalOperand1, operand2=>internalOperand2, result=>internalMulResult, carries=>mulCarries);
    intDivider     : divider     port map (mode=>internalMode, operand1=>internalOperand1, operand2=>internalOperand2, result=>internalDivResult, carries=>divCarries);
    intComparator  : comparator  port map (operand1=>internalOperand1, operand2=>internalOperand2, eqFlag=>intFEQ, bgUnFlag=>intFBU, lwUnFlag=>intFSU, bgSnFlag=>intFBS, lwSnFlag=>intFSS);
    intbrancher    : brancher    port map (mode=>internalBranchMode, operand1=>internalOperand1, FEQ=>regFEQ, FBU=>regFBU, FSU=>regFSU, FBS=>regFBS, FSS=>regFSS, FC0=>regFC0, FC1=>regFC1, FC2=>regFC2, FC3=>regFC3, result=>internalBranchResult, branchTaken=>intBranchTaken);
    
    internalMode <= internalSignalsIn(4 to 5); -- isolation of the three LSBs
    internalBranchMode <= signalsIn; -- isolation of the three LSBs
    internalSignalsIn <= signalsIn;
    internalOperand1  <= operand1;
    internalOperand2  <= operand2;
    
    process (reset, clock)
    begin
        if(reset='1') then
            regFEQ <= '0';
            regFBU <= '0';
            regFSU <= '0';
            regFBS <= '0';
            regFSS <= '0';
            regFC0 <= '0';
            regFC1 <= '0';
            regFC2 <= '0';
            regFC3 <= '0';
            branchTaken <= '0';
            result <= (others => '0');
        elsif(rising_edge(clock)) then
            case(internalSignalsIn) is
                when "00000"|"00001"|"00010" => -- add, add16, add8
                    result <= internalAddResult;
                    regFC0 <= addCarries(3);
                    regFC1 <= addCarries(2);
                    regFC2 <= addCarries(1);
                    regFC3 <= addCarries(0);
                    branchTaken <= '0';
                when "00011" =>                 -- and
                    result <= internalOperand1 and internalOperand2;
                    branchTaken <= '0';
                when "00100"|"00101"|"00110" => -- sub, sub16, sub8
                    result <= internalSubResult;
                    regFC0 <= subCarries(3);
                    regFC1 <= subCarries(2);
                    regFC2 <= subCarries(1);
                    regFC3 <= subCarries(0);
                    branchTaken <= '0';
                when "00111" =>                 -- xor
                    result <= internalOperand1 xor internalOperand2;
                    branchTaken <= '0';
                when "01000"|"01001"|"01010" => -- mul, mul16, mul8
                    result <= internalMulResult;
                    regFC0 <= mulCarries(3);
                    regFC1 <= mulCarries(2);
                    regFC2 <= mulCarries(1);
                    regFC3 <= mulCarries(0);
                    branchTaken <= '0';
                when "01011" =>                 -- or
                    result <= internalOperand1 or internalOperand2;
                    branchTaken <= '0';
                when "01100"|"01101"|"01110" => -- div, div16, div8
                    result <= internalDivResult;
                    regFC0 <= divCarries(3);
                    regFC1 <= divCarries(2);
                    regFC2 <= divCarries(1);
                    regFC3 <= divCarries(0);
                    branchTaken <= '0';
                when "01111" =>                 -- not
                    branchTaken <= '0';
                    result <= not internalOperand1;
                when "10000" =>                 -- mov
                    branchTaken <= '0';
                    result <= internalOperand1;
                when "10001" =>                 -- cmp
                    regFEQ <= intFEQ;
                    regFBU <= intFBU;  -- TODO introduce new signals so that latches are avoided
                    regFSU <= intFSU;
                    regFBS <= intFBS;
                    regFSS <= intFSS;
                    branchTaken <= '0';
                    result <= (others => '0');
                when "10010" =>                 -- any kind of branching instruction
                    branchTaken <= intBranchTaken;
                    result <= internalBranchResult;
                when others =>
                    branchTaken <= '0';
                    result <= (others => '0');
            end case;
        end if;
    end process;

end arch;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_MISC.ALL;

entity comparator is
    Port (
        operand1    : IN  std_logic_vector(0 to 31);
        operand2    : IN  std_logic_vector(0 to 31);
        equalFlag   : OUT std_logic;
        biggerFlag  : OUT std_logic;
        smallerFlag : OUT std_logic
    );
end comparator;

architecture arch of comparator is
    signal intermediateEqualityResult : std_logic_vector(0 to 31);
    signal intermediateBiggerResult   : std_logic_vector(0 to 31);
    signal intermediateSmallerResult  : std_logic_vector(0 to 31);
    signal resultEqual                : std_logic;
    signal resultBigger               : std_logic;

begin
    equal: for i in 0 to 31 generate
        intermediateEqualityResult(i) <= operand1(i) xnor operand2(i);
    end generate equal;
    equalFlag <= and_reduce(intermediateEqualityResult);
    resultEqual <= and_reduce(intermediateEqualityResult);
    
    bigger: for i in 0 to 31 generate
        eq32: if i=0 generate
            intermediateBiggerResult(i) <= operand1(i) and (not operand2(i));
        end generate eq32;
        otherwise: if i/=0 generate
            intermediateBiggerResult(i) <= (operand1(i) and (not operand2(i))) and and_reduce(intermediateEqualityResult(0 to i-1));
        end generate otherwise;
    end generate bigger;
    biggerFlag <= or_reduce(intermediateBiggerResult);
    resultBigger <= or_reduce(intermediateBiggerResult);
    
    smallerFlag <= resultEqual nor resultBigger;

    

end arch;

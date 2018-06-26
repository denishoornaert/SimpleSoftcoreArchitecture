library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_MISC.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity comparator is
    Port (
        operand1    : IN  std_logic_vector(0 to 31);
        operand2    : IN  std_logic_vector(0 to 31);
        eqFlag      : OUT std_logic;
        bgUnFlag    : OUT std_logic;
        lwUnFlag    : OUT std_logic;
        bgSnFlag    : OUT std_logic;
        lwSnFlag    : OUT std_logic
    );
end comparator;

architecture arch of comparator is
    signal intermediateEqualityResult : std_logic_vector(0 to 31);
    signal intermediateBiggerResult   : std_logic_vector(0 to 31);
    signal intermediateSmallerResult  : std_logic_vector(0 to 31);
    signal resultEqual                : std_logic;
    signal resultUnsignedBigger       : std_logic;
    signal resultSignedBigger         : std_logic;
    signal intermediateSubtractionRes : std_logic_vector(0 to 31);

begin
    equal: for i in 0 to 31 generate
        intermediateEqualityResult(i) <= operand1(i) xnor operand2(i);
    end generate equal;
    eqFlag <= and_reduce(intermediateEqualityResult);
    resultEqual <= and_reduce(intermediateEqualityResult);
    
    bigger: for i in 0 to 31 generate
        eqzero: if i=0 generate
            intermediateBiggerResult(i) <= operand1(i) and (not operand2(i));
        end generate eqzero;
        otherwise: if i/=0 generate
            intermediateBiggerResult(i) <= (operand1(i) and (not operand2(i))) and and_reduce(intermediateEqualityResult(0 to i-1));
        end generate otherwise;
    end generate bigger;
    bgUnFlag <= or_reduce(intermediateBiggerResult);
    resultUnsignedBigger <= or_reduce(intermediateBiggerResult);
    
    intermediateSubtractionRes <= operand1 + operand2;
    resultSignedBigger <= (not intermediateSubtractionRes(0)) and (or_reduce(intermediateSubtractionRes(1 to 31))); -- strictly bigger than zero -> msb to 0 and there exists at least one 1
    
    lwUnFlag <= resultEqual nor resultUnsignedBigger;
    
    with resultEqual select
        eqFlag <= '1' when '1',
                  '0' when others;
    with resultEqual select
        bgSnFlag <= '0' when '1',
                  resultSignedBigger when others;
                  
    lwSnFlag <= not resultSignedBigger;

end arch;

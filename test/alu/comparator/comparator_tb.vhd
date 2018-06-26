library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity comparator_tb is
end comparator_tb;

architecture Behavioral of comparator_tb is
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
    
    type list is array (0 to 7) of std_logic_vector(0 to 31);
    type bits is array (0 to 7) of std_logic;
    
    signal intOperand1            : std_logic_vector(0 to 31);
    signal intOperand2            : std_logic_vector(0 to 31);
    signal intEqualFlag           : std_logic;
    signal intBiggerUnsignedFlag  : std_logic;
    signal intSmallerUnsignedFlag : std_logic;
    signal intBiggerSignedFlag    : std_logic;
    signal intSmallerSignedFlag   : std_logic;

begin
    tbcomparator : comparator port map (operand1=>intOperand1, operand2=>intOperand2, eqFlag=>intEqualFlag, bgUnFlag=>intBiggerUnsignedFlag, lwUnFlag=>intSmallerUnsignedFlag, bgSnFlag=>intBiggerSignedFlag, lwSnFlag=>intSmallerSignedFlag);
    
    stimuli : process
            -- inputs
            variable ops1    : list := (X"0000000A", X"FFFFFFFF", X"FFFFFFFF", X"00000F00", X"01010101", X"e0f72f38", X"5c133e99", X"3fbc6412");
            variable ops2    : list := (X"00000000", X"00000000", X"00000001", X"00000F00", X"01010101", X"054deacf", X"faa214eb", X"3f206a5b");
            -- answers
            variable eqFlag  : bits := ('0', '0', '0', '1', '1', '0', '0', '0');
            variable bgUFlag : bits := ('1', '1', '1', '0', '0', '1', '0', '1');
            variable lwUFlag : bits := ('0', '0', '0', '0', '0', '0', '1', '0');
            variable bgSFlag : bits := ('1', '0', '0', '0', '0', '0', '1', '1');
            variable lwSFlag : bits := ('0', '1', '1', '0', '0', '1', '0', '0');
            
        begin
            for i in 0 to 7 loop
                intOperand1 <= ops1(i);
                intOperand2 <= ops2(i);
                wait for 125 ns;
                assert ((intEqualFlag = eqFlag(i)) and (intBiggerUnsignedFlag = bgUFlag(i)) and (intSmallerUnsignedFlag = lwUFlag(i)) and (intBiggerSignedFlag = bgSFlag(i)) and (intSmallerUnsignedFlag = lwUFlag(i))) report "Error !";
            end loop;
        end process;

end Behavioral;

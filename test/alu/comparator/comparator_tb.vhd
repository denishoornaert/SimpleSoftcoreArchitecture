library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity comparator_tb is
end comparator_tb;

architecture Behavioral of comparator_tb is
    component comparator port(
        operand1    : IN  std_logic_vector(0 to 31);
        operand2    : IN  std_logic_vector(0 to 31);
        equalFlag   : OUT std_logic;
        biggerFlag  : OUT std_logic;
        smallerFlag : OUT std_logic
    );
    end component;
    
    type list is array (0 to 7) of std_logic_vector(0 to 31);
    type bits is array (0 to 7) of std_logic;
    
    signal internalOperand1    : std_logic_vector(0 to 31);
    signal internalOperand2    : std_logic_vector(0 to 31);
    signal internalEqualFlag   : std_logic;
    signal internalBiggerFlag  : std_logic;
    signal internalSmallerFlag : std_logic;

begin
    tbcomparator : comparator port map (operand1=>internalOperand1, operand2=>internalOperand2, equalFlag=>internalEqualFlag, biggerFlag=>internalBiggerFlag, smallerFlag=>internalSmallerFlag);
    
    stimuli : process
            -- inputs
            variable ops1    : list := (X"0000000A", X"FFFFFFFF", X"FFFFFFFF", X"00000F00", X"01010101", X"e0f72f38", X"5c133e99", X"3fbc6412");
            variable ops2    : list := (X"00000000", X"00000000", X"00000001", X"00000F00", X"01010101", X"054deacf", X"faa214eb", X"3f206a5b");
            -- answers
            variable eqFlag : bits := ('0', '0', '0', '1', '1', '0', '0', '0');
            variable bgFlag : bits := ('1', '1', '1', '0', '0', '1', '0', '1');
            variable smFlag : bits := ('0', '0', '0', '0', '0', '0', '1', '0');
            
        begin
            for i in 0 to 7 loop
                internalOperand1 <= ops1(i);
                internalOperand2 <= ops2(i);
                wait for 125 ns;
                assert ((internalEqualFlag = eqFlag(i)) and (internalBiggerFlag = bgFlag(i)) and (internalSmallerFlag = smFlag(i))) report "Error !";
            end loop;
        end process;

end Behavioral;

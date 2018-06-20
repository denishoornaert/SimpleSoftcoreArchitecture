library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity adder_tb is
end adder_tb;

architecture arch of adder_tb is
    component adder port(
        operand1 : IN  std_logic_vector(0 to 31);
        operand2 : IN  std_logic_vector(0 to 31);
        result   : OUT std_logic_vector(0 to 31);
        carry    : OUT std_logic
    );
    end component;
    
    type list is array (0 to 7) of std_logic_vector(0 to 31);
    type bits is array (0 to 7) of std_logic;
    
    signal internalOperand1 : std_logic_vector(0 to 31);
    signal internalOperand2 : std_logic_vector(0 to 31);
    signal internalResult   : std_logic_vector(0 to 31);
    signal internalCarry    : std_logic;
    
begin
    tbadder : adder port map (operand1=>internalOperand1, operand2=>internalOperand2, result=>internalResult, carry=>internalCarry);

    stimuli : process
        variable ops1  : list := (X"0000000A", X"FFFFFFFF", X"FFFFFFFF", X"00000F00", X"01010101", X"e0f72f38", X"5c133e99", X"3fbc6412");
        variable ops2  : list := (X"00000000", X"00000000", X"00000001", X"00000F00", X"01010101", X"054deacf", X"faa214eb", X"3f206a5b");
        variable ans   : list := (X"0000000A", X"FFFFFFFF", X"00000000", X"00001E00", X"02020202", X"e6451a07", X"56b55384", X"7edcce6d");
        variable carry : bits := ('0', '0', '1', '0', '0', '0', '1', '0');
        
    begin
        for i in 0 to 7 loop
            internalOperand1 <= ops1(i);
            internalOperand2 <= ops2(i);
            wait for 125 ns;
            assert ((internalResult = ans(i)) and (internalCarry = carry(i))) report "Error !";
        end loop;
    end process;

end arch;

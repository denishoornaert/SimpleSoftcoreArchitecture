library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity adder8bits_tb is
end adder8bits_tb;

architecture arch of adder8bits_tb is
component adder8bits port(
        operand1 : IN  std_logic_vector(0 to 7);
        operand2 : IN  std_logic_vector(0 to 7);
        result   : OUT std_logic_vector(0 to 7);
        carry    : OUT std_logic
    );
    end component;
    
    type list is array (0 to 7) of std_logic_vector(0 to 7);
    type bits is array (0 to 7) of std_logic;
    
    signal internalOperand1 : std_logic_vector(0 to 7);
    signal internalOperand2 : std_logic_vector(0 to 7);
    signal internalResult   : std_logic_vector(0 to 7);
    signal internalCarry    : std_logic;
    
begin
    tbadder8bits : adder8bits port map (operand1=>internalOperand1, operand2=>internalOperand2, result=>internalResult, carry=>internalCarry);

    stimuli : process
        variable ops1  : list := (X"0A", X"FF", X"FF", X"0F", X"01", X"38", X"99", X"12");
        variable ops2  : list := (X"00", X"00", X"01", X"0F", X"01", X"cf", X"eb", X"5b");
        variable ans   : list := (X"0A", X"FF", X"00", X"1E", X"02", X"07", X"84", X"6d");
        variable carry : bits := ('0', '0', '1', '0', '0', '1', '1', '0');
        
    begin
        for i in 0 to 7 loop
            internalOperand1 <= ops1(i);
            internalOperand2 <= ops2(i);
            wait for 125 ns;
            assert ((internalResult = ans(i)) and (internalCarry = carry(i))) report "Error !";
        end loop;
    end process;
end arch;

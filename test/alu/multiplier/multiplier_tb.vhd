library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity multiplier_tb is
end multiplier_tb;

architecture arch of multiplier_tb is
    component multiplier port(
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
    signal internalCarry    : std_logic_vector(0 to 3);
    
begin
    tbmultiplier : multiplier port map (mode=>internalMode, operand1=>internalOperand1, operand2=>internalOperand2, result=>internalResult, carries=>internalCarry);

    stimuli : process
        -- inputs
        variable ops1    : list := (X"0000000A", X"FFFFFFFF", X"FFFFFFFF", X"00000F00", X"01010101", X"e0f72f38", X"5c133e99", X"3fbc6412");
        variable ops2    : list := (X"00000000", X"00000000", X"00000001", X"00000F00", X"01010101", X"054deacf", X"faa214eb", X"3f206a5b");
        -- answers for 32bits
        variable ans32   : list := (X"00000000", X"00000000", X"FFFFFFFF", X"00E10000", X"04030201", X"24e05e48", X"0d606a73", X"99a70666");
        -- answers for 16bits
        variable ans16   : list := (X"00000000", X"00000000", X"0000FFFF", X"00000000", X"02010201", X"7d4b5e48", X"d2066a73", X"3b800666");
        -- answers for 8bits
        variable ans8    : list := (X"00000000", X"00000000", X"000000FF", X"0000E100", X"01010101", X"604bf648", X"d806d873", X"81806866");
        
    begin
        internalMode <= "00";
        for i in 0 to 7 loop
            internalOperand1 <= ops1(i);
            internalOperand2 <= ops2(i);
            wait for 41 ns;
            assert (internalResult = ans32(i)) report "Error !";
        end loop;
        
        internalMode <= "01";
        for i in 0 to 7 loop
            internalOperand1 <= ops1(i);
            internalOperand2 <= ops2(i);
            wait for 41 ns;
            assert (internalResult = ans16(i)) report "Error !";
        end loop;
        
        internalMode <= "10";
        for i in 0 to 7 loop
            internalOperand1 <= ops1(i);
            internalOperand2 <= ops2(i);
            wait for 41 ns;
            assert (internalResult = ans8(i)) report "Error !";
        end loop;
    end process;

end arch;

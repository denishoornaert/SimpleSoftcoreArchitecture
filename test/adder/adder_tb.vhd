library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity adder_tb is
end adder_tb;

architecture arch of adder_tb is
    component adder port(
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
    tbadder : adder port map (mode=>internalMode, operand1=>internalOperand1, operand2=>internalOperand2, result=>internalResult, carries=>internalCarry);

    stimuli : process
        -- inputs
        variable ops1    : list := (X"0000000A", X"FFFFFFFF", X"FFFFFFFF", X"00000F00", X"01010101", X"e0f72f38", X"5c133e99", X"3fbc6412");
        variable ops2    : list := (X"00000000", X"00000000", X"00000001", X"00000F00", X"01010101", X"054deacf", X"faa214eb", X"3f206a5b");
        -- answers for 32bits
        variable ans32   : list := (X"0000000A", X"FFFFFFFF", X"00000000", X"00001E00", X"02020202", X"e6451a07", X"56b55384", X"7edcce6d");
        variable carry32 : bits := ('0', '0', '1', '0', '0', '0', '1', '0');
        -- answers for 16bits
        variable ans16   : list := (X"0000000A", X"FFFFFFFF", X"FFFF0000", X"00001E00", X"02020202", X"e6441a07", X"56b55384", X"7edcce6d");
        variable carry160: bits := ('0', '0', '0', '0', '0', '0', '1', '0');
        variable carry161: bits := ('0', '0', '1', '0', '0', '1', '0', '0');
        -- answers for 8bits
        variable ans8    : list := (X"0000000A", X"FFFFFFFF", X"FFFFFF00", X"00001E00", X"02020202", X"e5441907", X"56b55284", X"7edcce6d");
        variable carry80 : bits := ('0', '0', '0', '0', '0', '0', '1', '0');
        variable carry81 : bits := ('0', '0', '0', '0', '0', '1', '0', '0');
        variable carry82 : bits := ('0', '0', '0', '0', '0', '1', '0', '0');
        variable carry83 : bits := ('0', '0', '1', '0', '0', '1', '1', '0');
        
    begin
        internalMode <= "00";
        for i in 0 to 7 loop
            internalOperand1 <= ops1(i);
            internalOperand2 <= ops2(i);
            wait for 41 ns;
            assert ((internalResult = ans32(i)) and (internalCarry(0) = carry32(i))) report "Error !";
        end loop;
        
        internalMode <= "01";
        for i in 0 to 7 loop
            internalOperand1 <= ops1(i);
            internalOperand2 <= ops2(i);
            wait for 41 ns;
            assert ((internalResult = ans16(i)) and (internalCarry(0) = carry160(i)) and (internalCarry(2) = carry161(i))) report "Error !";
        end loop;
        
        internalMode <= "10";
        for i in 0 to 7 loop
            internalOperand1 <= ops1(i);
            internalOperand2 <= ops2(i);
            wait for 41 ns;
            assert ((internalResult = ans8(i)) and (internalCarry(0) = carry80(i)) and (internalCarry(1) = carry81(i)) and (internalCarry(2) = carry82(i)) and (internalCarry(3) = carry83(i))) report "Error !";
        end loop;
    end process;

end arch;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity multiplier is
    Port (
        mode     : IN  std_logic_vector(0 to 1); -- "00" : 32bits, "01" : 16bits and "10" : 8bits
        operand1 : IN  std_logic_vector(0 to 31);
        operand2 : IN  std_logic_vector(0 to 31);
        result   : OUT std_logic_vector(0 to 31);
        carries  : OUT std_logic_vector(0 to 3)
    );
end multiplier;

architecture arch of multiplier is
    signal result32  : std_logic_vector(0 to 31);
    signal result320 : std_logic_vector(0 to 63);
    signal result16  : std_logic_vector(0 to 31);
    signal result160 : std_logic_vector(0 to 31);
    signal result161 : std_logic_vector(0 to 31);
    signal result8   : std_logic_vector(0 to 31);
    signal result80  : std_logic_vector(0 to 15);
    signal result81  : std_logic_vector(0 to 15);
    signal result82  : std_logic_vector(0 to 15);
    signal result83  : std_logic_vector(0 to 15);
    
begin
    result320 <= operand1*operand2;

    result160 <= operand1(0 to 15)*operand2(0 to 15);
    result161 <= operand1(16 to 31)*operand2(16 to 31);

    result80 <= operand1(0 to 7)*operand2(0 to 7);
    result81 <= operand1(8 to 15)*operand2(8 to 15);
    result82 <= operand1(16 to 23)*operand2(16 to 23);
    result83 <= operand1(24 to 31)*operand2(24 to 31);

    result32 <= result320(32 to 63);
    result16 <= result160(16 to 31)&result161(16 to 31);
    result8  <= result80(8 to 15)&result81(8 to 15)&result82(8 to 15)&result83(8 to 15);

    with mode select
        result <= result32 when "00",
                  result16 when "01",
                  result8  when "10",
                  (others => '0') when others;

    carries <= (others => '0');

end arch;

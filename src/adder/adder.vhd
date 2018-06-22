library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity adder is
    Port (
        operand1 : IN  std_logic_vector(0 to 31);
        operand2 : IN  std_logic_vector(0 to 31);
        result   : OUT std_logic_vector(0 to 31);
        carries  : OUT std_logic_vector(0 to 3)
    );
end adder;

architecture arch of adder is
    component adder8bits port(
        carryin  : IN  std_logic;
        operand1 : IN  std_logic_vector(0 to 7);
        operand2 : IN  std_logic_vector(0 to 7);
        result   : OUT std_logic_vector(0 to 7);
        carryout : OUT std_logic
    );
    end component;
    
    signal add81cin : std_logic;
    signal add81op1 : std_logic_vector(0 to 7);
    signal add81op2 : std_logic_vector(0 to 7);
    signal add81res : std_logic_vector(0 to 7);
    signal add81car : std_logic;
    
    signal add82cin : std_logic;
    signal add82op1 : std_logic_vector(0 to 7);
    signal add82op2 : std_logic_vector(0 to 7);
    signal add82res : std_logic_vector(0 to 7);
    signal add82car : std_logic;
    
    signal add83cin : std_logic;
    signal add83op1 : std_logic_vector(0 to 7);
    signal add83op2 : std_logic_vector(0 to 7);
    signal add83res : std_logic_vector(0 to 7);
    signal add83car : std_logic;
    
    signal add84cin : std_logic;
    signal add84op1 : std_logic_vector(0 to 7);
    signal add84op2 : std_logic_vector(0 to 7);
    signal add84res : std_logic_vector(0 to 7);
    signal add84car : std_logic;
    
    signal inResult : std_logic_vector(0 to 31);
    
begin
    add81 : adder8bits port map (carryin=>add81cin, operand1=>add81op1, operand2=>add81op2, result=>add81res, carryout=>add81car);
    add82 : adder8bits port map (carryin=>add82cin, operand1=>add82op1, operand2=>add82op2, result=>add82res, carryout=>add82car);
    add83 : adder8bits port map (carryin=>add83cin, operand1=>add83op1, operand2=>add83op2, result=>add83res, carryout=>add83car);
    add84 : adder8bits port map (carryin=>add84cin, operand1=>add84op1, operand2=>add84op2, result=>add84res, carryout=>add84car);
    
    -- set up adders
    add81op1 <= operand1(24 to 31);
    add81op2 <= operand2(24 to 31);
    add81cin <= '0';
    
    add82op1 <= operand1(16 to 23);
    add82op2 <= operand2(16 to 23);
    add82cin <= add81car;
    
    add83op1 <= operand1(8 to 15);
    add83op2 <= operand2(8 to 15);
    add83cin <= add82car;
    
    add84op1 <= operand1(0 to 7);
    add84op2 <= operand2(0 to 7);
    add84cin <= add83car;
    
    -- gather results
    inResult(24 to 31) <= add81res;
    inResult(16 to 23) <= add82res;
    inResult(8 to 15)  <= add83res;
    inResult(0 to 7)   <= add84res;
    
    -- drive out
    result <= inResult;
    carries <= add84car&add83car&add82car&add81car;
end arch;

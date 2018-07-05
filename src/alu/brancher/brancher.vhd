library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity brancher is
    Port (
        mode        : IN  std_logic_vector (0 to 5);
        operand1    : IN  std_logic_vector (0 to 31); -- addr of where to jump
        FEQ         : IN  std_logic;
        FBU         : IN  std_logic;
        FSU         : IN  std_logic;
        FBS         : IN  std_logic;
        FSS         : IN  std_logic;
        FC0         : IN  std_logic;
        FC1         : IN  std_logic;
        FC2         : IN  std_logic;
        FC3         : IN  std_logic;
        result      : OUT std_logic_vector (0 to 31);
        branchTaken : OUT std_logic
    );
end brancher;

architecture arch of brancher is
    signal branch : std_logic;
    signal resjeq  : std_logic;
    signal resjne  : std_logic;
    signal resjlwu : std_logic;
    signal resjlws : std_logic;
    signal resjgtu : std_logic;
    signal resjgts : std_logic;
    signal resjleu : std_logic;
    signal resjles : std_logic;
    signal resjgeu : std_logic;
    signal resjges : std_logic;
    signal resjcr0 : std_logic;
    signal resjcr1 : std_logic;
    signal resjcr2 : std_logic;
    signal resjcr3 : std_logic;

begin
    resjeq  <= '1' when (FEQ='1') else '0';
    resjne  <= '1' when (FEQ='0') else '0';
    resjlwu <= '1' when (FSU='1') else '0';
    resjlws <= '1' when (FSS='1') else '0';
    resjgtu <= '1' when (FBU='1') else '0';
    resjgts <= '1' when (FBS='1') else '0';
    resjleu <= '1' when (FEQ='1' or FSU='1') else '0';
    resjles <= '1' when (FEQ='1' or FSS='1') else '0';
    resjgeu <= '1' when (FEQ='1' or FBU='1') else '0';
    resjges <= '1' when (FEQ='1' or FBS='1') else '0';
    resjcr0 <= '1' when (FC0='1') else '0';
    resjcr1 <= '1' when (FC1='1') else '0';
    resjcr2 <= '1' when (FC2='1') else '0';
    resjcr3 <= '1' when (FC3='1') else '0';
    
    with mode select
        branch <= resjeq  when "010101",
                  resjne  when "010110",
                  resjlwu when "010111",
                  resjlws when "011000",
                  resjgtu when "011001",
                  resjgts when "011010",
                  resjleu when "011011",
                  resjles when "011100",
                  resjgeu when "011101",
                  resjges when "011110",
                  resjcr0 when "011111",
                  resjcr1 when "100000",
                  resjcr2 when "100001",
                  resjcr3 when "100010",
                  '0'    when others;

    branchTaken <= branch;
    with branch select
        result <= operand1        when '1',
                  (others => '0') when '0',
                  (others => '0') when others;

end arch;

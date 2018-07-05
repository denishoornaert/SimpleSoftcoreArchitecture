library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity brancher_tb is
end brancher_tb;

architecture Behavioral of brancher_tb is
    component brancher port(
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
    end component;
    
    type modes  is array (0 to 13) of std_logic_vector(0 to 5);
    type list   is array (0 to 7)  of std_logic_vector(0 to 31);
    type bits   is array (0 to 8)  of std_logic;
    type matrix is array (0 to 8)  of std_logic_vector(0 to 13);
    
    signal intMode        : std_logic_vector(0 to 5);
    signal intOperand1    : std_logic_vector(0 to 31); -- addrIn
    signal intFEQ         : std_logic;
    signal intFBU         : std_logic;
    signal intFSU         : std_logic;
    signal intFBS         : std_logic;
    signal intFSS         : std_logic;
    signal intFC0         : std_logic;
    signal intFC1         : std_logic;
    signal intFC2         : std_logic;
    signal intFC3         : std_logic;
    signal intResult      : std_logic_vector (0 to 31);
    signal intBranchTaken : std_logic;

begin
    tbbrancher : brancher port map (mode=>intMode, operand1=>intOperand1, FEQ=>intFEQ, FBU=>intFBU, FSU=>intFSU, FBS=>intFBS, FSS=>intFSS, FC0=>intFC0, FC1=>intFC1, FC2=>intFC2, FC3=>intFC3, result=>intResult, branchTaken=>intBranchTaken);
    
    stimuli : process
            -- inputs                 jeq       jne       jlwu      jlws      jgtu      jgts      jleu      jles      jgeu      jges      jcr0      jcr1      jcr2      jcr3
            variable mode : modes := ("010101", "010110", "010111", "011000", "011001", "011010", "011011", "011100", "011101", "011110", "011111", "100000", "100001", "100010");
            variable vFEQ : bits := ('1', '0', '0', '0', '0', '0', '0', '0', '0');
            variable vFBU : bits := ('0', '1', '0', '0', '0', '0', '0', '0', '0');
            variable vFSU : bits := ('0', '0', '1', '0', '0', '0', '0', '0', '0');
            variable vFBS : bits := ('0', '0', '0', '1', '0', '0', '0', '0', '0');
            variable vFSS : bits := ('0', '0', '0', '0', '1', '0', '0', '0', '0');
            variable vFC0 : bits := ('0', '0', '0', '0', '0', '1', '0', '0', '0');
            variable vFC1 : bits := ('0', '0', '0', '0', '0', '0', '1', '0', '0');
            variable vFC2 : bits := ('0', '0', '0', '0', '0', '0', '0', '1', '0');
            variable vFC3 : bits := ('0', '0', '0', '0', '0', '0', '0', '0', '1');
            -- answers                   jeq  jne  jlwu jlws jgtu jgts jleu jles jgeu jges jcr0 jcr1 jcr2 jcr3
            variable BrTk : matrix  := (('1', '0', '0', '0', '0', '0', '1', '1', '1', '1', '0', '0', '0', '0'),  -- FEQ
                                        ('0', '1', '0', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0'),  -- FBU
                                        ('0', '1', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0'),  -- FSU
                                        ('0', '1', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0'),  -- FBS
                                        ('0', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0'),  -- FSS
                                        ('0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),  -- FC0
                                        ('0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),  -- FC1
                                        ('0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'),  -- FC2
                                        ('0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1')); -- FC3
                                        
            variable rOut : list := (X"AAAAAAAA", X"AAAAAAAA", X"AAAAAAAA", X"AAAAAAAA", X"00000000", X"00000000", X"00000000", X"00000000");
            
        begin
            intOperand1 <= X"AAAAAAAA";
            for i in 0 to 8 loop
                intFEQ  <= vFEQ(i);
                intFBU  <= vFBU(i);
                intFSU  <= vFSU(i);
                intFBS  <= vFBS(i);
                intFSS  <= vFSS(i);
                intFC0  <= vFC0(i);
                intFC1  <= vFC1(i);
                intFC2  <= vFC2(i);
                intFC3  <= vFC3(i);
                for j in 0 to 13 loop
                    intMode <= mode(j);
                    wait for 7 ns;
                    assert (intBranchTaken = brTk(i)(j)) report "Error !";
                end loop;
            end loop;
        end process;

end Behavioral;

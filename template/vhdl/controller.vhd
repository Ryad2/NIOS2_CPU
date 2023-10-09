library ieee;
use ieee.std_logic_1164.all;

entity controller is
    port(
        clk        : in  std_logic;
        reset_n    : in  std_logic;
        -- instruction opcode
        op         : in  std_logic_vector(5 downto 0);
        opx        : in  std_logic_vector(5 downto 0);
        -- activates branch condition
        branch_op  : out std_logic;
        -- immediate value sign extention
        imm_signed : out std_logic;
        -- instruction register enable
        ir_en      : out std_logic;
        -- PC control signals
        pc_add_imm : out std_logic;
        pc_en      : out std_logic;
        pc_sel_a   : out std_logic;
        pc_sel_imm : out std_logic;
        -- register file enable
        rf_wren    : out std_logic;
        -- multiplexers selections
        sel_addr   : out std_logic;
        sel_b      : out std_logic;
        sel_mem    : out std_logic;
        sel_pc     : out std_logic;
        sel_ra     : out std_logic;
        sel_rC     : out std_logic;
        -- write memory output
        read       : out std_logic;
        write      : out std_logic;
        -- alu op
        op_alu     : out std_logic_vector(5 downto 0)
    );
end controller;

architecture synth of controller is

    type state_type is (FETCH1 , FETCH2 , DECODE, BREAK, STORE, R_OP, I_OP, LOAD1, LOAD2, BRANCH, CALL, CALLR, JMP, JMPI);
    signal current_state, next_state : state_type;
    signal s_op, s_opx : unsigned(5 downto 0);
    signal s_branch : std_logic;
    signal s_wrEnable : std_logic;
    signal s_pcEnable : std_logic;

begin

    s_pcEnable <= '1' when (current_state = FETCH2 or current_state = CALL or current_state = CALLR or current_state = JMP or current_state = JMPI) else '0';
    s_wrEnable <= '1' when (current_state = I_OP or current_state = R_OP or current_state = LOAD2 or current_state = CALL or current_state = CALLR) else '0';
    s_branch <= '1' when (s_op = x"06" or s_op = x"0E" or s_op = x"16" or s_op = x"1E" or s_op = x"26" or s_op = x"2E" or s_op = x"36") else '0';
    s_op <= unsigned(op);
    s_opx <= unsigned(opx);

    s_itype <= '1' when else '0';
    s_rtype <= '1' when else '0';

process(clk, reset_n)
begin
    if reset_n = '0' then
        current_state <= FETCH1;

    elsif rising_edge(clk) then
        current_state <= next_state;
    end if;
end process;

next_state <= FETCH2 when current_state = FETCH1 else
            DECODE when current_state = FETCH2 else
            LOAD2 when current_state = LOAD1 else
            R_OP when current_state = DECODE and s_op = X"3A" and not(s_opx = X"3A" or s_opx = X"05" or s_opx = X"0D") else
            LOAD1 when current_state = DECODE and s_op = X"17"  else
            STORE when current_state = DECODE and s_op = X"15"  else
            BRANCH when current_state = DECODE and s_branch = '1' else 
            CALL when current_state = DECODE and s_op = X"00" else
            CALLR when current_state = DECODE and s_op = X"3A" and (s_opx = X"05") else
            JMP when current_state = DECODE and s_op = X"3A" and (s_opx = X"0D") else
            JMPI when current_state = DECODE and s_op = X"01" else
            BREAK when OTHERS;

            
sel_addr <= '1' when (current_state = FETCH1 or current_state = LOAD1 or current_state = STORE) else '0';
sel_pc <= '1' when (current_state = FETCH2 or current_state = CALL or current_state = CALLR) else '0';
sel_b <= '1' when (current_state = R_OP or current_state = STORE) else '0';
sel_mem <= '1' --mis ici pour l instant pas encore d info
sel_ra <= '1' when (current_state = CALL or current_state = CALLR) else '0';


pc_en <= '1' when s_pcEnable = '1' else '0';
pc_add_imm <= '1' when current_state = BRANCH else '0';
pc_sel_imm <= '1' when (current_state = CALL or current_state = JMPI) else '0';
pc_sel_a <= '1' when (current_state = CALLR or current_state = JMP) else '0';


ir_en <= '1' when current_state = FETCH2 else '0';
rf_wren <= '1' when s_wrEnable = '1' else '0';
imm_signed <= '1' when current_state = I_OP else '0';
branch_op <= '1' when current_state = BRANCH else '0';


read <= '1' when (current_state = FETCH1 or current_state = LOAD1) else '0';
write <= '1' when current_state = STORE else '0';
            
op_alu <= "100001" when (s_op = X"3A" and s_opx = X"0E") else
        "110011" when (s_op = X"3A" and s_opx = X"1B") else
        "000000" when (s_op = X"04") else
        "000000" when (s_op = X"17") else
        "000000" when (s_op = x"15") else
        "011100" when (s_op = x"06") else
        "011001" when (s_op = x"0E") else
        "011010" when (s_op = x"16") else
        "011011" when (s_op = x"1E") else
        "011100" when (s_op = x"26") else
        "011101" when (s_op = x"2E") else
        "011110" when (s_op = x"36") else
        "111111" when OTHERS;


end synth;

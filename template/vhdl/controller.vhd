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

    type state_type is (FETCH1 , FETCH2 , DECODE, BREAK, STORE, R_OP, I_OP, LOAD1, LOAD2);
    signal current_state, next_state : state_type;
    signal s_op, s_opx : unsigned(5 downto 0);

begin

    s_op <= unsigned(op);
    s_opx <= unsigned(opx);

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
            R_OP when current_state = DECODE and s_op = X"3A" and not (s_opx = X"3A")  else
            LOAD1 when current_state = DECODE and s_op = X"17"  else
            STORE when current_state = DECODE and s_op = X"15"  else
            BREAK when OTHERS;

process (clk, reset_n)
begin
    
end process;


end synth;

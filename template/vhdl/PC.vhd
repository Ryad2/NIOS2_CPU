library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC is
    port(
        clk     : in  std_logic;
        reset_n : in  std_logic;
        en      : in  std_logic;
        sel_a   : in  std_logic;
        sel_imm : in  std_logic;
        add_imm : in  std_logic;
        imm     : in  std_logic_vector(15 downto 0);
        a       : in  std_logic_vector(15 downto 0);
        addr    : out std_logic_vector(31 downto 0)
    );
end PC;

architecture synth of PC is

    signal cur_addr : std_logic_vector(15 downto 0) := (others => '0');
    signal next_addr : std_logic_vector(15 downto 0) := (others => '0');

begin
    
    addr(31 downto 16) <= (others => '0');
    addr(15 downto 0) <= cur_addr;

    process (clk, reset_n)
    begin
        if reset_n = '0' then
            cur_addr <= (others => '0');

        elsif rising_edge (clk) then
            if en = '1' then
                cur_addr <= next_addr;
            end if;
        end if;

    end process;
    
    next_addr <= std_logic_vector(unsigned(cur_addr) + 4) when en = '1'
        else std_logic_vector(unsigned(cur_addr) + unsigned(imm)) when add_imm = '1'
        else imm(13 downto 0) & "00" when sel_imm = '1'
        else a(15 downto 2) & "00" when sel_a = '1'
        else cur_addr;
    

end synth;

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

        if reset_n = '0' then
            cur_addr <= (others => '0');

        elsif rising_edge (clk) then
            if en = '1' then
                cur_addr <= next_addr;
            end if;
        end if;

    end process;
    
    cur_addr <= std_logic_vector(unsigned(next_addr) + 4) when add_imm = '0'
        else std_logic_vector(unsigned(next_addr) + unsigned(imm) + 4);
    

end synth;

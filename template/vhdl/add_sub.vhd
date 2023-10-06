library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity add_sub is
    port(
        a        : in  std_logic_vector(31 downto 0);
        b        : in  std_logic_vector(31 downto 0);
        sub_mode : in  std_logic;
        carry    : out std_logic;
        zero     : out std_logic;
        r        : out std_logic_vector(31 downto 0)
    );
end add_sub;

architecture synth of add_sub is

    signal s_b : std_logic_vector(31 downto 0);
    signal s_r : std_logic_vector(32 downto 0);
    signal s_sub : std_logic_vector(31 downto 0);
    signal s_subm : std_logic_vector(32 downto 0);

begin

    s_sub <= (others => sub_mode);
    s_subm(32 downto 1) <= (others => '0');
    s_subm(0) <= sub_mode;
    s_b <= b xor s_sub;
    s_r <= std_logic_vector(resize(unsigned(a), 33) + resize(unsigned(s_b), 33) + unsigned(s_subm));
    carry <= s_r(32);
    zero  <= '1' when s_r(31 downto 0) = "00000000000000000000000000000000" else '0';
    r <= s_r(31 downto 0);

end synth;
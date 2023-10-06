library ieee;
use ieee.std_logic_1164.all;

entity ROM is
    port(
        clk     : in  std_logic;
        cs      : in  std_logic;
        read    : in  std_logic;
        address : in  std_logic_vector(9 downto 0);
        rddata  : out std_logic_vector(31 downto 0)
    );
end ROM;



architecture synth of ROM is

    component ROM_Block is
        port(
            address		: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
            clock		: IN STD_LOGIC  := '1';
            q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
        );
    end component;

    signal s_q : std_logic_vector(31 downto 0);
    signal s_address : std_logic_vector(9 downto 0);

begin

    
    rom_b : ROM_Block 
    port map(
        address => s_address,
        clock   => clk,
        q   => s_q
    );

    process(clk, cs, read, address)
    begin 
    if rising_edge(clk) then
        if cs = '1' then
            rddata <= s_q;
            if read = '1' then
                s_address <= address;
            end if;
        else 
            rddata <= (others => 'Z');
        end if;
    end if;
    end process;


end synth;

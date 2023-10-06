library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder is
    port(
        address : in  std_logic_vector(15 downto 0);
        cs_LEDS : out std_logic;
        cs_RAM  : out std_logic;
        cs_ROM  : out std_logic
    );
end decoder;



architecture synth of decoder is

    signal s_address : integer range 0 to 65535;

begin
    
    s_address <= to_integer(unsigned(address));

    cs_ROM  <= '1' when s_address <= 16#0FFC# else '0';
    cs_RAM  <= '1' when (s_address >= 16#1000#) and (s_address <= 16#1FFC#) else '0';
    cs_LEDS <= '1' when (s_address >= 16#2000#) and (s_address <= 16#200C#) else '0';
    
end synth;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- Definición de la entidad rom_128x8_sync
entity rom_128x8_sync is
   port (
      clock : in std_logic;                          -- Señal de reloj
      address: in std_logic_vector(7 downto 0);      -- Dirección de memoria
      SalidaROM: out std_logic_vector(7 downto 0)    -- Datos de salida de la ROM
   );
end rom_128x8_sync;

-- Arquitectura de la entidad rom_128x8_sync
architecture arch_rom of rom_128x8_sync is

   -- Definición de constantes de instrucciones
   constant LDA_IMM : std_logic_vector (7 downto 0) := x"86";
   constant LDA_DIR : std_logic_vector (7 downto 0) := x"87";
   constant LDB_IMM : std_logic_vector (7 downto 0) := x"88";
   constant LDB_DIR : std_logic_vector (7 downto 0) := x"89";
   constant STA_DIR : std_logic_vector (7 downto 0) := x"96";
   constant STB_DIR : std_logic_vector (7 downto 0) := x"97";
   constant ADD_AB  : std_logic_vector (7 downto 0) := x"42";
   constant SUB_AB  : std_logic_vector (7 downto 0) := x"43";
   constant AND_AB  : std_logic_vector (7 downto 0) := x"44";
   constant OR_AB   : std_logic_vector (7 downto 0) := x"45";
   constant INCA    : std_logic_vector (7 downto 0) := x"46";
   constant INCB    : std_logic_vector (7 downto 0) := x"47";
   constant DECA    : std_logic_vector (7 downto 0) := x"48";
   constant DECB    : std_logic_vector (7 downto 0) := x"49";
   constant BRA     : std_logic_vector (7 downto 0) := x"20";
   constant BMI     : std_logic_vector (7 downto 0) := x"21";
   constant BPL     : std_logic_vector (7 downto 0) := x"22";
   constant BEQ     : std_logic_vector (7 downto 0) := x"23";
   constant BNE     : std_logic_vector (7 downto 0) := x"24";
   constant BVS     : std_logic_vector (7 downto 0) := x"25";
   constant BVC     : std_logic_vector (7 downto 0) := x"26";
   constant BCS     : std_logic_vector (7 downto 0) := x"27";
   constant BCC     : std_logic_vector (7 downto 0) := x"28";

   -- Definición del tipo de datos ROM y la señal de habilitación
   type ROM_type is array (0 to 255) of std_logic_vector(7 downto 0);
   signal EN : std_logic;

   -- Inicialización de la memoria ROM
   constant ROM : ROM_type := (
      0 => LDA_IMM,
      1 => x"AA",
      2 => STA_DIR,
      3 => x"E0",
      4 => BRA,
      5 => x"00",
      others => x"00"
   );

begin

   -- Proceso para habilitar la ROM según la dirección
   enable : process (address)
   begin
      if ((to_integer(unsigned(address)) >= 0) and
          (to_integer(unsigned(address)) <= 127)) then
         EN <= '1';
      else
         EN <= '0';
      end if;
   end process;

   -- Proceso para leer datos de la ROM en cada ciclo de reloj
   memory : process (clock)
   begin
      if (clock'event and clock = '1') then
         if (EN = '1') then
            SalidaROM <= ROM(to_integer(unsigned(address)));
         end if;
      end if;
   end process;

end arch_rom;

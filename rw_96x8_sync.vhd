library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

-- Definición de la entidad rw_96x8_sync
entity rw_96x8_sync is
   port (
      clock : in std_logic;                          -- Señal de reloj
      address: in std_logic_vector(7 downto 0);      -- Dirección de memoria
      data_in : in std_logic_vector(7 downto 0);     -- Datos de entrada a la RAM
      writen : in std_logic;                         -- Señal de escritura
      SalidaRam: out std_logic_vector(7 downto 0)    -- Datos de salida de la RAM
   );
end rw_96x8_sync;

-- Arquitectura de la entidad rw_96x8_sync
architecture arch_rw_96x8_sync of rw_96x8_sync is

   -- Definición del tipo de datos RAM y la señal de habilitación
   type rw_type is array (128 to 223) of std_logic_vector(7 downto 0);
   signal RW : rw_type;       -- Señal que representa la RAM
   signal EN : std_logic;     -- Señal de habilitación

begin

   -- Proceso para habilitar la RAM según la dirección
   enable : process (address)
   begin
      if ( (to_integer(unsigned(address)) >= 128) and
           (to_integer(unsigned(address)) <= 223)) then
         EN <= '1';
      else
         EN <= '0';
      end if;
   end process;
   
   -- Proceso para leer y escribir datos en la RAM en cada ciclo de reloj
   memory : process (clock)
   begin
      if (clock'event and clock = '1') then
         if (EN = '1' and writen = '1') then
            RW(to_integer(unsigned(address))) <= data_in;  -- Escribir en la RAM
         elsif (EN = '1' and writen = '0') then
            SalidaRam <= RW(to_integer(unsigned(address))); -- Leer de la RAM
         end if;
      end if;
   end process;

end arch_rw_96x8_sync;

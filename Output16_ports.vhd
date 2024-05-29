library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- Definición de la entidad Output16_ports
entity Output16_ports is
   port (
      clock : in std_logic;                          -- Señal de reloj
      address: in std_logic_vector(7 downto 0);      -- Dirección de memoria
      data_in : in std_logic_vector(7 downto 0);     -- Datos de entrada
      reset : in std_logic;                          -- Señal de reinicio
      writen : in std_logic;                         -- Señal de escritura
      port_out_00, port_out_01 : out std_logic_vector(7 downto 0) -- Puertos de salida
   );
end Output16_ports;

-- Arquitectura de la entidad Output16_ports
architecture arch_output_ports of Output16_ports is 

begin

   -- Proceso para manejar el puerto de salida 00
   U3 : process (clock, reset)
   begin
      if (reset = '0') then
         port_out_00 <= x"00";  -- Reiniciar puerto de salida 00 a 0
      elsif (clock'event and clock = '1') then
         if (address = x"E0" and writen = '1') then
            port_out_00 <= data_in;  -- Escribir datos en puerto de salida 00
         end if;
      end if;
   end process;

   -- Proceso para manejar el puerto de salida 01
   U4 : process (clock, reset)
   begin
      if (reset = '0') then
         port_out_01 <= x"00";  -- Reiniciar puerto de salida 01 a 0
      elsif (clock'event and clock = '1') then
         if (address = x"E1" and writen = '1') then
            port_out_01 <= data_in;  -- Escribir datos en puerto de salida 01
         end if;
      end if;
   end process;

end arch_output_ports;

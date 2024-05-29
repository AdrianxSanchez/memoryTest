library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

-- Definición de la entidad multiplexor
entity multiplexor is
   port (
      address : in std_logic_vector(7 downto 0);        -- Dirección de memoria
      rom_data_out : in std_logic_vector(7 downto 0);   -- Datos de salida de la ROM
      rw_data_out : in std_logic_vector(7 downto 0);    -- Datos de salida de la RAM
      port_in_00 : in std_logic_vector(7 downto 0);     -- Entrada del puerto 00
      port_in_01 : in std_logic_vector(7 downto 0);     -- Entrada del puerto 01
      data_out : out std_logic_vector(7 downto 0)       -- Datos de salida del multiplexor
   );
end multiplexor;

-- Arquitectura de la entidad multiplexor
architecture arch_multiplexor of multiplexor is

begin 

   -- Proceso para seleccionar la salida de datos según la dirección
   MUX1 : process (address, rom_data_out, rw_data_out, port_in_00, port_in_01)
   begin
      if ((to_integer(unsigned(address)) >= 0) and
          (to_integer(unsigned(address)) <= 127)) then
         data_out <= rom_data_out;  -- Seleccionar datos de la ROM
      elsif ((to_integer(unsigned(address)) >= 128) and
             (to_integer(unsigned(address)) <= 223)) then
         data_out <= rw_data_out;   -- Seleccionar datos de la RAM
      elsif (address = x"F0") then 
         data_out <= port_in_00;    -- Seleccionar datos del puerto 00
      elsif (address = x"F1") then 
         data_out <= port_in_01;    -- Seleccionar datos del puerto 01
      else 
         data_out <= x"00";         -- Valor por defecto
      end if;
   end process;

end arch_multiplexor;

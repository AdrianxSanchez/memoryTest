library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- Definición de la entidad memory
entity memory is
   port (
      address : in std_logic_vector(7 downto 0); -- Dirección de memoria
      data_in : in std_logic_vector(7 downto 0); -- Datos de entrada a la memoria
      writen  : in std_logic;                    -- Señal de escritura
      port_in_00, port_in_01 : in std_logic_vector(7 downto 0); -- Puertos de entrada adicionales
      clock   : in std_logic;                    -- Señal de reloj
      reset   : in std_logic;                    -- Señal de reinicio
      data_out: out std_logic_vector(7 downto 0);-- Salida de datos de la memoria
      port_out_00, port_out_01: out std_logic_vector(7 downto 0) -- Puertos de salida adicionales
   );
end memory;

-- Arquitectura de la entidad memory
architecture arch_memory of memory is

   -- Componente de memoria ROM síncrona
   component rom_128x8_sync is
      port (
         clock : in std_logic;                      -- Señal de reloj
         address: in std_logic_vector(7 downto 0);  -- Dirección de la ROM
         SalidaROM: out std_logic_vector(7 downto 0) -- Datos de salida de la ROM
      );
   end component;

   -- Componente de memoria RAM síncrona
   component rw_96x8_sync is
      port (
         clock : in std_logic;                      -- Señal de reloj
         address: in std_logic_vector(7 downto 0);  -- Dirección de la RAM
         data_in : in std_logic_vector(7 downto 0); -- Datos de entrada a la RAM
         writen : in std_logic;                     -- Señal de escritura
         SalidaRam: out std_logic_vector(7 downto 0) -- Datos de salida de la RAM
      );
   end component;

   -- Componente de salidas de 16 puertos
   component Output16_ports is
      port (
         clock : in std_logic;                      -- Señal de reloj
         address: in std_logic_vector(7 downto 0);  -- Dirección
         data_in : in std_logic_vector(7 downto 0); -- Datos de entrada
         reset : in std_logic;                      -- Señal de reinicio
         writen : in std_logic;                     -- Señal de escritura
         port_out_00, port_out_01 : out std_logic_vector(7 downto 0) -- Puertos de salida
      );
   end component;

   -- Componente multiplexor
   component multiplexor is
      port (
         address : in std_logic_vector(7 downto 0); -- Dirección
         rom_data_out : in std_logic_vector(7 downto 0); -- Datos de salida de la ROM
         rw_data_out : in std_logic_vector(7 downto 0);  -- Datos de salida de la RAM
         port_in_00 : in std_logic_vector(7 downto 0);   -- Puerto de entrada 00
         port_in_01 : in std_logic_vector(7 downto 0);   -- Puerto de entrada 01
         data_out   : out std_logic_vector(7 downto 0)   -- Datos de salida
      );
   end component;

   -- Señales internas para los datos de salida de la ROM y la RAM
   signal data_out_rom, data_out_ram : std_logic_vector(7 downto 0);

begin 
   -- Instanciación del componente de ROM
   parte1 : rom_128x8_sync port map (
      clock => clock,
      address => address,
      salidaROM => data_out_rom
   );

   -- Instanciación del componente de RAM
   parte2 : rw_96x8_sync port map (
      clock => clock,
      address => address,
      data_in => data_in,
      writen => writen,
      salidaRam => data_out_ram
   );

   -- Instanciación del componente de salidas de 16 puertos
   parte3 : Output16_ports port map (
      clock => clock,
      address => address,
      data_in => data_in,
      reset => reset,
      writen => writen,
      port_out_00 => port_out_00,
      port_out_01 => port_out_01
   );

   -- Instanciación del componente multiplexor
   parte4 : multiplexor port map (
      address => address,
      rom_data_out => data_out_rom,
      rw_data_out => data_out_ram,
      port_in_00 => port_in_00,
      port_in_01 => port_in_01,
      data_out => data_out
   );

end arch_memory;

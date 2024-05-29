library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- Definición de la entidad memoryTest
entity memoryTest is
   port (
      address : in std_logic_vector(7 downto 0); -- Dirección de memoria
      data_in : in std_logic_vector(7 downto 0); -- Datos de entrada a la memoria
      writen  : in std_logic;                    -- Señal de escritura
      clock   : in std_logic;                    -- Señal de reloj
      reset   : in std_logic;                    -- Señal de reinicio
      port_in_00, port_in_01 : in std_logic_vector(7 downto 0); -- Puertos de entrada adicionales
      deco2, deco3, deco4, deco5 : out std_logic_vector(6 downto 0); -- Salidas para displays
      port_out_00 : out std_logic_vector(7 downto 0) -- Salida de datos de la memoria
   );
end memoryTest;

-- Arquitectura de la entidad memoryTest
architecture arch_memoryTest of memoryTest is 

   -- Componente de memoria
   component memory is
      port (
         address : in std_logic_vector(7 downto 0);
         data_in : in std_logic_vector(7 downto 0);
         writen  : in std_logic;
         port_in_00, port_in_01 : in std_logic_vector(7 downto 0);
         clock   : in std_logic;
         reset   : in std_logic;
         data_out: out std_logic_vector(7 downto 0);
         port_out_00, port_out_01: out std_logic_vector(7 downto 0)
      );
   end component;

   -- Componente de displays de 7 segmentos
   component Displays is
      port (
         abcd : in std_logic_vector(3 downto 0);
         salida: out std_logic_vector(6 downto 0)
      );
   end component;

   -- Señales internas
   signal direccion : std_logic_vector(7 downto 0);
   signal deco1direccion, deco2direccion, data_out1, data_out2 : std_logic_vector(3 downto 0);
   signal senal_data_out : std_logic_vector(7 downto 0);

begin
   -- Asignación de la dirección de entrada a una señal interna
   direccion <= address;

   -- Instanciación del componente de memoria
   parte1 : memory port map (
      address => direccion,
      data_in => data_in,
      writen => writen,
      port_in_00 => port_in_00,
      port_in_01 => port_in_01,
      clock => clock,
      reset => reset,
      data_out => senal_data_out,
      port_out_00 => port_out_00
   );

   -- Descomposición de la dirección para los displays
   deco1direccion <= direccion(7 downto 4);
   deco2direccion <= direccion(3 downto 0);

   -- Instanciación de los componentes displays para las partes de la dirección
   parte2 : displays port map (
      abcd => deco1direccion,
      salida => deco2
   );

   parte5 : displays port map (
      abcd => deco2direccion,
      salida => deco3
   );

   -- Descomposición de los datos de salida de la memoria para los displays
   data_out1 <= senal_data_out(7 downto 4);
   data_out2 <= senal_data_out(3 downto 0);

   -- Instanciación de los componentes displays para los datos de salida de la memoria
   parte6 : displays port map (
      abcd => data_out1,
      salida => deco4
   );

   parte7 : displays port map (
      abcd => data_out2,
      salida => deco5
   );

end arch_memoryTest;

with System;
with Light_sensor; pragma Unreferenced(Light_sensor);
with Ada.Text_IO;
use  Ada.Text_IO;

procedure Driver is
pragma Priority (System.Priority'First);
begin
  Light_sensor.Run;
  loop
    null;
  end loop;
end Driver;

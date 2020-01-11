with System;
with Light_sensor; pragma Unreferenced(Light_sensor);
with Ada.Text_IO;
use  Ada.Text_IO;

procedure Driver is
pragma Priority (System.Priority'First);
begin
    Light_sensor.Run;
	delay(8.0);
	Light_sensor.Remove_Sensor(7);
	delay(0.5);
	Light_sensor.Remove_Sensor(3);
	delay(0.5);
	Light_sensor.Remove_Sensor(7);
	delay(0.5);
	Light_sensor.Remove_Sensor(9);
	delay(5.0);
	Light_sensor.Add_Sensor;
end Driver;

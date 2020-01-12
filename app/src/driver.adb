with System;
with Light_sensor; pragma Unreferenced(Light_sensor);
with Ada.Text_IO;
use  Ada.Text_IO;

procedure Driver is
pragma Priority (System.Priority'First);
elem: Light_sensor.Movement_Sensor_Ptr;
begin
    Light_sensor.Run;
	delay(8.0);
	Light_sensor.Remove_Light_Sensor(7);
	delay(0.5);
	Light_sensor.Remove_Light_Sensor(3);
	delay(0.5);
	Light_sensor.Remove_Light_Sensor(7);
	delay(0.5);
	Light_sensor.Remove_Light_Sensor(9);
	delay(5.0);
	elem := Light_sensor.MSensors.Element(2);
	elem.Movement;
end Driver;

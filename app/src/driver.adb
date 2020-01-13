with System;
with Light_sensor; pragma Unreferenced(Light_sensor);
with Ada.Text_IO;
use  Ada.Text_IO;

procedure Driver is
pragma Priority (System.Priority'First);
elem1: Light_sensor.Movement_Sensor_Ptr;
elem2: Light_sensor.Switch_Sensor_Ptr;
begin
	Light_sensor.Run;
	delay(3.0);
	elem2 := Light_sensor.SSensors.Element(0);
	elem2.Change(2);
	--Light_sensor.Remove_Light_Sensor(7);
	--delay(0.5);
	--Light_sensor.Remove_Light_Sensor(3);
	--delay(0.5);
	--Light_sensor.Remove_Light_Sensor(7);
	--delay(0.5);
	--Light_sensor.Remove_Light_Sensor(9);
	--delay(5.0);
	elem1 := Light_sensor.MSensors.Element(2);
	elem1.Movement;
end Driver;

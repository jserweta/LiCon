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
	elem2 := Light_sensor.SSensors.Element(0);
	elem1 := Light_sensor.MSensors.Element(2);
	delay(3.0);
	elem2.Change(2);
	delay(1.0);
	elem1.Movement;
	delay(2.0);
	elem2.Change(0);
	delay(6.0);
	elem2.Change(1);
	delay(2.0);
	elem1.Movement;
	--delay(2.3);
	--elem2.Change(0);
	--delay(2.3);
	--elem2.Change(1);
	--
	--elem1.Movement;
end Driver;

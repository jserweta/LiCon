with Ada.Containers.Vectors;

package Light_Sensor is

subtype light_range is Float range 0.0..100.0;

type Light_Sensor_Data is
	record 
	    Id : Natural;
  		Light_Level: light_range := 0.0;
  	end record; 
 
type LSD_Ptr is access all Light_Sensor_Data;

type Movement_Sensor_Data is
	record 
	    Id : Natural;
  		Movement: boolean;
  	end record; 

type MSD_Ptr is access all Movement_Sensor_Data;

task type Light_Sensor (Id : Natural) is
	entry Stop;
end Light_Sensor;

task type Movement_Sensor (Id : Natural) is
	entry Stop;
	entry Movement;
end Movement_Sensor;

type Light_Sensor_Ptr is access Light_Sensor;
type Movement_Sensor_Ptr is access Movement_Sensor;

package Light_Vector is new Ada.Containers.Vectors
    (Index_Type => Natural, Element_Type => Light_Sensor_Ptr);
use Light_Vector;
LSensors: Light_Vector.Vector;

package Movement_Vector is new Ada.Containers.Vectors
    (Index_Type => Natural, Element_Type => Movement_Sensor_Ptr);
use Light_Vector;
MSensors: Movement_Vector.Vector;

package Id_Vector is new Ada.Containers.Vectors
    (Index_Type => Natural, Element_Type => Natural);
use Id_Vector;
Taken_L_Id: Id_Vector.Vector;
Taken_M_Id: Id_Vector.Vector;

package Solar_Power_Vector is new Ada.Containers.Vectors
    (Index_Type => Natural, Element_Type => light_range);
use Solar_Power_Vector;


task Serwer is 
  	entry Start;
  	entry Koniec;
  	entry LSD(data1:LSD_Ptr);
	entry MSD(data2:MSD_Ptr);
	entry Added_Light_Sensor;
	entry Deleted_Light_Sensor;
end Serwer;

procedure Add_Light_Sensor;

procedure Remove_Light_Sensor(Id: in Natural);

procedure Run;

end Light_Sensor;

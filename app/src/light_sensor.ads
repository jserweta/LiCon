with Ada.Containers.Vectors;
with Ada.Unchecked_Deallocation;

package Light_Sensor is

subtype light_range is Float range 0.0..100.0;

type Light_Sensor_Data is
	record 
	    Id : Natural;
  		Light_Level: light_range := 0.0;
  	end record; 
 
type LSD_Ptr is access all Light_Sensor_Data;

task type Light_Sensor (Id : Natural) is
	entry Stop;
end Light_Sensor;

type Light_Sensor_Ptr is access Light_Sensor;

package Light_Vector is new Ada.Containers.Vectors
    (Index_Type => Natural, Element_Type => Light_Sensor_Ptr);
use Light_Vector;
Sensors: Light_Vector.Vector;

package Id_Vector is new Ada.Containers.Vectors
    (Index_Type => Natural, Element_Type => Natural);
use Id_Vector;
Taken_Id: Id_Vector.Vector;

task Serwer is 
  	entry Start;
  	entry Koniec;
  	entry We(P:LSD_Ptr);
end Serwer;

procedure Add_Sensor;

procedure Remove_Sensor(Id: in Natural);

procedure Run;

end Light_Sensor;

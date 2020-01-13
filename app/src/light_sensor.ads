with Ada.Containers.Vectors;

package Light_Sensor is

subtype light_range is Float range 0.0..100.0;
subtype switch_range is Integer range 0..2;

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

type Switch_Sensor_Data is
	record 
	    Id : Natural;
  		position: switch_range;
  	end record; 

type SSD_Ptr is access all Switch_Sensor_Data;

task type Light_Sensor (Id : Natural) is
	entry Stop;
end Light_Sensor;

task type Movement_Sensor (Id : Natural) is
	entry Stop;
	entry Movement;
end Movement_Sensor;

task type Switch_Sensor (Id : Natural) is
	entry Stop;
	entry Change(position:switch_range);
end Switch_Sensor;

task type Lamp (Id : Natural) is
	entry Stop;
	entry Get_Switch(position:switch_range);
	entry Get_Movement(move:boolean);
	entry Get_Light(light_level : light_range);
	entry End_Of_Movement;
end Lamp;

task type Lamp_Bufor (Id : Natural) is
	entry Stop;
	entry Send(move:boolean);
end Lamp_Bufor;

type Light_Sensor_Ptr is access Light_Sensor;
type Movement_Sensor_Ptr is access Movement_Sensor;
type Switch_Sensor_Ptr is access Switch_Sensor;
type Lamp_Ptr is access Lamp;
type Lamp_Bufor_Ptr is access Lamp_Bufor;

package Light_Vector is new Ada.Containers.Vectors
    (Index_Type => Natural, Element_Type => Light_Sensor_Ptr);
use Light_Vector;
LSensors: Light_Vector.Vector;

package Movement_Vector is new Ada.Containers.Vectors
    (Index_Type => Natural, Element_Type => Movement_Sensor_Ptr);
use Light_Vector;
MSensors: Movement_Vector.Vector;

package Switch_Vector is new Ada.Containers.Vectors
    (Index_Type => Natural, Element_Type => Switch_Sensor_Ptr);
use Light_Vector;
SSensors: Switch_Vector.Vector;

package Solar_Power_Vector is new Ada.Containers.Vectors
    (Index_Type => Natural, Element_Type => light_range);
use Solar_Power_Vector;


package Lamp_Vector is new Ada.Containers.Vectors
    (Index_Type => Natural, Element_Type => Lamp_Ptr);
use Lamp_Vector;
ASensors: Lamp_Vector.Vector;

package LB_Vector is new Ada.Containers.Vectors
    (Index_Type => Natural, Element_Type => Lamp_Bufor_Ptr);
use LB_Vector;
LBSensors: LB_Vector.Vector;

package Id_Vector is new Ada.Containers.Vectors
    (Index_Type => Natural, Element_Type => Natural);
use Id_Vector;
Taken_L_Id: Id_Vector.Vector;
Taken_M_Id: Id_Vector.Vector;
Taken_S_Id: Id_Vector.Vector;



task Serwer is 
  	entry Start;
  	entry Koniec;
  	entry LSD(data1:LSD_Ptr);
	entry MSD(data2:MSD_Ptr);	
	entry SSD(data3:SSD_Ptr);
	entry Added_Light_Sensor;
	entry Deleted_Light_Sensor;
end Serwer;

procedure Add_Light_Sensor;

procedure Remove_Light_Sensor(Id: in Natural);

procedure Run;

end Light_Sensor;

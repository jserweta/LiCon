with Ada.Text_IO, Ada.Numerics.Float_Random, Ada.Numerics.Elementary_Functions;
use Ada.Text_IO, Ada.Numerics.Float_Random;
with Ada.Containers.Vectors;


package body Light_sensor is
		
work : Boolean:= False;

task body Light_Sensor is
Light_Level : light_range;
Gen: Generator;
P : LSD_Ptr;
Working : Boolean;
counter : Integer := 0;
frequency: Natural := 50;
begin
  loop
	select
		accept Stop;
		exit;
	else
		counter := counter + 1;
		if counter = frequency then
			counter := 0;
			Light_Level := Random(Gen) * 100.0;
			P := new Light_Sensor_Data;
    		P.Id := Id;
    		P.Light_Level := Light_Level;
    		Serwer.LSD(P);
    		Working := True;
		end if;
		delay(0.1);
		end select;
  end loop;
end Light_Sensor;

task body Serwer is
light_mean : Float := 0.0;
solar_power: Solar_Power_Vector.Vector;
light_sensor_amount : Integer := 0;
counter: integer := 0;
begin
  accept Start;
  loop
    select 
      accept LSD(data: in LSD_Ptr) do
	    solar_power.Append(data.Light_Level);
		Put_Line("wyslano: " & data.Light_Level'Img);
      end LSD;
		While_Loop:
		while Integer(solar_power.length) > light_sensor_amount loop
			solar_power.Delete_First;
		end loop While_Loop;
		for e in solar_power.Iterate loop
			light_mean := light_mean + element(e);
		end loop;
		light_mean := light_mean/Float(light_sensor_amount);
		--here will be sending result to lights
    or 
	    accept Added_Light_Sensor;
			light_sensor_amount := light_sensor_amount + 1;
	or
		accept Deleted_Light_Sensor; 
			light_sensor_amount := light_sensor_amount - 1;
	or
	   accept Koniec;
 	   exit;
    end select;
  end loop;
  
  Put_Line("Koniec Serwer ");
end Serwer;

   
procedure Add_Light_Sensor is
 	Id: Natural;
	klik: Light_Sensor_Ptr;
	begin
	Id := 1;
		loop
        if not Taken_Id.Contains(Id) then
            klik := new Light_Sensor(Id);
			Taken_Id.Append(Id);
            Sensors.Append(klik);
			Serwer.Added_Light_Sensor;
            exit;
        else  
            Id := Id + 1;  
        end if;
    	end loop;
end Add_Light_Sensor;

procedure Remove_Light_Sensor(Id: in Natural) is
	klik: Light_Sensor_Ptr;
	E: Integer;
	begin
	if Taken_Id.Contains(Id) then
		E := Taken_Id.Find_Index(Id);
		Put_Line("Now deleting" & Id'Img);
		klik := Sensors(E);
		Taken_Id.Delete(E,1);
		Sensors.Delete(E,1);
		klik.Stop;
		Serwer.Deleted_Light_Sensor;
	end if;
end Remove_Light_Sensor;

procedure Run is
begin
    Serwer.Start;
    for I in Integer range 1 .. 10 loop
		Add_Light_Sensor;
    end loop; 
    Put_Line("Koniec_PG "); 

end Run;
end Light_sensor;
	  	

-- spotkania2.adb

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
begin
  loop
	select
		accept Stop;
		exit;
	else
		Light_Level := Random(Gen) * 100.0;
		P := new Light_Sensor_Data;
    	P.Id := Id;
    	P.Light_Level := Light_Level;
    	Serwer.We(P);
    	Working := True;
		delay(5.0);
		end select;
  end loop;
end Light_Sensor;

task body Serwer is
  Lok, Pvs: LSD_Ptr; 
  dist : Float;
	counter: Integer := 0;
begin
  accept Start;
  loop
    select 
     accept We(P: in LSD_Ptr) do
	     Lok := P;
     end We;
	    --Put_Line("A=" & Lok.A'Img & " B=" & Lok.B'Img);
		--dist := Ada.Numerics.Elementary_Functions.Sqrt(Lok.A**2+Lok.B**2);
	    --Put_Line("Distance from 0.0: " & dist'Img);
		if Lok /= Null then 
			--dist := Ada.Numerics.Elementary_Functions.Sqrt((Lok.A-Pvs.A)**2+(Lok.B-Pvs.B)**2);
			Put_Line("Distance from previous point: " & Lok.Id'Img);
			counter := counter + 1;
		end if;
		if counter = 10 then 
			Put_Line("Ten: " & Lok.Id'Img);
			counter := 0;
		end if;
    or 
	   accept Koniec;
 	   exit;
    end select;
  end loop;
  
  Put_Line("Koniec Serwer ");
end Serwer;

   
procedure Add_Sensor is
 	Id: Natural;
	klik: Light_Sensor_Ptr;
	begin
	Id := 1;
		loop
        if not Taken_Id.Contains(Id) then
            klik := new Light_Sensor(Id);
			Taken_Id.Append(Id);
            Sensors.Append(klik);
            exit;
        else  
            Id := Id + 1;  
        end if;
		Put_Line(Id'Img);
    	end loop;
end Add_Sensor;

procedure Remove_Sensor(Id: in Natural) is
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
	end if;
end Remove_Sensor;

procedure Run is
begin
    Serwer.Start;
    for I in Integer range 1 .. 10 loop
		Add_Sensor;
    end loop; 
    Put_Line("Koniec_PG "); 

end Run;
end Light_sensor;
	  	

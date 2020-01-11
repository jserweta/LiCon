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
	Light_Level := Random(Gen) * 100.0;
	P := new Light_Sensor_Data;
    P.Id := Id;
    P.Light_Level := Light_Level;
    Serwer.We(P);
    Working := True;
	delay(10.0);
  end loop;
end Light_Sensor;

task body Serwer is
  Lok, Pvs: LSD_Ptr; 
  dist : Float;
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
		end if;
    or 
	   accept Koniec;
 	   exit;
    end select;
  end loop;
  
  Put_Line("Koniec Serwer ");
end Serwer;

   
procedure Add_Sensor(A: in out Light_Vector.Vector; B: in out Id_Vector.Vector) is
 	Id: Natural;
	klik: Light_Sensor_Ptr;
	begin
	Id := 1;
		loop
        if not Taken_Id.Contains(Id) then
            klik := new Light_Sensor(Id);
			B.Append(Id);
            A.Append(klik);
            exit;
        else  
            Id := Id + 1;  
        end if;
		Put_Line(Id'Img);
    	end loop;
end Add_Sensor;

procedure Run is

begin
    Serwer.Start;
    for I in Integer range 1 .. 10 loop
		Add_Sensor(Sensors, Taken_Id);
    end loop; 
    Put_Line("Koniec_PG "); 

end Run;
end Light_sensor;
	  	

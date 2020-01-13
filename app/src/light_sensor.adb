with Ada.Text_IO, Ada.Numerics.Float_Random, Ada.Numerics.Elementary_Functions;
use Ada.Text_IO, Ada.Numerics.Float_Random;
with Ada.Containers.Vectors;


package body Light_sensor is
		
work : Boolean:= False;

task body Light_Sensor is
Light_Level : light_range;
Gen: Generator;
P : LSD_Ptr;
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
		end if;
		delay(0.1);
		end select;
  end loop;
end Light_Sensor;


task body Movement_Sensor is
P : MSD_Ptr;
begin
  loop
	select
		accept Stop;
		exit;
	or
		accept Movement;
		P := new Movement_Sensor_Data;
    	P.Id := Id;
		P.Movement := true;
    	Serwer.MSD(P);
	end select;
  end loop;
end Movement_Sensor;

task body Switch_Sensor is
P : SSD_Ptr;
begin
  loop
	select
		accept Stop;
		exit;
	or
		accept Change(position: in switch_range) do
			P := new Switch_Sensor_Data;
    		P.Id := Id;
			P.position := position;
    		Serwer.SSD(P);
		end Change;
	end select;
  end loop;
end Switch_Sensor;

task body Serwer is
light_mean : Float := 0.0;
solar_power: Solar_Power_Vector.Vector;
light_sensor_amount : Integer := 0;
mode: switch_range := 1;
begin
  accept Start;
  loop
    select 
      accept LSD(data1: in LSD_Ptr) do
	    solar_power.Append(data1.Light_Level);
		--Put_Line("wyslano: " & data1.Light_Level'Img);
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
		accept MSD(data2: in MSD_Ptr) do
			--Put_Line("wyslano: " & light_mean'Img);
			--Put_Line("wyslano: " & data2.Id'Img);
			if light_mean < 30.0 and mode = 1 then 
				Put_Line("received movement: " & data2.id'Img);
				--here will be sending result to lights
			end if;
		end MSD;
	or
		accept SSD(data3: in SSD_Ptr) do
			Put_Line("wyslano: " & data3.Id'Img);
			Put_Line("wyslano: " & data3.position'Img);
			mode := data3.position;
			--here will be sending result to lights 
		end SSD;
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
        if not Taken_L_Id.Contains(Id) then
            klik := new Light_Sensor(Id);
			Taken_L_Id.Append(Id);
            LSensors.Append(klik);
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
	if Taken_L_Id.Contains(Id) then
		E := Taken_L_Id.Find_Index(Id);
		Put_Line("Now deleting" & Id'Img);
		klik := LSensors(E);
		Taken_L_Id.Delete(E,1);
		LSensors.Delete(E,1);
		klik.Stop;
		Serwer.Deleted_Light_Sensor;
	end if;
end Remove_Light_Sensor;

procedure Add_Movement_Sensor is
 	Id: Natural;
	klik: Movement_Sensor_Ptr;
	begin
	Id := 1;
		loop
        if not Taken_M_Id.Contains(Id) then
            klik := new Movement_Sensor(Id);
			Taken_M_Id.Append(Id);
            MSensors.Append(klik);
            exit;
        else  
            Id := Id + 1;  
        end if;
    	end loop;
end Add_Movement_Sensor;

procedure Remove_Movement_Sensor(Id: in Natural) is
	klik: Movement_Sensor_Ptr;
	E: Integer;
	begin
	if Taken_M_Id.Contains(Id) then
		E := Taken_M_Id.Find_Index(Id);
		Put_Line("Now deleting" & Id'Img);
		klik := MSensors(E);
		Taken_M_Id.Delete(E,1);
		MSensors.Delete(E,1);
		klik.Stop;
	end if;
end Remove_Movement_Sensor;

procedure Add_Switch_Sensor is
 	Id: Natural;
	klik: Switch_Sensor_Ptr;
	begin
	Id := 1;
		loop
        if not Taken_S_Id.Contains(Id) then
            klik := new Switch_Sensor(Id);
			Taken_S_Id.Append(Id);
            SSensors.Append(klik);
            exit;
        else  
            Id := Id + 1;  
        end if;
    	end loop;
end Add_Switch_Sensor;

procedure Remove_Switch_Sensor(Id: in Natural) is
	klik: Switch_Sensor_Ptr;
	E: Integer;
	begin
	if Taken_S_Id.Contains(Id) then
		E := Taken_S_Id.Find_Index(Id);
		Put_Line("Now deleting" & Id'Img);
		klik := SSensors(E);
		Taken_S_Id.Delete(E,1);
		SSensors.Delete(E,1);
		klik.Stop;
	end if;
end Remove_Switch_Sensor;

procedure Run is
begin
    Serwer.Start;
    for I in Integer range 1 .. 10 loop
		Add_Light_Sensor;
    end loop; 
	for I in Integer range 1 .. 10 loop
		Add_Movement_Sensor;
    end loop; 
	Add_Switch_Sensor;
    Put_Line("Koniec_PG "); 

end Run;
end Light_sensor;
	  	

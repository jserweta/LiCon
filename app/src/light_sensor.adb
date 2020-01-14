with Ada.Text_IO, Ada.Numerics.Float_Random, Ada.Numerics.Elementary_Functions;
use Ada.Text_IO, Ada.Numerics.Float_Random;
with Ada.Containers.Vectors;
with Panel; pragma Unreferenced(Panel);

package body Light_sensor is		

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
		delay(0.1);
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
			P.position := position;
		end Change;
    	P.Id := Id;
    	Serwer.SSD(P);
		delay(0.1);
	end select;
  end loop;
end Switch_Sensor;

task body Lamp is
mode: switch_range := 1;
light_intensity: light_range := 0.0;
light_sensor_intensity: light_range := 0.0;
movement: boolean := false;
begin 
  loop
	select
		accept Stop;
		exit;
	or 
		accept Get_Switch(position : in switch_range) do
			mode := position;
		end Get_Switch;
		if mode = 0 then 
			light_intensity := 0.0;
		elsif mode = 1 and movement = true then 
			light_intensity := 100.0;
		elsif mode = 1 then
			light_intensity := light_sensor_intensity;
		elsif mode = 2 then
			light_intensity := 100.0;
		end if;
		Panel.Update(Id, light_intensity);
	or 
		accept Get_Movement(move: in boolean);
			movement := true;
			if mode = 1 then
				light_intensity := 100.0;
			end if;
			Panel.Update(Id, light_intensity);
	or 
		accept End_Of_Movement;
			movement := false;
			if mode = 0 then 
				light_intensity := 0.0;
			elsif mode = 1 then 
				light_intensity := light_sensor_intensity;
			elsif mode = 2 then
				light_intensity := 100.0;
			end if;
			Panel.Update(Id, light_intensity);
	or 
		accept Get_Light(light_level : light_range) do
			light_sensor_intensity := light_level;
		end Get_Light;
		if mode = 1 and movement = false then
			light_intensity := light_sensor_intensity;
		elsif mode = 1 and movement = true and light_sensor_intensity > 0.0 then 
			light_intensity := 100.0;
		end if;
		Panel.Update(Id, light_intensity);
	end select;
  end loop;
end Lamp;
	
task body Lamp_Bufor is 
klik : Lamp_Ptr;
begin 
  loop
	select
		accept Stop;
		exit;
	or
		accept send(move: in boolean);
	or 
		delay(20.0);
		klik := ASensors(Id - 1);
		klik.End_Of_Movement;
	end select;
  end loop;
end Lamp_Bufor;
	

task body Serwer is
light_mean : Float := 0.0;
solar_power: Solar_Power_Vector.Vector;
light_sensor_amount : Integer := 0;
mode: switch_range := 1;
light_level : light_range := 0.0;
E: Integer;
begin
  accept Start;
  loop
    select 
      accept LSD(data1: in LSD_Ptr) do
	    solar_power.Append(data1.Light_Level);
      end LSD;
		While_Loop:
		while Integer(solar_power.length) > light_sensor_amount loop
			solar_power.Delete_First;
		end loop While_Loop;
		for e in solar_power.Iterate loop
			light_mean := light_mean + element(e);
		end loop;
		light_mean := light_mean/Float(light_sensor_amount);
		if light_mean > 30.0 then 
			light_level := 0.0;
		else
			light_level := 10.0 + 30.0 - light_mean;
		end if;
		for e in ASensors.Iterate loop
			Element(e).Get_Light(light_level);
		end loop;
    or 
		accept MSD(data2: in MSD_Ptr) do
			E := Taken_M_Id.Find_Index(data2.Id);
		end MSD;
		ASensors(E).Get_Movement(true);
		LBSensors(E).Send(True);
	or
		accept SSD(data3: in SSD_Ptr) do
			mode := data3.position; 
		end SSD;
		for e in ASensors.Iterate loop
			element(e).Get_Switch(mode);
		end loop;
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

procedure Add_Lamp is
 	Id: Natural;
	klik: Movement_Sensor_Ptr;
	klik2: Lamp_Ptr;
	klik3: Lamp_Bufor_Ptr;
	begin
	Id := 1;
		loop
        if not Taken_M_Id.Contains(Id) then	
			Taken_M_Id.Append(Id);
            klik := new Movement_Sensor(Id);
			klik2 := new Lamp(Id);
			klik3 := new Lamp_Bufor(Id);
            MSensors.Append(klik);
			ASensors.Append(klik2);
			LBSensors.Append(klik3);
            exit;
        else  
            Id := Id + 1;  
        end if;
    	end loop;
end Add_Lamp;

procedure Remove_Lamp(Id: in Natural) is
	klik: Movement_Sensor_Ptr;
	klik2: Lamp_Ptr;
	klik3: Lamp_Bufor_Ptr;
	E: Integer;
	begin
	if Taken_M_Id.Contains(Id) then
		E := Taken_M_Id.Find_Index(Id);
		Put_Line("Now deleting" & Id'Img);
		klik := MSensors(E);
		klik2 := ASensors(E);
		klik3 := LBSensors(E);
		Taken_M_Id.Delete(E,1);
		MSensors.Delete(E,1);
		ASensors.Delete(E,1);
		LBSensors.Delete(E,1);
		klik.Stop;
		klik2.Stop;
		klik3.Stop;
	end if;
end Remove_Lamp;

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

task body Panel_Thread is
	begin
	accept Start;
	Panel.Run;
end Panel_Thread;

procedure Run is
begin
	Panel_Thread.Start;
    Serwer.Start;
    for I in Integer range 1 .. 4 loop
		Add_Light_Sensor;
    end loop; 
	for I in Integer range 1 .. 10 loop
		Add_Lamp;
    end loop; 
	Add_Switch_Sensor;
end Run;
end Light_sensor;
	  	

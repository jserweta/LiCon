-- spotkania2.adb

with Ada.Text_IO, Ada.Numerics.Float_Random, Ada.Numerics.Elementary_Functions;
use Ada.Text_IO, Ada.Numerics.Float_Random;
with Ada.Containers.Vectors;


procedure Light_sensor is
	
type Point is
	record 
	    A : Float := 0.0;
  		B : float := 0.0;
  	end record; 
 
type Point_Ptr is access all Point;

task type Klient is
    entry Init(Id_in : in Natural);
    entry Is_Alive(Working: out Boolean);
end Klient;
type K_Ptr is access Klient;

task Serwer is 
  	entry Start;
  	entry Koniec;
  	entry We(P:Point_Ptr);
end Serwer;

task body Klient is
A,B : Float;
Gen: Generator;
P : Point_Ptr;
Working : Boolean;
Id : Natural := 0;
begin
  loop
    accept Init(Id_in : in Natural) do
		Id := Id_in;
	end Init;
    accept Is_Alive(Working: out Boolean) do
        A := Random(Gen);
	    B := Random(Gen);
	    P := new Point;
	    P.A := A;
	    P.B := B;
	    Serwer.We(P);
        Working := True;
		Put_Line(Id'Img);
    end Is_Alive;

  end loop;
end Klient;

task body Serwer is
  Lok, Pvs: Point_Ptr; 
  dist : Float;
begin
  accept Start;
  loop
    select 
     accept We(P: in Point_Ptr) do
		 Pvs := Lok;
	     Lok := P;
     end We;
	    --Put_Line("A=" & Lok.A'Img & " B=" & Lok.B'Img);
		dist := Ada.Numerics.Elementary_Functions.Sqrt(Lok.A**2+Lok.B**2);
	    --Put_Line("Distance from 0.0: " & dist'Img);
		if Pvs /= Null then 
			dist := Ada.Numerics.Elementary_Functions.Sqrt((Lok.A-Pvs.A)**2+(Lok.B-Pvs.B)**2);
			--Put_Line("Distance from previous point: " & dist'Img);
		end if;
    or 
	   accept Koniec;
 	   exit;
    end select;
  end loop;
  
  Put_Line("Koniec Serwer ");
end Serwer;

package Light_Vector is new Ada.Containers.Vectors
    (Index_Type => Natural, Element_Type => K_Ptr);
use Light_Vector;
Sensors: Light_Vector.Vector;

package Id_Vector is new Ada.Containers.Vectors
    (Index_Type => Natural, Element_Type => Natural);
use Id_Vector;
Taken_Id: Id_Vector.Vector;

work : Boolean:= False;

   
procedure Add_Sensor(A: in out Light_Vector.Vector; B: in out Id_Vector.Vector) is
 	Id: Natural;
	klik: K_Ptr;
	begin
	Id := 1;
		loop
        if not Taken_Id.Contains(Id) then
            klik := new Klient;
            klik.Init(Id);
			B.Append(Id);
            A.Append(klik);
            exit;
        else  
            Id := Id + 1;  
        end if;
		Put_Line(Id'Img);
    	end loop;
end Add_Sensor;

begin
    Serwer.Start;
    for I in Integer range 1 .. 10 loop
		Add_Sensor(Sensors, Taken_Id);
    end loop; 
    loop
        for P of Sensors loop
            P.Is_Alive(work);
            Put_Line("Working: " & work'Img);
            work := False;
        end loop;
    end loop;
    Put_Line("Koniec_PG "); 
end Light_sensor;
	  	

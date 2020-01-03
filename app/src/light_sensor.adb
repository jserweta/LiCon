-- spotkania2.adb

with Ada.Text_IO, Ada.Numerics.Float_Random, Ada.Numerics.Elementary_Functions;
use Ada.Text_IO, Ada.Numerics.Float_Random;


procedure Light_sensor is
	
type Point is
	record 
	    A : Float := 0.0;
  		B : float := 0.0;
  	end record; 
 
type Point_Ptr is access all Point;

task type Klient;
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
begin
  loop
	A := Random(Gen);
	B := Random(Gen);
	P := new Point;
	P.A := A;
	P.B := B;
	Serwer.We(P);
    delay(0.5);
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
	    Put_Line("A=" & Lok.A'Img & " B=" & Lok.B'Img);
		dist := Ada.Numerics.Elementary_Functions.Sqrt(Lok.A**2+Lok.B**2);
	    Put_Line("Distance from 0.0: " & dist'Img);
		if Pvs /= Null then 
			dist := Ada.Numerics.Elementary_Functions.Sqrt((Lok.A-Pvs.A)**2+(Lok.B-Pvs.B)**2);
			Put_Line("Distance from previous point: " & dist'Img);
		end if;
    or 
	   accept Koniec;
 	   exit;
    end select;
  end loop;
  
  Put_Line("Koniec Serwer ");
end Serwer;

type SensorArray is array (Positive range <>) of K_Ptr;
lightSensor : SensorArray (1 .. 10);

begin
    Serwer.Start;
    for I in Integer range 1 .. 10 loop
        lightsensor(I) := new Klient;
        delay (6.0);
        Put_Line("Ink"); 
    end loop; 
    Put_Line("Koniec_PG "); 
end Light_sensor;
	  	

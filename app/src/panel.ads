package Panel is

Koniec : Boolean := False with Atomic;
  
type Stany is (Duzo, Malo);
Stan : Stany := Malo with Atomic;
  
type Atrybuty is (Czysty, Jasny, Podkreslony, Negatyw, Migajacy, Szary);

protected Ekran  is
    procedure Pisz_XY(X,Y: Positive; S: String; Atryb : Atrybuty := Czysty);
    procedure Pisz_Float_XY(X, Y: Positive; 
                            Num: Float; 
                            Pre: Natural := 3; 
                            Aft: Natural := 2; 
                            Exp: Natural := 0; 
                            Atryb : Atrybuty := Czysty);
    procedure Czysc;
    procedure Tlo;
end Ekran;

procedure Run;

procedure Update(Id : Natural; Power : float);

end panel;

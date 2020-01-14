package Panel is

Koniec : Boolean := False with Atomic;
    
type Atrybuty is (Czysty);

protected Ekran  is
    procedure Pisz_XY(X,Y: Positive; S: String; Atryb : Atrybuty := Czysty);
    procedure Czysc;
    procedure Tlo;
end Ekran;

procedure Run;

procedure Update(Id : Natural; Power : float);

end panel;

package body pile is

function vide return pile_type is
begin
  index := 0;
  return pile;
end vide;

function sommet return object_type is
begin
  return pile(index);
end sommet;

procedure empile(nouveau : object_type) is
begin
  if index < max
  then index := index+1;
       pile(index) := nouveau;
  else raise pile_pleine;
  end if;
end empile;

procedure depile is
begin
  if index >= 1
  then index := index -1;
  else raise pile_vide;
  end if;
end depile;

end pile;


--types used in this project

package types is

   type tab_possibilite is array(1..9) of boolean;

   type cellule is record
      valeur : integer;
      resolu : boolean;
      valeur_a_placer : tab_possibilite;
   end record;

   type ligne is array(1..9) of cellule;
   type grille is array(1..9) of ligne;
   sudoku : grille;

end types;

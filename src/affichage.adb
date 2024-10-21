with Text_IO; use Text_IO;
with types;
with resolution;

package body affichage is

   procedure Resolu_Nb_Coup is
   begin
      put("RÈsolu en "); put(Integer'Image(resolution.coup)); put_line(" coups.");
   end Resolu_nb_coup;

   procedure Insoluble_nb_coup is
   begin
      put("Insoluble ("); put(Integer'Image(resolution.coup)); put_line(" coups)");
   end Insoluble_nb_coup;

   procedure une_alternative is
   begin
      put_line("Seule alternative :");
   end une_alternative;

   procedure premiere_alternative is
   begin
      put_line("1ere alternative :");
   end premiere_alternative;

   procedure deuxieme_alternative is
   begin
      put_line("2eme alternative :");
   end deuxieme_alternative;

   procedure retour_alternative is
   begin
      put_line("Retour sur l'autre alternative :");
   end retour_alternative;


  procedure affiche_grille is
  begin
      put_line("    1 2 3  4 5 6  7 8 9");
      put_line("  +------+------+------+");
      for ligne in 1..9 loop
         put(Integer'Image(Ligne)); Put("|");
         for col in 1..9 loop
            if not(Types.sudoku(ligne)(col).Valeur = 0)
            then put(Integer'Image(Types.sudoku(ligne)(col).Valeur));
            else put("  ");
            end if;
            if col=3 or col=6 or col=9
            then put("|");
            end if;
         end loop;
         put_line("");
         if ligne=3 or ligne=6 or ligne=9
         then put_line("  +------+------+------+");
         end if;
      end loop;
  end affiche_grille;


  procedure affiche_nb_poss is
      nb_poss : integer;
  begin
     put_line("Nombre de possibilit√© par case :");
      put_line("+------+------+------+");
      for ligne in 1..9 loop
         put("|");
         for col in 1..9 loop
            nb_poss :=0;
            for val in 1..9 loop
               if  Types.sudoku(ligne)(col).valeur_a_placer(val)
                 and Types.sudoku(ligne)(col).valeur=0
               then nb_poss:=nb_poss+1;
               end if;
            end loop;
            if Types.sudoku(ligne)(col).Valeur = 0
            then put(Integer'Image(nb_poss));
            else put("  ");
            end if;
            if col=3 or col=6 or col=9
            then put("|");
            end if;
         end loop;
         put_line("");
         if ligne=3 or ligne=6 or ligne=9
         then put_line("+------+------+------+");
         end if;
      end loop;
  end affiche_nb_poss;
end affichage;

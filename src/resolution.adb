-- Résolution d'une grille de SUDOKU 9*9
with Text_IO; use Text_IO;
with types; use types;
with pile;
with affichage;

package body resolution is
   --package Int_IO is new Integer_IO (Integer);  use Int_IO;
   package Pile_grille is new pile (grille);  use Pile_Grille;

   pause : Character := ' ';
   copie : Grille;
   changement : Boolean := True; --indicateur de case modifiée durant la boucle
   debug : Boolean; -- en mode debug, affichage sur la sortie standard
   exit_e : Exception; -- pour sortir

   -- -------------------------------------------------------
   -- teste si le sudoku est résolu ou non
   -- renvoie vrai si il est non résolu
   -- -------------------------------------------------------
   function non_resolu return Boolean is
      reste_case_vide : Boolean := False; --témoin de la présence d'une case
                                          --encore vide
   begin
      for ligne in  1 .. 9 loop
         for col in  1 .. 9 loop
            if sudoku (ligne) (col).valeur = 0
            then
               reste_case_vide := True;
            end if;
         end loop;
      end loop;
      return reste_case_vide;
   end non_resolu;

   -- -------------------------------------------------------
   -- met à jour la liste des valeurs à placer pour chaque case d'une ligne donnée
   -- -------------------------------------------------------
   procedure resoud_ligne (ligne : Integer) is
      -- a_placer(val) = True quand val est à placer
      a_placer : array (1 .. 9) of Boolean := (others => True);
   begin
      -- determine la liste des valeurs qui restent à placer pour cette ligne
      for col in  1 .. 9 loop
         if not(sudoku (ligne) (col).valeur = 0) -- résolu
         then
            a_placer (sudoku (ligne) (col).valeur) := False;
         end if;
      end loop;

      -- met à jour la liste des possibilités à placer à chaque case
      for col in  1 .. 9 loop
         if sudoku (ligne) (col).valeur = 0 --non résolu
         then
            for val in  1 .. 9 loop
               if not (a_placer (val)) then
                  sudoku (ligne) (col).valeur_a_placer (val) := False;
               end if;
            end loop;
         end if;
      end loop;
   end resoud_ligne;

   -- -------------------------------------------------------
   -- met à jour la liste des valeurs à placer pour chaque case d'une colonne donnée
   -- -------------------------------------------------------
   procedure resoud_colonne (col : Integer) is
      -- a_placer(val) = True quand val est à placer
      a_placer : array (1 .. 9) of Boolean := (others => True);
   begin
      -- determine la liste des valeurs qui restent à placer pour cette colonne
      for ligne in  1 .. 9 loop
         if not (sudoku (ligne) (col).valeur = 0) -- résolu
         then
            a_placer (sudoku (ligne) (col).valeur)  := False;
         end if;
      end loop;

      -- met à jour la liste des possibilités à placer à chaque case
      for ligne in  1 .. 9 loop
         if sudoku (ligne) (col).valeur = 0 --non résolu
         then
            for val in  1 .. 9 loop
               if not (a_placer (val)) then
                  sudoku (ligne) (col).valeur_a_placer (val)  := False;
               end if;
            end loop;
         end if;
      end loop;
   end resoud_colonne;

   -- -------------------------------------------------------
   -- met à jour la liste des valeurs à placer pour chaque case d'un carré donné
   -- -------------------------------------------------------
   procedure resoud_carre (ligne_d, col_d : Integer) is
            -- a_placer(val) = True quand val est à placer
      a_placer : array (1 .. 9) of Boolean := (others => True);
   begin
      -- determine la liste des valeurs qui restent à placer pour ce carré
      for ligne in  ligne_d .. ligne_d + 2 loop
         for col in  col_d .. col_d + 2 loop
            if not (sudoku (ligne) (col).valeur = 0) -- résolu
            then
               a_placer (sudoku (ligne) (col).valeur)  := False;
            end if;
         end loop;
      end loop;

      -- met à jour la liste des possibilités à placer à chaque case
      for ligne in  ligne_d .. ligne_d + 2 loop
         for col in  col_d .. col_d + 2 loop
            if sudoku (ligne) (col).valeur = 0 --non résolu
            then
               for val in  1 .. 9 loop
                  if not (a_placer (val)) then
                     sudoku (ligne) (col).valeur_a_placer (val)  := False;
                  end if;
               end loop;
            end if;
         end loop;
      end loop;
   end resoud_carre;

   -- -------------------------------------------------------
   -- initialise la grille de départ 
   -- -------------------------------------------------------
   procedure init_grille is
      continue : character := 'o';
      tmp : character;
      L,C,V : integer;
      procedure saisie is
      begin
         get_immediate(tmp);
         while not(tmp='0' or tmp='1' or tmp='2' or tmp='3' or tmp='4' or tmp='5'
                   or tmp='6' or tmp='7' or tmp='8' or tmp='9') loop
            get_immediate(tmp);
         end loop;
         put(Character'Image(tmp)(2..2));
      end saisie;
   begin
      -- initialise tout à 0
      for ligne in  1 .. 9 loop
         for col in  1 .. 9 loop
            sudoku (ligne) (col).valeur  := 0;
            sudoku (ligne) (col).valeur_a_placer  := (others=>True);
         end loop;
      end loop;
--        sudoku (1) (1).valeur  := 9;
--        sudoku (1) (2).valeur  := 6;
--        sudoku (1) (4).valeur  := 4;
--        sudoku (1) (6).valeur  := 7;
--        sudoku (1) (8).valeur  := 3;
--        sudoku (1) (9).valeur  := 2;
--        sudoku (2) (1).valeur  := 4;
--        sudoku (2) (3).valeur  := 2;
--        sudoku (2) (5).valeur  := 1;
--        sudoku (2) (7).valeur  := 9;
--        sudoku (2) (9).valeur  := 7;
--        sudoku (3) (1).valeur  := 7;
--        sudoku (3) (9).valeur  := 4;
--        sudoku (4) (2).valeur  := 9;
--        sudoku (4) (3).valeur  := 4;
--        sudoku (4) (4).valeur  := 8;
--        sudoku (4) (6).valeur  := 1;
--        sudoku (4) (7).valeur  := 2;
--        sudoku (4) (8).valeur  := 5;
--        sudoku (5) (2).valeur  := 7;
--        sudoku (5) (4).valeur  := 3;
--        sudoku (5) (5).valeur  := 4;
--        sudoku (5) (6).valeur  := 2;
--        sudoku (5) (8).valeur  := 9;
--        sudoku (6) (2).valeur  := 8;
--        sudoku (6) (3).valeur  := 3;
--        sudoku (6) (4).valeur  := 5;
--        sudoku (6) (6).valeur  := 6;
--        sudoku (6) (7).valeur  := 7;
--        sudoku (6) (8).valeur  := 4;
--        sudoku (7) (1).valeur  := 8;
--        sudoku (7) (9).valeur  := 6;
--        sudoku (8) (1).valeur  := 1;
--        sudoku (8) (3).valeur  := 6;
--        sudoku (8) (5).valeur  := 3;
--        sudoku (8) (7).valeur  := 8;
--        sudoku (8) (9).valeur  := 9;
--        sudoku (9) (1).valeur  := 3;
--        sudoku (9) (2).valeur  := 2;
--        sudoku (9) (4).valeur  := 1;
--        sudoku (9) (6).valeur  := 8;
--        sudoku (9) (8).valeur  := 7;
--        sudoku (9) (9).valeur  := 5;

      put_line("Saisie de la grille :");
      while(continue='o') loop
         put("Ligne : ");
         saisie;
         L:=Integer'Value(Character'Image(tmp)(2..2));
         put_line("");
         put("Colonne : ");
         saisie;
         C:=Integer'Value(Character'Image(tmp)(2..2));
         put_line("");
         put("Valeur : ");
         saisie;
         V:=Integer'Value(Character'Image(tmp)(2..2));
         sudoku(L)(C).valeur := V;
         put_line("");
         affichage.affiche_grille;
         put_line("Continuer ? (o/n)");
         get_immediate(continue);
         while continue/='o' and continue/='n' loop
            get_immediate(continue);
         end loop;
      end loop;
   end init_grille;

   -- -------------------------------------------------------
   -- duplique sudoku dans copie
   -- -------------------------------------------------------
   procedure duplique is
   begin
      for ligne in 1..9 loop
         for col in 1..9 loop
            copie(ligne)(col).valeur := sudoku(ligne)(col).valeur;
            copie(ligne)(col).valeur_a_placer(1..9) := sudoku(ligne)(col).valeur_a_placer(1..9);
         end loop;
      end loop;
   end duplique;

   -- -------------------------------------------------------
   -- duplique sudoku à partir de copie
   -- -------------------------------------------------------
   procedure restaure is
   begin
      for ligne in 1..9 loop
         for col in 1..9 loop
            sudoku(ligne)(col).valeur := copie(ligne)(col).valeur;
            sudoku(ligne)(col).valeur_a_placer(1..9) := copie(ligne)(col).valeur_a_placer(1..9);
         end loop;
      end loop;
   end restaure;

   -- -------------------------------------------------------
   -- met à jour la liste des valeurs à placer en examinant chaque ligne, colonne et carré
   -- -------------------------------------------------------
   procedure evalue_possibilites is
   begin
      for ligne in  1 .. 9 loop
            resoud_ligne (ligne);
      end loop;
      for col in  1 .. 9 loop
            resoud_colonne (col);
      end loop;
      resoud_carre (1, 1);
      resoud_carre (1, 4);
      resoud_carre (1, 7);
      resoud_carre (4, 1);
      resoud_carre (4, 4);
      resoud_carre (4, 7);
      resoud_carre (7, 1);
      resoud_carre (7, 4);
      resoud_carre (7, 7);
   end evalue_possibilites;

   -- -------------------------------------------------------
   -- 
   -- -------------------------------------------------------
   procedure resoud_possibilites is
      dernier   : Integer:=0;
      avdernier : Integer:=0;
      nb_poss   : Integer;
   begin
      boucle :
      for ligne in  1 .. 9 loop
         for col in  1 .. 9 loop
            nb_poss := 0;
            -- évalue le nombre de possibilité nb_poss
            if sudoku (ligne) (col).valeur = 0 --case non remplie
            then
              for val in  1 .. 9 loop
                 if sudoku (ligne) (col).valeur_a_placer (val)
                 then
                    nb_poss   := nb_poss + 1;
                    avdernier := dernier;
                    dernier   := val; --pour garder les 2 derniers
                 end if;
              end loop;
            end if;

            -- résoud les cases à 1 possibilité
            if sudoku (ligne) (col).valeur = 0 and nb_poss = 1
            then
               sudoku (ligne) (col).valeur  := dernier;
               evalue_possibilites;
               depile; empile(sudoku); --met à jour le sommet de la pile
               changement := True; -- on a placé une valeur
               if debug then
                  affichage.une_alternative;
                  affichage.affiche_grille;
                  get_immediate(pause);
                  if pause='q' then raise exit_e; end if;
               end if;
               exit boucle; --sortie
            end if;

            --depile lorsqu'on a tombe sur une impossibilité
            if sudoku (ligne) (col).valeur = 0 and nb_poss = 0 
            then
               depile;
               sudoku := sommet;
               if debug then
                  affichage.retour_alternative;
                  affichage.affiche_grille;
                  get_immediate(pause);
                  if pause='q' then raise exit_e; end if;
               end if;
               changement := True; --on va essayer l'autre valeur
               exit boucle; --sortie
            end if;

            --dépile le sommet et empile les 2 possibilités (dernier et avdernier)
            if sudoku(ligne)(col).valeur = 0 and nb_poss = 2
            then
               if index>0 then depile; end if; -- depile le sommet

               duplique;
               sudoku (ligne) (col).valeur := dernier;
               evalue_possibilites;
               empile(sudoku);
               if debug then
                 affichage.premiere_alternative;
                 affichage.affiche_grille;
                 get_immediate(pause);
                 if pause='q' then raise exit_e; end if;
               end if;

               restaure; --besoin de dupliquer et restaurer car evalue_possibilites
                         --peut avoir modifié les cas possibles des autres cases.
               sudoku (ligne) (col).valeur  := avdernier;
               evalue_possibilites;
               empile(sudoku);
               if debug then
                 affichage.deuxieme_alternative;
                 affichage.affiche_grille;
                 get_immediate(pause);
                 if pause='q' then raise exit_e; end if;
               end if;
               changement := True; -- on essaye une valeur
            end if;
         end loop;
      end loop boucle;
   end resoud_possibilites;

   -- -------------------------------------------------------
   -- saisie d'une grille et tente sa résolution 
   -- -------------------------------------------------------
   procedure resoud(debug_p : Boolean) is
   begin

      init_grille;

      debug := debug_p;
      if debug 
      then affichage.affiche_grille;
      end if;

      while (non_resolu) and changement and coup < 100000 loop
         coup := coup + 1;
         changement := False;
         evalue_possibilites;
         resoud_possibilites; --changement=True si on a placé au moins une valeur
      end loop;

      if non_resolu then
         affichage.Insoluble_nb_coup;
         affichage.affiche_nb_poss;
      else
        affichage.Resolu_nb_coup;
        affichage.affiche_grille;
      end if;

      Get(pause);

      Exception
       when Pile_vide => put_line("ERREUR de pile vide !!!"); affichage.affiche_nb_poss; Get(pause); raise;
       when Pile_pleine => put_line("ERREUR de pile pleine!!!"); affichage.affiche_nb_poss; Get(pause); raise;
       when exit_e => raise;
       when others => put_line("ERREUR !!!"); affichage.affiche_nb_poss; Get(pause); raise;
   end resoud;

end resolution;

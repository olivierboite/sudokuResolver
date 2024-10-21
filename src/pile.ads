generic
   type object_type is private;

Package pile is
   max : constant integer := 35;
   pile_vide : Exception;
   pile_pleine : Exception;
   type pile_type is array(1..max) of object_type;
   pile : pile_type;
   function vide return pile_type;
   function sommet return object_type;
   Procedure empile(nouveau : object_type);
   procedure depile;
   index : integer := 0;
end pile;


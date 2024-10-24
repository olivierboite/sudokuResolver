with Resolution;
with Ada.Command_Line;

--main program
procedure sudokuresolver is
  debug : boolean := False;
begin
   if Ada.Command_Line.Argument_Count > 0
   then if Ada.Command_Line.Argument(1)= "-d" 
        then debug:= True; 
        end if;
   end if;

   Resolution.resoud(debug);
end sudokuresolver;

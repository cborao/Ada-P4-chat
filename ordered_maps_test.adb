

	--PRÁCTICA 4: CÉSAR BORAO MORATINOS (Ordered_Maps_G, Test Program)


    with Ada.Text_IO;
    With Ada.Strings.Unbounded;
    with Ordered_Maps_G;

procedure Ordered_Maps_Test is

  package ASU  renames Ada.Strings.Unbounded;
  package ATI renames Ada.Text_IO;

  package Maps is new Ordered_Maps_G (Key_Type   => Natural,
                                      Value_Type => Natural,
                                      "="        => "=",
                                      "<"        => "<",
                                      Max       => 4);


  procedure Print_Map (M : Maps.Map) is
    C: Maps.Cursor := Maps.First(M);
  begin
    Ada.Text_IO.Put_Line ("Map");
    Ada.Text_IO.Put_Line ("===");

    while Maps.Has_Element(C) loop
      Ada.Text_IO.Put_Line (Natural'Image(Maps.Element(C).Key) & " " &
      Natural'Image(Maps.Element(C).Value));
      Maps.Next(C);
    nd loop;
  end Print_Map;

  procedure Do_Put (M: in out Maps.Map; K: Natural; V: Natural) is

  begin
    Ada.Text_IO.New_Line;
    ATI.Put_Line("Putting" & Natural'Image(K));
    Maps.Put (M, K, V);
    Print_Map(M);
  exception
    when Maps.Full_Map =>
      Ada.Text_IO.Put_Line("Full_Map");
  end Do_Put;

    procedure Do_Get (M: in out Maps.Map; K: Natural) is
      V: Natural;
      Success: Boolean;
    begin
      Ada.Text_IO.New_Line;
      ATI.Put_Line("Getting" & Natural'Image(K));
      Maps.Get (M, K, V, Success);
      if Success then
        Ada.Text_IO.Put_Line("Value:" & Natural'Image(V));
        Print_Map(M);
      else
        Ada.Text_IO.Put_Line("Element not found!");
      end if;
    end Do_Get;

    procedure Do_Delete (M: in out Maps.Map; K: Natural) is
       Success: Boolean;
    begin
       Ada.Text_IO.New_Line;
       ATI.Put_Line("Deleting" & Natural'Image(K));
       Maps.Delete (M, K, Success);
       if Success then
         Ada.Text_IO.Put_Line("borrado");
         Print_Map(M);
       else
          Ada.Text_IO.Put_Line("Element not found!");
       end if;
    end Do_Delete;

    O_Map: Maps.Map;

begin

  Do_Put (O_Map, 3, 3);
  Do_Put (O_Map, 2, 2);
  Do_Put (O_Map, 1, 1);
  Do_Put (O_Map, 0, 0);


  Do_Get (O_Map, 10000000);
  Do_Get (O_Map, 2);
  Do_Get (O_Map, 23);
  Do_Get (O_Map, 3);

  Do_Delete (O_Map, 10000000);
  Do_Delete (O_Map, 2);
  Do_Delete (O_Map, 0);
  Do_Delete (O_Map, 3);
  Do_Delete (O_Map, 1);
  Do_Get (O_Map, 1);
  Do_Put (O_Map, 1, 1);
  Do_Get (O_Map, 1);

end Ordered_Maps_Test;

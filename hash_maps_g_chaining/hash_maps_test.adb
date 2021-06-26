

		-- Práctica 4: César Borao Moratinos (Hash_Maps_G_Chaining, Test Program)


    with Ada.Text_IO;
    With Ada.Strings.Unbounded;
    with Ada.Numerics.Discrete_Random;
    with Hash_Maps_G;

procedure Hash_Maps_Test is
   package ASU  renames Ada.Strings.Unbounded;
   package ATIO renames Ada.Text_IO;

   HASH_SIZE:   constant := 10;

   type Hash_Range is mod HASH_SIZE;

   function Natural_Hash (N: Natural) return Hash_Range is

   begin
      return Hash_Range'Mod(N);
   end Natural_Hash;

   function Nick_to_Integer (Nick: ASU.Unbounded_String) return Integer is

		C: character;
		Result: Integer := 0;
		Counter: Integer := 1;
	begin

		loop
			C := ASU.Element(Nick, Counter);
			Result := Result + Character'Pos(C);
			exit when Counter = ASU.Length(Nick);
			Counter := Counter + 1;
		end loop;
		return Result;
	end Nick_to_Integer;

    function Nick_Hash (Nick: ASU.Unbounded_String) return Hash_Range is
	begin
		return Hash_Range'Mod(Nick_to_Integer(Nick));
	end Nick_Hash;


   package Maps is new Hash_Maps_G (Key_Type   => ASU.Unbounded_String,
                                    Value_Type => Natural,
                                    "="        => ASU."=",
                                    Hash_Range => Hash_Range,
                                    Hash => Nick_Hash,
                                    Max => 10);


   procedure Print_Map (M : Maps.Map) is
       C: Maps.Cursor := Maps.First(M);
   begin
      Ada.Text_IO.Put_Line ("Map");
      Ada.Text_IO.Put_Line ("===");

      while Maps.Has_Element(C) loop
         Ada.Text_IO.Put_Line (ASU.To_String(Maps.Element(C).Key) & " " &
                               Natural'Image(Maps.Element(C).Value));
         Maps.Next(C);
      end loop;
   end Print_Map;


   procedure Do_Put (M: in out Maps.Map; K: ASU.Unbounded_String; V: Natural) is
   begin
      Ada.Text_IO.New_Line;
      ATIO.Put_Line("Putting " & ASU.To_String(K));
      Maps.Put (M, K, V);
      Print_Map(M);
   exception
      when Maps.Full_Map =>
         Ada.Text_IO.Put_Line("Full_Map");
   end Do_Put;


   procedure Do_Get (M: in out Maps.Map; K: ASU.Unbounded_String) is
      V: Natural;
      Success: Boolean;
   begin
      Ada.Text_IO.New_Line;
      ATIO.Put_Line("Getting " & ASU.To_String(K));
      Maps.Get (M, K, V, Success);
      if Success then
         Ada.Text_IO.Put_Line("Value: " & Natural'Image(V));
         Print_Map(M);
      else
         Ada.Text_IO.Put_Line("Element not found!");
      end if;
   end Do_Get;


   procedure Do_Delete (M: in out Maps.Map; K: ASU.Unbounded_String) is
      Success: Boolean;
   begin
      Ada.Text_IO.New_Line;
      ATIO.Put_Line("Deleting " & ASU.To_String(K));
      Maps.Delete (M, K, Success);
      if Success then
         Print_Map(M);
      else
         Ada.Text_IO.Put_Line("Element not found!");
      end if;
   end Do_Delete;

   A_Map : Maps.Map;

begin

   -- First puts
   Do_Put (A_Map, ASU.To_Unbounded_String("lechuga"), 10);
   Do_Put (A_Map, ASU.To_Unbounded_String("tomate"), 11);
   Do_Put (A_Map, ASU.To_Unbounded_String("cebolla"), 30);
   Do_Put (A_Map, ASU.To_Unbounded_String("pimiento"), 15);
   Do_Put (A_Map, ASU.To_Unbounded_String("atun"), 50);
   Do_Put (A_Map, ASU.To_Unbounded_String("aceituna"), 17);
   Do_Put (A_Map, ASU.To_Unbounded_String("maiz"), 16);
   Do_Put (A_Map, ASU.To_Unbounded_String("aceite"), 40);
   Do_Put (A_Map, ASU.To_Unbounded_String("esparrago"), 25);
   Do_Put (A_Map, ASU.To_Unbounded_String("vinagre"), 60);

   -- Now deletes
   Do_Delete (A_Map, ASU.To_Unbounded_String("cebolla"));
   Do_Delete (A_Map, ASU.To_Unbounded_String("carne"));
   Do_Delete (A_Map, ASU.To_Unbounded_String("pescado"));
   Do_Delete (A_Map, ASU.To_Unbounded_String("aceituna"));
   Do_Delete (A_Map, ASU.To_Unbounded_String("bacon"));
   Do_Delete (A_Map, ASU.To_Unbounded_String("macarron"));

   -- Now gets
   Do_Get (A_Map, ASU.To_Unbounded_String("arroz"));
   Do_Get (A_Map, ASU.To_Unbounded_String("cebolla"));
   Do_Get (A_Map, ASU.To_Unbounded_String("vinagre"));

end Hash_Maps_Test;

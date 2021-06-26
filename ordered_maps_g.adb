

	--PRÁCTICA 4: CÉSAR BORAO MORATINOS (Ordered_Maps_G.adb)


package body Ordered_Maps_G is


    function Binary_Search (M: Map; Key: Key_Type;
                            Left: Integer; Right: Integer) return Integer is

        Middle: Integer;

    begin
        if Right < Left then
            return Left;
        else
            Middle := (Left + Right)/2;
            if Left = Right then
                return Left;
            elsif M.P_Array(Middle).Key < Key then
                return Binary_Search (M,Key,Middle + 1,Right);
            elsif Key < M.P_Array(Middle).Key then
                return Binary_Search (M,Key,Left,Middle);
            else
                return Middle;
            end if;
        end if;
    end Binary_Search;

    procedure Put (M: in out Map;
                   Key: Key_Type;
                   Value: Value_Type) is

        Position: Integer := 0;
        Left: Integer := 0;

    begin

        if M.P_Array = null or M.Length = 0 then
            M.P_Array := new Cell_Array;
            M.P_Array(0) := (Key, Value, True);
    		M.Length := 1;
    	else
            Position := Binary_Search (M,Key,Left,M.Length);

            if Position > Max - 1 then
              raise Full_Map;
            end if;

            if M.P_Array(Position).Full and M.P_Array(Position).Key = Key then

              M.P_Array(Position).Value := Value;
            elsif M.P_Array(Position).Full then
              for I in reverse Position..M.Length-1 loop
                if M.Length = Max then
                  raise Full_Map;
                end if;

                M.P_Array(I + 1) := M.P_Array(I);
              end loop;

               M.Length := M.Length + 1;
               M.P_Array(Position) := (Key, Value, True);
            else
              M.P_Array(Position) := (Key, Value, True);
              M.Length := M.Length + 1;
            end if;
        end if;
    end Put;


  procedure Get (M: Map;
			     Key: in Key_Type;
			     Value: out Value_Type;
			     Success: out Boolean) is

   	Left: Integer := 0;
    Right: Integer := Max-1;
    Position: Integer := 0;
   begin

    Success := False;
    if M.P_Array /= null then
      Position := Binary_Search (M,Key,Left,Right);
      if Position <= Max - 1 then
        if M.P_Array(0).Key = Key then
          Success := True;
          Value := M.P_Array(Binary_Search (M,Key,Left,Right)).Value;
        end if;
      end if;
    end if;
   end Get;

   procedure Delete (M: in out Map;
                     Key: in Key_Type;
                     Success: out Boolean) is

        Left: Integer := 0;
        Right: Integer := M.Length;
        Position: Integer;

    begin
        Success := False;
        Position := Binary_Search (M,Key,Left,Right);

        if Position <= Max - 1 then
            if M.P_Array(Position).Key = Key then
                Success := True;
                M.Length := M.Length - 1;
                for I in Position..M.Length - 1 loop
                        M.P_Array(I) := M.P_Array(I + 1);
                end loop;
            end if;
        end if;
    end Delete;

  function Map_Length (M: Map) return Natural is
  begin
      return M.Length;
  end Map_Length;

	function First (M: Map) return Cursor is
        C: Cursor;
	begin
        C.M := M;
		C.Position := 0;
		return C;
	end First;

	procedure Next (C: in out Cursor) is

        End_Of_Map: Boolean;
	begin
        End_Of_Map := False;
        if C.Position <= Max then
            C.Position := C.Position + 1;
        end if;
	end Next;

	function Has_Element (C: Cursor) return Boolean is

	begin
        if C.Position >= C.M.Length then
            return False;
        end if;
		return C.M.P_Array(C.Position).Full;
	end Has_Element;

	function Element (C: Cursor) return Element_Type is
	       Element: Element_Type;
	begin
		if Has_Element (C) then
			Element.Key := C.M.P_Array(C.Position).Key;
			Element.Value := C.M.P_Array(C.Position).Value;
		else
			raise No_Element;
		end if;
		return Element;
	end Element;

end Ordered_Maps_G;



		-- Práctica 4: César Borao Moratinos (Hash_Maps_G_Open.adb)


    with Ada.Text_IO;
    with Ada.Strings.Unbounded;

package body Hash_Maps_G is

    package ASU renames Ada.Strings.Unbounded;

    procedure Put (M: in out Map;
                   Key: Key_Type;
                   Value: Value_Type) is

        Position: Hash_Range := Hash(Key);
        Success : Boolean;
        Found : Boolean := False;
        First_Deleted : Hash_Range;
        Deleted_Element: Boolean := False;
        Free_Cell: Hash_Range;

    begin
        Success := False;
        if M.P_Array = null then
            M.P_Array := new Cell_Array;
            M.P_Array(Position) := (Key,Value,True,False);
            M.Length := 1;

        else
            if not M.P_Array(Position).Full then
                if M.Length = Max then
                    raise Full_Map;
                end if;
                M.P_Array(Position) := (Key,Value,True,False);
                M.Length := M.Length + 1;

            elsif M.P_Array(Position).Key = Key and not M.P_Array(Position).Deleted then
                M.P_Array(Position).Value := Value;
            else
                Position := Position + 1;

                while not Success and Position < Hash_Range'Last loop
                    if M.P_Array(Position).Key = Key and not M.P_Array(Position).Deleted then
                        Success := True;
                        M.P_Array(Position).Value := Value;
                    end if;

                    if M.P_Array(Position).Deleted and not Deleted_Element then
                        First_Deleted := Position;
                        Deleted_Element := True;
                        Found := True;
                    end if;

                    if not M.P_Array(Position).Full and not Found then
                        Free_Cell := Position;
                        Found := True;
                    end if;
                    Position := Position + 1;
                end loop;

                if not Success and Deleted_Element then
                    if M.Length = Max then
                        raise Full_Map;
                    end if;
                    M.P_Array(First_Deleted) := (Key,Value,True,False);
                    M.Length := M.Length + 1;
                    Success := True;
                end if;

                if not Success then
                    if M.Length = Max then
                      raise Full_Map;
                    end if;
                    M.P_Array(Free_Cell) := (Key,Value,True,False);
                    M.Length := M.Length + 1;
                end if;
            end if;
        end if;
    end Put;

    procedure Get (M: Map;
                   Key: in Key_Type;
                   Value: out Value_Type;
                   Success: out Boolean) is

        Position: Hash_Range := Hash(Key);
        First_Deleted : Hash_Range;
        Deleted_Element: Boolean := False;
    begin
        Success := False;
        if M.P_Array /= null then
            if M.P_Array(Position).Full or M.P_Array(Position).Deleted then
                if M.P_Array(Position).Key = Key and not M.P_Array(Position).Deleted then
                    Value := M.P_Array(Position).Value;
                    Success := True;
                end if;
                if M.P_Array(Position).Deleted and not Deleted_Element then
                    First_Deleted := Position;
                    Deleted_Element := True;
                end if;
                Position := Position + 1;

                while not Success and Position < Hash_Range'Last loop
                    if not M.P_Array(Position).Deleted and M.P_Array(Position).Key = Key then
                        Value := M.P_Array(Position).Value;
                        Success := True;
                    end if;
                    if M.P_Array(Position).Deleted and not Deleted_Element then
                        First_Deleted := Position;
                        Deleted_Element := True;
                    end if;
                    Position := Position + 1;
                end loop;
            end if;

            if Success and Deleted_Element then
                M.P_Array(Position).Deleted := True;
                M.P_Array(Position).Full := False;
                M.P_Array(First_Deleted) := (Key,Value,True,False);
            end if;

        end if;
      end Get;

    procedure Delete (M: in out Map;
                      Key: in Key_Type;
                      Success: out Boolean) is

        Position: Hash_Range := Hash(Key);
    begin
        Success := False;
        if M.P_Array /= null then
            if M.P_Array(Position).Full or M.P_Array(Position).Deleted then
                if M.P_Array(Position).Key = Key and not M.P_Array(Position).Deleted then
                    M.P_Array(Position).Full := False;
                    M.P_Array(Position).Deleted := True;
                    M.Length := M.Length - 1;
                    Success := True;
                end if;

                Position := Position + 1;
                while not Success and Position < Hash_Range'Last loop
                    if not M.P_Array(Position).Deleted and M.P_Array(Position).Key = Key then
                        M.P_Array(Position).Full := False;
                        M.P_Array(Position).Deleted := True;
                        M.Length := M.Length - 1;
                        Success := True;
                    end if;
                    Position := Position + 1;
                end loop;
            end if;
        end if;
    end Delete;

    function Map_Length (M : Map) return Natural is
    begin
        return M.Length;
    end Map_Length;

    function First (M: Map) return Cursor is
        C: Cursor;
    begin
        C.M := M;
        C.Position := 0;
        while not C.M.P_Array(C.Position).Full and C.Position < Hash_Range'Last loop
            C.Position := C.Position + 1;
        end loop;
        return C;
    end First;

    procedure Next (C: in out Cursor) is

    begin

        C.Position := C.Position + 1;
        if C.Position = Hash_Range'First then
            C.End_Found := True;
        end if;
        while not C.M.P_Array(C.Position).Full and C.Position < Hash_Range'Last loop
            C.Position := C.Position + 1;
        end loop;
    end Next;

    function Has_Element (C: Cursor) return Boolean is

    begin
        if C.End_Found then
            return False;
        elsif C.M.P_Array(C.Position).Full then
            return True;
        else
            return False;
        end if;
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

end Hash_Maps_G;

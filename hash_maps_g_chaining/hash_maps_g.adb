

		-- Práctica 4: César Borao Moratinos (Hash_Maps_G_Chaining.adb)


	with Ada.Text_IO;
	with Ada.Strings.Unbounded;
  	with Ada.Unchecked_Deallocation;

package body Hash_Maps_G is

	package ASU renames Ada.Strings.Unbounded;

	procedure Put (M: in out Map;
				   Key: Key_Type;
				   Value: Value_Type) is

		P_Aux: Cell_A;
		Success: Boolean;
	begin

		Success := False;

		if M.P_Array = null then

			M.P_Array := new Cell_Array;
			M.P_Array(Hash(Key)) := new Cell'(Key,Value,null);
			M.Length := 1;
			M.Counter := 1;
		else
			if M.P_Array(Hash(Key)) = null then
				if M.Length = Max then
					raise Full_Map;
				end if;
				M.P_Array(Hash(Key)) := new Cell'(Key, Value, null);
				M.Length := M.Length + 1;
				M.Counter := M.Counter + 1;
			else
				P_Aux := M.P_Array(Hash(Key));
				while P_Aux.Next /= null and not Success loop
					if P_Aux.Key = Key then
						P_Aux.Value := Value;
						Success := True;
					end if;
					P_Aux := P_Aux.Next;
				end loop;

				if P_Aux.Next = null and not Success then
					if P_Aux.Key = Key then
						P_Aux.Value := Value;
						Success := True;
					end if;
				end if;

				if not Success then
					if M.Counter = Max then
						raise Full_Map;
					end if;
					P_Aux.Next := new Cell'(Key,Value,null);
					M.Counter := M.Counter + 1;
				end if;
			end if;
		end if;
	end Put;

	procedure Get (M: Map;Key: in Key_Type;
				   Value: out Value_Type;
				   Success: out Boolean) is

		P_Aux: Cell_A;
	begin
		Success := False;
		if M.P_Array /= null then
			P_Aux := M.P_Array(Hash(Key));
			if P_Aux /= null then
				while P_Aux.Next /= null and not Success loop
					if P_Aux.Key = Key then
						Value := P_Aux.Value;
						Success := True;
					end if;
					P_Aux := P_Aux.Next;
				end loop;
				if P_Aux.Next = null and not Success then
					if P_Aux.Key = Key then
						Value := P_Aux.Value;
						Success := True;
					end if;
				end if;

			end if;
		end if;
	end Get;

	procedure Delete (M: in out Map;
					  Key: in Key_Type;
					  Success: out Boolean) is

	    P_Current: Cell_A := M.P_Array(Hash(Key));
	    P_Previous: Cell_A := P_Current;

		procedure Free is new Ada.Unchecked_Deallocation (Cell, Cell_A);

	begin
		Success := False;

		while P_Current /= null loop
			if P_Previous.Key = Key then
				Success := True;
				M.P_Array(Hash(Key)) := M.P_Array(Hash(Key)).Next;
				Free(P_Current);
				M.Counter := M.Counter - 1;
				if M.P_Array(Hash(Key)) = null then
					M.Length := M.Length - 1;
				end if;
			elsif P_Current.Key = Key then
				Success := True;
				P_Previous.Next := P_Current.Next;
				Free(P_Current);
				M.Counter := M.Counter - 1;
			else
				P_Previous := P_Current;
				P_Current := P_Current.Next;
			end if;
		end loop;
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

		while C.M.P_Array(C.Position) = null and C.Position < Hash_Range'Last loop
			C.Position := C.Position + 1;
		end loop;
		C.Pointer := C.M.P_Array(C.Position);
		return C;
	end First;

	procedure Next (C: in out Cursor) is

	begin
		if C.Pointer.Next = null then
			C.Position := C.Position + 1;
			if C.Position = Hash_Range'First then
				C.Pointer := null;
			else
				C.Pointer := C.M.P_Array(C.Position);
				while C.Pointer = null and C.Position < Hash_Range'Last loop
					C.Position := C.Position + 1;
					C.Pointer := C.M.P_Array(C.Position);
				end loop;
			end if;
		else
			C.Pointer := C.Pointer.Next;
		end if;
	end Next;

	function Has_Element (C: Cursor) return Boolean is

	begin
		if C.Pointer /= null then
			return True;
		else
			return False;
		end if;
	end Has_Element;

	function Element (C: Cursor) return Element_Type is

		Element: Element_Type;
	begin
		if Has_Element (C) then
			Element.Key := C.Pointer.Key;
			Element.Value := C.Pointer.Value;
		else
			raise No_Element;
		end if;
		return Element;
	end Element;
end Hash_Maps_G;

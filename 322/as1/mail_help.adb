package body Mail_Help is
    
    protected body Random_Manager is
        function Random(Max : Float) return Float is
        begin
            if First then
                First := False;
                Reset(Gen);
            end if;

            return Random(Gen);
        end Random;
    end Random_Manager;
    
    protected body Mailbox_Type is

        procedure Put(Message : in Message_Type) is
        begin
            Messages.Enqueue(Message);
            Message_Count := Message_Count + 1;
        end Put;

        procedure Get(Message : out Message_Type) is
        begin
            Message := Messages.Dequeue(Message);
            Message_Count := Message_Count - 1;
        exception
            -- need exceptions here...
            when others => null;
        end Get;

        function Num_Messages return Natural is
        begin
            return Message_Count;
        end Num_Messages;

    end Mailbox_Type;

    protected body Message_Manager is
        
        function Random_Message return Unbounded_String is
            Index : Positive;
        begin
            if not Initialized then
                Initialize;
            end if;

            Index := 1 + Random_Manager.Random(Float(Num_Messages));
            return Message_Array(Index);
            
        end Random_Message;

        procedure Initialize is
            File : File_Type;
            Buffer : String(1..1024);
            Message : Unbounded_String;
            Count : Natural := 0;
            Read : Natural;
            Index : Positive;
        begin
            
            Open(File, In_File, Messages_Filename);
            while not End_Of_File(File) loop
                Get_Line(File, Buffer, Read);
                Count := Count + 1;
            end loop;

            Message_Array := new UBS_Array_Type(1..Count);
            Num_Messages := Count;
            Reset(File);
            
            Index := 1;
            while not End_Of_File(File) loop
                Get_Line(File, Buffer, Read);
                Message_Array(Index) := To_Unbounded_String(Buffer(1..Read));
                Index := Index + 1;
            end loop;
            
            Initialized = True;

        exception 
           when Name_Error =>
               Put_Line("Could not open " & Messages_Filename & ".");
               raise Name_Error;
            
        end Initialize;

    end Message_Manager;
    
    

    
    
end Mail_Help;

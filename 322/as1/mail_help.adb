with Ada.Text_IO; use Ada.Text_IO;

package body Mail_Help is

    procedure Read_String_Array(Str_Array : out Str_Array_Ptr;
                                Count : out Natural;
                                Filename : in string)
    is
        File : File_Type;
        Buffer : String(1..1024);
        Read : Natural;
        Index : Positive;
    begin
        
        Count := 0;
        Open(File, In_File, Filename);
        while not End_Of_File(File) loop
            Get_Line(File, Buffer, Read);
            Count := Count + 1;
        end loop;
        
        Str_Array := new Str_Array_Type(1..Count);
        Reset(File);
            
        Index := 1;
        while not End_Of_File(File) loop
            Get_Line(File, Buffer, Read);
            Str_Array(Index) := To_Unbounded_String(Buffer(1..Read));
            Index := Index + 1;
        end loop;
        
    exception 
       when Name_Error =>
           Put_Line("Could not open " & Filename & ".");
           raise Name_Error;
           
    end Read_String_Array;
    
    -- Random utilities
    Random_Initialized : Boolean := False;
    Gen : Generator;
    
    function Random(Max : Float) return Float is
    begin
        if not Random_initialized then
            Random_initialized := True;
            Reset(Gen);
        end if;

        return Random(Gen) * Max;
    end Random;

    function Int(Max : Natural) return Natural is
        Float_Max : Float := Random(Float(Max));
    begin
        return Natural(Float_Max);
    end Int;
        
    
    protected body Mailbox_Type is

        procedure Put(Message : in Message_Type) is
        begin
            Message_Queue.Enqueue(Messages, Message);
            Message_Count := Message_Count + 1;
        exception
            when others => raise Mailbox_Full;
        end Put;

        procedure Get(Message : out Message_Type) is
        begin
            Message_Queue.Dequeue(Messages, Message);
            Message_Count := Message_Count - 1;
        exception
           when others => raise Mailbox_Empty;
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

            Index := 1 + Random_Manager.Int(Num_Messages);
            return Message_Array(Index);
            
        end Random_Message;

        procedure Initialize is
        begin
           Read_String_Array(Message_Array, Messages_Filename);
           Initialized := True; 
        end Initialize;

    end Message_Manager;

    
    
    protected body Name_Manager is

        function Next_Name return Unbounded_String 
        is
            Name : Unbounded_String;
        begin
            
            if not Initialized then
                Initialize;
            end if;
            
            -- check if we've used up all the names 
            if Current_Index > Num_Names then
                Current_Index := 1;
                Suffix := Suffix + 1;
                Randomize;
            end if;

            Name := Names(Current_Index);

            -- add suffix if necessary
            if Suffix > 0 then
                Append(Name, Integer'Image(Suffix));
            end if;
            
            Current_Index := Current_Index + 1;
            
            return Name;
            
        end Next_Name;

        
        procedure Initialize 
        is
        begin
            Read_String_Array(Names, Names_Filename);
            Initialized := True;
        end Initialize;

        procedure Randomize is
            Swap_Index : Positive;
            Swap_Value : Unbounded_String;
        begin

            for I in 1..Num_Names-1 loop
                
                Swap_Index := I + Random_Manager.Int(Num_Names - I);
                
            end loop;
            
        end Randomize;
        
        
    end Name_Manager;



    protected body Client_Manager is
        
        
        function Num_Clients return Natural is
        begin
            return Registered_Clients;
        end Num_Clients;

        function Next_Index return Positive is
            Index : Positive := 1;
        begin
            while Clients(Index).Available loop
                Index := 1 + Index;
            end loop;
            return Index;
        end Next_Index;
            
        function Random_Mailbox(My_ID : in Natural) return Mailbox_Ptr is
            Index : Positive;
        begin
            
            -- terribly inefficent way of doing this, but I'd rather
            --  not fight ada and build another data structure
            
            -- get an available index
            loop
                Index := 1 + Random_Manager.Int(Registered_Clients);
                exit when Clients(Index).Id /= My_ID and Clients(Index).Available;
            end loop;

            return Clients(Index).Mailbox_Ptr;
            
        end Random_Mailbox;

        procedure Register(Name : out Unbounded_String;
                           Id : out Natural;
                           Mailbox : out Mailbox_Ptr)
        is
            Index : Positive := Next_Index;
        begin
            Registered_Clients := 1 + Registered_Clients;
            
            Id := Index;
            Mailbox := new Mailbox_Type(Max_Messages);
            Name := Name_Manager.Next_Name;
            
            Clients(Index).Available := True;
            Clients(Index).Name := Name;
            Clients(Index).Id := Id;
            Clients(Index).Mailbox := Mailbox;
            
        end Register;

        procedure UnRegister(Id : in Natural)
        is
        begin
            Registered_Clients := Registered_Clients - 1;
            Clients(Id).Available := False;
        end UnRegister;
            
        
    end Client_Manager;
    

    
    
end Mail_Help;

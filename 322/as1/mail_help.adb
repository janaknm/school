with Ada.Text_IO; use Ada.Text_IO;

package body Mail_Help is

    procedure ROpen_Or_Create(File : in out File_Type; 
                              File_Name : in String)
    is
    begin
        Open(File, Out_File, File_Name);
    exception
        when Name_Error => Create(File, Out_File, File_Name);
    end ROpen_Or_Create;

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

    function Random_Int(Max : Natural) return Natural is
        Float_Max : Float := Random(Float(Max));
    begin
        return Natural(Float_Max);
    end Random_Int;
        
    
    protected body Post_Office_Type is
        procedure Put(Id : in Mailbox_Id; Message : in Message_Type) is
        begin
            if not Initialized then
                Initialize;
            end if;
            Message_Queue.Enqueue(Mailboxes(Id).Messages, Message);
            Mailboxes(Id).Message_Count := Mailboxes(Id).Message_Count + 1;
        end Put;

        procedure Get(ID : in Mailbox_Id; Message : out Message_Type) is
        begin
            if not Initialized then
                Initialize;
            end if;
            Message_Queue.Dequeue(Mailboxes(ID).Messages, message);
            Mailboxes(Id).Message_Count := Mailboxes(Id).Message_Count - 1;
        end Get;

        procedure Num_Messages(Id: in Mailbox_Id; Num : out Natural) is
        begin
            if not Initialized then
                Initialize;
            end if;
            Num := Mailboxes(Id).Message_Count;
        end Num_Messages;

        procedure Initialize is
        begin
            for I in 1..Max_Mailboxes loop
                Mailboxes(I) := new Mailbox_Type(Max_Messages);
            end loop;
            Initialized := True;
        end Initialize;
        
    end Post_Office_Type;
            
    
    protected body Message_Manager is
        
        procedure Random_Message(Message_String : out Unbounded_String) is
            Index : Positive;
        begin
            if not Initialized then
                Initialize;
            end if;

            Index := 1 + Random_Int(Num_Messages - 1);
            Message_String := Message_Array(Index);

        end Random_Message;

        procedure Initialize is
        begin
           Read_String_Array(Message_Array, Num_Messages, Messages_Filename);
           Initialized := True;

        end Initialize;

    end Message_Manager;

    
    
    protected body Name_Manager is

        procedure Next_Name(Name : out Unbounded_String) 
        is
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
            
        end Next_Name;

        
        procedure Initialize 
        is
        begin
            Read_String_Array(Names, Num_Names, Names_Filename);
            Initialized := True;
        end Initialize;

        procedure Randomize is
            Swap_Index : Positive;
            Swap_Value : Unbounded_String;
        begin

            for I in 1..Num_Names-1 loop
                
                Swap_Index := I + Random_Int(Num_Names - I);
                
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
            
        function Random_Mailbox(My_ID : in Mailbox_Id) return Mailbox_Id is
            Index : Positive;
        begin
            
            -- terribly inefficent way of doing this, but I'd rather
            --  not fight ada and build another data structure
            
            -- get an available index

            if Registered_Clients < 2 then
                return -1;
            end if;
            
            loop
                Index := 1 + Random_Int(Max_Clients - 1);
                exit when Clients(Index).Id /= My_ID and Clients(Index).Available;
            end loop;

            return Clients(Index).Id;
            
        end Random_Mailbox;

        procedure Register(Name : out Unbounded_String;
                           Id : out Mailbox_Id)
        is
            Index : Positive := Next_Index;
        begin
            Registered_Clients := 1 + Registered_Clients;
            
            Id := Index;
            Name_Manager.Next_Name(Name);

            Clients(Index).Available := True;
            Clients(Index).Name := Name;
            Clients(Index).Id := Id;
            
        end Register;

        procedure UnRegister(Id : in Mailbox_Id)
        is
        begin
            Registered_Clients := Registered_Clients - 1;
            Clients(Id).Available := False;
        end UnRegister;
            
        
    end Client_Manager;
    

    
    
end Mail_Help;

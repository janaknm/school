with Ada.Text_Io; use Ada.Text_IO;
with Ada.Strings.Unbounded, Ada.Numerics.Float_Random;
use Ada.Strings.Unbounded, Ada.Numerics.Float_Random;

with Bounded_Queue;

package Mail_Help is
    
    Messages_Filename : constant String := "messages.txt";
    Names_Filename : constant String := "names.txt";

    Mailbox_Empty, Mailbox_Full : exception;

    type Str_Array_Type is array(Positive range <>) of Unbounded_String;
    type Str_Array_Ptr is access Str_Array_Type;

    procedure ROpen_Or_Create(File : in out File_Type; 
                              File_Name : in String);
    
    procedure Read_String_Array(Str_Array : out Str_Array_Ptr;
                                Count : out Natural;
                                Filename : string);
    
    type Message_Type is
       record
           Name : Unbounded_String := To_Unbounded_String("null");
           Message : Unbounded_String := To_Unbounded_String("null");
       end record;

    type Mailbox_Type(Max_Messages : Positive) is limited private; 
    type Mailbox_Ptr is access Mailbox_Type;
    
    type Mailbox_Array is array(Positive range <>) of Mailbox_Ptr;
    subtype Mailbox_Id is Integer range -1..Integer'Last;
    
    protected type Post_Office_Type(Max_Mailboxes : Positive;
                                    Max_Messages : Positive) is
        procedure Put(Id : in Mailbox_Id; Message : in Message_Type);
        procedure Get(Id : in Mailbox_Id; Message : out Message_Type);
        procedure Num_Messages(Id : in Mailbox_Id; Num : out Natural);
        
    private
        procedure Initialize;
        
        Initialized : Boolean := False;
        Mailboxes : Mailbox_Array(1..Max_Mailboxes);
    end Post_Office_Type;
    

    type Client_Element is
           record
               Id : Mailbox_Id;
               Name : Unbounded_String;
               Available : Boolean := False;
           end record;
    type Client_Array is array(Positive range <>) of Client_Element;
    
    protected type Client_Manager(Max_Clients : Positive; 
                                  Max_messages : Positive) is
        
        function Num_Clients return Natural;
        function Random_Mailbox(My_ID : in Mailbox_Id) return Mailbox_Id;
        procedure Register(Name : out Unbounded_String; 
                           ID : out Mailbox_Id);
        procedure UnRegister(Id : in Mailbox_Id);
        
    private
        
        function Next_Index return Positive;
        
        Clients : Client_Array(1..Max_Clients);
        Registered_Clients : Natural := 0;
        
    end Client_Manager;


    
    protected Message_Manager is
        procedure Random_Message(Message_String :out Unbounded_String);
    private
        procedure Initialize;
        
        Message_Array : Str_Array_Ptr;
        Initialized : Boolean := False;
        Num_Messages : Natural := 0;
        
    end Message_Manager;


    protected Name_Manager is
        procedure Next_Name(Name : out Unbounded_String);
    private
        procedure Initialize;
        procedure Randomize;

        Names : Str_Array_Ptr;
        Initialized : Boolean := False;
        Num_Names : Natural := 0;
        Current_Index : Positive := 1;
        Suffix : Natural := 0;
        
    end Name_Manager;

    
    function Random(Max : Float) return Float;
    function Random_Int(Max : Natural) return Natural;
    
private
    package Message_Queue is new Bounded_Queue(Message_Type);
    
    type Mailbox_Type(Max_Messages : Positive) is
       record
           Messages : Message_Queue.Queue_Type(Max_Messages);
           Message_Count : Natural := 0;
       end record;    
    

end Mail_Help;

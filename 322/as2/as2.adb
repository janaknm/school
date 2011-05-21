with Ada.Text_IO; use Ada.Text_IO;
with Ada.Command_Line; use Ada.Command_Line;
with Ada.Numerics.Float_Random; use  Ada.Numerics.Float_Random;
with Vat_Stuff; use Vat_Stuff;

procedure As2 is 
    
    Min_Tick : constant Float := 0.1;
    Max_Tick : constant Float := 0.2;
    Hose_Tick : constant Duration := 0.1;

    Low_Temp : constant Temperature_Type := Min_Temp + (0.2)*(Max_Temp - Min_Temp);
    High_Temp : constant Temperature_Type := Min_Temp + (0.7)*(Max_Temp - Min_Temp);

    Low_Depth : constant Depth_Type := Min_Depth + (0.4)*(Max_Depth - Min_Depth);
    High_Depth : constant Depth_Type := Min_Depth + (0.7)*(Max_Depth - Min_Depth);

    Low_Salinity : constant Salinity_Type := Min_Salinity + (0.2)*(Max_Salinity - Min_Salinity);
    High_Salinity : constant Salinity_Type := Min_Salinity + (0.7)*(Max_Salinity - Min_Salinity);

    Gen : Generator;

    You_Lose : exception;
    
    type Vat_Access is access Vat;
    
    ----
    -- subtypes / ranges / enums
    
    -- number of vats we're working on
    subtype Vat_Range is Natural range 1..Integer'Value(Argument(1));
    type Hose_Type is (Water, Brine);
    
    ----
    -- local operation declarations
    procedure Print_Status(A_Vat : in Vat_Access; Prefix : in String);
    
    ----
    -- task type specifications
    task type Vat_Handler is
        entry Assign_Vat(A_Vat : in Vat_Access; Id : in Positive);
    end Vat_Handler;
    
    ----
    -- array types
    type Handler_Array is array(Vat_Range) of Vat_Handler;
    type Vat_Array is array(Vat_Range) of Vat_Access;
    type Death_Clock is array(Vat_Range) of Float;

    ----
    -- local function definitions
    procedure Print_Status(A_Vat : in Vat_Access; Prefix : in String) is
        Temp : Temperature_Type;
        Depth : Depth_Type;
        Salinity : Salinity_Type;
    begin
        A_Vat.Get_Readings(Temp, Depth, Salinity);
        Put_Line(Prefix & ":::  " &
                   " Temp: " & Temperature_Type'Image(Temp) &
                   " Depth: " & Depth_Type'Image(Depth) &
                   " Salinity: " & Salinity_Type'Image(Salinity));
    end Print_Status;
    
    ----
    -- Create Tasks!
    
    -- create the vat handlers
    Handlers : Handler_Array; 
    
    -- create the vats
    Vats : Vat_Array;

    ----
    -- singleton tasks
    
    -- coordinate the hose between vats
    task Hose_Handler is
        entry Need_Hose(Htype : in Hose_Type; Id : in Positive; Time_Till_Dead : in Float);
    end Hose_Handler;
    
    task body Hose_Handler is
        Min_Time : Float;
        Min_Id : Positive;
        Min_Type : Hose_Type;
    begin
        loop
            -- wait for a request
            accept Need_Hose(Htype : in Hose_Type; Id : in Positive; Time_Till_Dead : in Float) do
                Min_Time := Time_Till_Dead;
                Min_Id := Id;
                Min_Type := Htype;
            end Need_Hose;

            for I in Vat_Range loop
                select
                    accept Need_Hose(Htype : in Hose_Type; Id : in Positive; Time_Till_Dead : in Float) do
                        if Time_Till_Dead < Min_Time then
                            Min_Time := Time_Till_Dead;
                            Min_Id := Id;
                            Min_Type := Htype;
                        end if;
                    end Need_Hose;
                else
                    null;
                end select;
            end loop;

            if Min_Type = Water then
                Vats(Min_Id).Water_On;
                delay Hose_Tick;
                Vats(Min_Id).Water_Off;
            else
                Vats(Min_Id).Brine_On;
                delay Hose_Tick;
                Vats(Min_Id).Brine_Off;
            end if;
            
            
        end loop;
    end Hose_Handler;

    -- print status messages on a timer
    task Vat_Status is
        entry start;
    end Vat_Status;
    
    task body Vat_Status is
        Stopping : Boolean := False;
    begin
        accept Start;
        loop
            for I in Vat_Range loop
                Print_Status(Vats(I), Integer'Image(I));
            end loop;
            New_Line;

            delay 2.0;
        end loop;
    end Vat_Status;
    
    
    
    
    ---
    -- task type definitions
    task body Vat_Handler is
        My_Vat : Vat_Access;
        My_Id : Positive;
        Tick : Float;
        
        Temp, Last_Temp : Temperature_Type;
        Depth, Last_Depth : Depth_Type;
        Salinity, Last_Salinity : Salinity_Type;
        Dtemp, Ddepth, Dsalinity : Float;

        Heat_On, 
        Drain_Open,
        Need_Heat,
        Need_Hose : Boolean := False;

        Htype : Hose_Type;

        Time_Till_Dead, tmp : Float;

    begin
        accept Assign_Vat(A_Vat : in Vat_Access; Id : in Positive) do
            My_Vat := A_Vat;
            My_Id := Id;
        end Assign_Vat;

        -- reset
        My_Vat.Water_Off;
        My_Vat.Brine_Off;
        My_Vat.Heat_Off;
        My_Vat.Drain_Closed;

        -- initial readings
        My_Vat.Get_Readings(Last_Temp, Last_Depth, Last_Salinity);
        
        loop
            -- sleep randomly
            Tick := Min_Tick + Random(Gen)*(Max_Tick - Min_Tick);
            delay Duration(Tick);
            
            -- read de vat
            My_Vat.Get_Readings(Temp, Depth, Salinity);

            -- check if dead
            if (Depth < Min_Depth and then Heat_On) or
              (Depth > Max_Depth) or
              (Temp > Max_Temp) or
              (Temp < Min_Temp) or
              (Salinity > Max_Salinity) or
              (Salinity < Min_Salinity)
            then
                Put_Line("you lose");
                raise You_Lose;
            end if;

            -- open drain if too full, close if in acceptable range
            if Depth < Low_Depth and then Drain_Open then
                My_Vat.Drain_Closed;
                Drain_Open := False;
            elsif Depth > High_Depth and then not Drain_Open then
                My_Vat.Drain_Open;
                Drain_Open := True;
            end if;
            
            -- if under heat threshhold, heat should be on.
            if Temp < Low_Temp then
                Need_Heat := True;
            elsif Temp > High_Temp and Heat_On then
                Need_Heat := False;
            end if;

            -- salinity trumps temperature
            if Salinity > High_Salinity and then Heat_On then
                Need_Heat := False;
            end if;

            -- DONT TURN ON HEAT IF DEPTH TOO LOW
            if Depth < Min_Depth then
              Need_Heat := False;
            end if;

            if Need_Heat and not Heat_On then
                My_Vat.Heat_On;
                Heat_On := True;
            elsif not Need_Heat and Heat_On then
                My_Vat.Heat_Off;
                Heat_On := False;
            end if;
                
            
            -- check if we need the pipe
            if Salinity > High_Salinity then
                Need_Hose := True;
                Htype := Water;
            elsif Salinity < Low_Salinity then
                Need_Hose := True;
                Htype := Brine;
            else
                Need_Hose := False;
            end if;
            
            -- calculate how soon we will die w/o hose
            if Need_hose then
                
                -- get differentials
                Dtemp := (Float(Temp) - Float(Last_Temp)) / tick;
                Ddepth := (Float(Depth) - Float(Last_Depth)) / Tick;
                Dsalinity := (Float(Salinity) - Float(Last_Salinity)) / Tick;

                if Dtemp < 0.0 then
                    Time_Till_Dead := Float(Min_Temp - Temp) / Dtemp;
                else
                    Time_Till_Dead := Float(Max_Temp - Temp) / Dtemp;
                end if;

                if Ddepth < 0.0 then
                    Tmp := Float(Min_Depth - Depth) / Ddepth;
                else
                    Tmp := Float(Max_Depth - Depth) / Ddepth;
                end if;
                
                if Tmp < Time_Till_Dead then
                    Time_Till_Dead := Tmp;
                end if;
                
                if Dsalinity < 0.0 then
                    Tmp := Float(Min_Salinity - Salinity) / Dsalinity;
                else
                    Tmp := Float(Max_Salinity - Salinity) / Dsalinity;
                end if;

                if Tmp < Time_Till_Dead then
                    Time_Till_Dead := Tmp;
                end if;

                Hose_Handler.Need_Hose(Htype, My_Id, Time_Till_Dead);
                    

            end if;
                
            
        end loop;
    end Vat_Handler;

    
begin

    Reset(Gen);

    -- create and assign vats to the helpers
    for I in Vat_Range loop
        Vats(I) := new Vat;
        Handlers(I).Assign_Vat(Vats(I), I);
    end loop;

    Vat_Status.Start;
    
exception
   when You_Lose => 
       Put_Line("You Lost!");
       delay 5.0;
    
end As2;

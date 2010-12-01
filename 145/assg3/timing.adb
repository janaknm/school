with Ada.Real_Time;

package body timing is

    package RT renames Ada.Real_Time;
    use type RT.Time;

    procedure timesort (sort : in sort_func; 
			data : in out array_type;
			ms   : out Float)
    is
	now : RT.Time := RT.Clock;
	after : RT.Time;
	length : Duration;
	a : Integer := 0;
    begin
	delay 0.0;
	sort(data);
	after := RT.Clock;
	length := RT.To_Duration(after - now);
	ms := Float(length);
    end timesort;

end timing;

with Ada.Text_IO;
use Ada.Text_IO;
with Ada.Integer_Text_IO;
use Ada.Integer_Text_IO;

procedure lab4 is

    function sumOfFactors(input : Natural) return Natural is
	sum : Natural;
    begin
	sum := 0;
	for i in 1..(input/2) + 1 loop
	    if input rem i = 0 then
		sum := sum + i;
	    end if;
	end loop;
	return sum;
    end sumOfFactors;

    n,m : Natural;
begin
    put("Enter a number to check for amicable-ness  > ");
    get(n);
    m := sumOfFactors(n);
    put_line(Boolean'Image(n=sumOfFactors(m)) & ", pair value=" & Integer'Image(m));    
end lab4;

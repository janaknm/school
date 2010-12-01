with Ada.Text_IO;
use Ada.Text_IO;
with Ada.Float_Text_IO;
use Ada.Float_Text_IO;
with Expressions;
use Expressions;

procedure assg2 is

    BufferSize : constant Natural := 256;

    cmd : String(1..BufferSize);-- := (Others => ' ');
    last : Natural := 1;
    result : Float;
begin
    put_line("Enter an expression to evaluate. Type quit to quit");
    put("> ");
    get_line(Item => cmd, Last => last);
    while cmd(1..last) /= "quit" loop
	Catch_Invalid_Expression:
	begin
	    result := evalInfixExpr(cmd(1..last));
	    put(result, 0, 0, 0);
	    new_line;
	exception
	    when Invalid_Expression =>
		put_line("Invalid Expression");
	end Catch_Invalid_Expression;
	put("> ");
	get_line(Item => cmd, Last => last);
    end loop;
end assg2;


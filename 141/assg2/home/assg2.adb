--Matt Forbes
--10/11/09
--main program for assignment 2

with ada.text_io;
with ada.text_io.unbounded_io;
with ada.strings.unbounded;
with ada.characters.handling;
with pizzapackage;

procedure assg2 is

    package pp renames pizzapackage;
    package su renames ada.strings.unbounded;
    package t_io renames ada.text_io;
    package u_io renames ada.text_io.unbounded_io;
    package ch renames ada.characters.handling;

    pizzas : pp.PizzaStackPtr;
    command : su.unbounded_string;

begin
    command := su.to_unbounded_string("");

    while su.to_string(command) /= "no" loop

         pp.startPizzaStack(stack => pizzas);
	 pp.bestPizza(stack => pizzas);

	 t_io.skip_line;
    
	 loop
	    t_io.put("Do you want to compare more pizzas? (yes/no)  > ");
	    u_io.get_line(command);
	    command := su.to_unbounded_string(ch.to_lower(su.to_string(command)));
	    exit when su.to_string(command) = "yes" or su.to_string(command) = "no";
	    t_io.put_line("Please enter yes or no.");
	    t_io.new_line;
	end loop;
    end loop;


end assg2;

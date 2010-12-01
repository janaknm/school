--Matt Forbes
--package body of pizzapackage 
--procedures and functions for manipulating pizza records and it's stack
--10/11/2009

with ada.text_io;
with ada.integer_text_io;
with ada.float_text_io;
with ada.numerics; --so we have access to PI
    use ada.numerics;
with robust_io; --my package for robust input of integers and floats
    use robust_io;

package body Pizzapackage is

    package t_io renames ada.text_io;
    package i_io renames ada.integer_text_io;
    package f_io renames ada.float_text_io;
    package shape_io is new t_io.enumeration_io (PizzaShape);

    function getShape (message: string) return PizzaShape is --robust input for enumeration type pizzaShape
	retVal : PizzaShape;
    begin
	loop
	    begin
		t_io.put(message);
		shape_io.get(retVal);
		exit;
	    exception
		when t_io.data_error =>
		    t_io.skip_line;
		    t_io.put_line("That is not a valid shape, try again.");
		    t_io.new_line;
	    end;
	end loop;
	return retVal;
    end getShape;

    procedure startPizzaStack (stack : in out PizzaStackPtr) is --main instruction to program. create an array with prompted size of pizzas
	numPizzas : Integer; --number of pizzas we're going to compare
    begin
	numPizzas := getInt("How many pizzas do you want to compare?  > "); --getInt from robust_io package

	stack := new PizzaStack(1..numPizzas); --use stack as a pointer to a PizzaStack of size numPizzas

	for i in stack'range loop --for every pizza we're comparing gather information
	    t_io.put("Pizza ");
	    i_io.put(Item => i, width => 1);
	    t_io.put_line(" Information:");
	    stack(i) := getPizza; --getPizza will go through each attribute and robustly gather information
	    t_io.new_line;
	end loop;
    end startPizzaStack;

    function getPizza return Pizza is --get each attribute of a Pizza record
	newPizza : Pizza; --pizza that we're creating
    begin 
	newPizza.shape := getShape("Shape (Round, Square, Oval)  > "); --robust function to get shape from user

	case newPizza.shape is --depending on the shape of the pizza, we need different information
	    when Round =>
		newPizza.size1 := getFloat("Diameter  > ");
	    when Square =>
		newPizza.size1 := getFloat("Side Length  > ");
	    when Oval =>
		newPizza.size1 := getFloat("Radius 1  > ");
		newPizza.size2 := getFloat("Radius 2  > ");
	end case;

	newPizza.price := getFloat("Price  > "); 

	calcArea(newPizza);
	calcPricePerUnit(newPizza);

	t_io.new_line;

	t_io.put("Area is ");
	f_io.put(Item => newPizza.area, fore => 0, aft => 2, exp => 0);
	t_io.put_line(" square inches.");
	
	t_io.put("Price per square inch is $");
	f_io.put(Item => newPizza.pricePerUnit, fore => 0, aft => 2, exp => 0);
	t_io.put_line(".");	    

	return newPizza;
    end getPizza;
    
    procedure calcArea (Item : in out Pizza) is --calculate the area of Item(pizza) and store the answer in it's area attribute
    begin
	case Item.shape is --different area formulas for different shapes
	    when Round =>
		Item.area := PI * (Item.size1 / 2.0) ** 2;
	    when Square =>
		Item.area := Item.size1 ** 2;
	    when Oval =>
		Item.area := PI * Item.size1 * Item.size2 / 4.0;
	end case;
    end calcArea;

    procedure calcPricePerUnit (Item : in out Pizza) is --calculate price per square inch and store it in Item(pizza)
    begin
	begin
	    Item.PricePerUnit := Item.price / Item.area;
	exception
	    when constraint_error => --i don't know why i put this here its useless
		t_io.put("constraint error");
	end;
    end calcPricePerUnit;

    procedure bestPizza (stack : in PizzaStackPtr) is --for a given stack of pizzas, figure out which is the best
	bestPizzaIndex : Integer; --the index in the stack that has the best price
	bestPizzaPrice : Float; --temp variable used in comparing
    begin
	bestPizzaIndex := 0; --initialize to 0
	bestPizzaPrice := Float'last; --initialize to highest value so any other value will be lower
	
	for i in stack'range loop
	    if stack(i).pricePerUnit < bestPizzaPrice then --if this is lower than the previously lowest value, 
		bestPizzaIndex := i; --then this is the new pizza and we want it's index
		bestPizzaPrice := stack(i).pricePerUnit; --and it's price in case another pizza is lower
	    end if;
	end loop;

	t_io.put("The best pizza is number "); --tell them which one was the best
	i_io.put(Item => bestPizzaIndex, width => 1); 
	t_io.put(" with a price per square inch of $");
	f_io.put(Item => bestPizzaPrice, fore => 0, aft => 2, exp => 0);
	t_io.put(". ");

	pizzaDescription(stack(bestPizzaIndex)); --describe the pizza they should buy
	    
    end bestPizza;

    procedure pizzaDescription(Item : Pizza) is --simple description of any given pizza
    begin
	t_io.put("It is a ");
	shape_io.put(Item => Item.shape, set => t_io.lower_case);
	t_io.put(" pizza with ");

	case Item.shape is
	    when round =>
		t_io.put("a diameter of ");
		f_io.put(Item => Item.size1, aft => 2, fore => 0, exp => 0);
		t_io.put(" inches and costs $");
	    when square =>
		t_io.put("side lengths of ");
		f_io.put(Item => Item.size1, aft => 2, fore => 0, exp => 0);
		t_io.put(" inches and costs $");
	    when oval =>
		t_io.put("one radius of ");
		f_io.put(Item => Item.size1, aft => 2, fore => 0, exp => 0);
		t_io.put(" inches and a second radius of ");
		f_io.put(Item => Item.size2, aft => 2, fore => 0, exp => 0);
		t_io.put(" inches and costs $");
	end case;
	
	f_io.put(Item => Item.price, aft => 2, fore => 0, exp => 0);
	t_io.put_line(".");

    end pizzaDescription;

end Pizzapackage;
	

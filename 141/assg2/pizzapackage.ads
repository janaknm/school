--Matt Forbes
--Assignment 2 package specification file
--create the pizza record and procedures to manipulate them

--PizzasHolder: holds an array of pizzas and can manipulate them.

with ada.text_io;

package Pizzapackage is

    type PizzaShape is (Round, Square, Elliptical);

    type Pizza is 
    record
	shape : PizzaShape;
	size1 : Float;
	size2 : Float;
	price : Float;
    end record;
	

   -- type PizzaHolder is tagged record

end Pizzapackage;
	

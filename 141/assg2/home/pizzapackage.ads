--Matt Forbes
--Assignment 2 package specification file
--create the pizza record and procedures to manipulate them

--PizzasHolder: holds an array of pizzas and can manipulate them.

package Pizzapackage is

    subtype PosFloat is Float range 0.0..Float'last; --values only make sense when positive

    type PizzaShape is (Round, Square, Oval); --enumeration type for holding shapes

    type Pizza is  --record to keep track of all the attributes a pizza has
    record
	shape : PizzaShape;
	size1 : PosFloat;
	size2 : PosFloat;
	price : PosFloat;
	area : PosFloat;
	PricePerUnit : PosFloat;
    end record;

    type PizzaStack is array(Integer range <>) of Pizza; --an array to hold all the pizzas we're comparing
    type PizzaStackPtr is access PizzaStack; --because the array is indefinite we have to use a pointer to access it
    
    function getPizza return Pizza; --prompt user for information about pizza and return a Pizza record
    
    procedure startPizzaStack (stack : in out PizzaStackPtr); --basically INIT, creates the array of pizzas
    procedure calcArea (Item : in out Pizza); --calcuate area of the pizza and stores area in the record
    procedure calcPricePerUnit (Item : in out Pizza); --calculates price per squarer inch and stores it in the record
    procedure bestPizza (stack : in PizzaStackPtr); --loop through an array of pizzas and decide which is best
    procedure pizzaDescription (Item : in Pizza); --output information about a certain pizza

end Pizzapackage;
	

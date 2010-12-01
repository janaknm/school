package oo is

    type Point is record
	x, y : Integer;
    end record;

    type shape is tagged
	record
	    pos : Point;
	end record;
    function area(s : in shape) return Float;
    function perimeter(s : in shape) return Float;
    procedure draw(s : in shape);

    type triangle is new shape with 
	record
	    base : Float;
	    height : Float;
	end record;
    function area(t : in triangle) return Float;
    function perimeter(t : in triangle) return Float;
    procedure draw(t : in triangle);

    type rectangle is new shape with
	record
	    width : Float;
	    height : Float;
	end record;
    function area(r : in rectangle) return Float;
    function perimeter(r : in rectangle) return Float;
    procedure draw(r : in rectangle);

    type square is new rectangle with null record;

    procedure calculate(s : in shape'class); --accepts any of the derived types
    procedure boxy(b : in rectangle'class); --accepts rectangle or square

end oo;

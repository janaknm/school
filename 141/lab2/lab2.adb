--Matt Forbes
--Lab2 resistor translator


with ada.text_io;
with ada.integer_text_io;

procedure Lab2 is

	--new enumeration type to hold colors
	type color is (black, brown, red, orange, yellow, green, blue, violet, grey, white);
	type huge is delta 1.0 range 0.0 .. 999_999.0e10;

	package T_IO renames ada.text_io;
	package COLOR_IO is New T_IO.enumeration_io (color);

	--globals declaration
	x, n : Integer; --input for x^n
	r : huge; --return value

	function getNumbersFromColors(numColors : Integer) return Integer is
		inStr : String(1..numColors);
		tempColor : color;
	begin
		for i in 1..numColors loop
			T_IO.put("Enter Color ");
			COLOR_IO.get(Item => tempColor);
			inStr(i) := Integer'Image(color'pos(tempColor))(2);
		end loop;
		return Integer'Value(inStr(1..numColors));
	end getNumbersFromColors;

begin
	x := getNumbersFromColors(3);
	n := getNumbersFromColors(1);
	r := x * huge(10 ** n);

	T_IO.put(huge'image(r));


end Lab2;



--playing with unconstrained types

with ada.text_io;
with ada.float_text_io;

procedure uncType is

    type unconstrainedType is array(Integer range <>) of Float;
    type unconstrainedTypeAccess is access unconstrainedType;

    arrayAccess1 : unconstrainedTypeAccess;

    function getNumberArray(numItems : Integer) return unconstrainedTypeAccess is
	returnArray : unconstrainedTypeAccess;
    begin
	returnArray := new unconstrainedType(1..numItems);

	for i in 1..numItems loop
	    returnArray(i) := float(i);
	end loop;

	return returnArray;
    end getNumberArray;

begin

    arrayAccess1 := getNumberArray(3);

    for i in arrayAccess1'range loop
	ada.float_text_io.put(Item => arrayAccess1(i), aft => 1, fore => 0, exp => 0);
	ada.text_io.new_line;
    end loop;

end uncType;

--convert integer to fixed point

with ada.text_io;
with ada.integer_text_io;

procedure fp is

	type huge is delta 1.0 range 0.0 .. 999_999.0e10;

	package t_io renames ada.text_io;
	package i_io renames ada.integer_text_io;

	i : Integer;
	h : huge;

	function hugeToPower( i : Integer ) return huge is
	begin	return huge(10**i);
	end hugeToPower;

begin
	
	h := 5 * hugeToPower(2);
	t_io.put(huge'image(h));

end fp;

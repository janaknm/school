with ada.text_io;
with ada.command_line;
with ada.strings.fixed;
with ada.integer_text_io;

procedure fixedcmd is

    package t_io renames ada.text_io;
    package i_io renames ada.integer_text_io;
    package cl renames ada.command_line;
    package s renames ada.strings;
    package sf renames ada.strings.fixed;

    x : string:= cl.argument (1);

begin
    t_io.put("argument 1 =");
    t_io.put(x);
    t_io.put(", range=");
    i_io.put(item => cl.argument(1)'last, width => 1);
    t_io.new_line;

    sf.move(
	source => cl.argument(2),
	target => x,
	drop => s.right,
	justify => s.left,
	pad => s.space);

    t_io.put("argument 2 =");
    t_io.put(x(1..cl.argument(2)'last));
    t_io.put(", range=");
    i_io.put(item => cl.argument(2)'last, width => 1);
    t_io.new_line;


end fixedcmd;

with ada.text_io;
with ada.command_line;
with ada.strings.unbounded;

procedure unboundedcmd is
    
    package t_io renames ada.text_io;
    package cl renames ada.command_line;
    package su renames ada.strings.unbounded;

    x : su.unbounded_string := su.to_unbounded_string(cl.argument(1));

begin

    t_io.put("argument 1=");
    t_io.put(su.to_string(x));
    t_io.put(", last=");
    t_io.put(integer'image(su.to_string(x)'last));
    t_io.new_line;

    x := su.to_unbounded_string(cl.argument(2));

    t_io.put("argument 2=");
    t_io.put(su.to_string(x));
    t_io.put(", last=");
    t_io.put(integer'image(su.to_string(x)'last));

end unboundedcmd;

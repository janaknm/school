with ada.text_io;
with ada.text_io.unbounded_io;
with ada.strings;
with ada.strings.fixed;
with ada.strings.unbounded;

procedure fixedtest is
    
    package t_io renames ada.text_io;
    package u_io renames ada.text_io.unbounded_io;
    package s renames ada.strings;
    package sf renames ada.strings.fixed;
    package su renames ada.strings.unbounded;

    stringBuffer : su.unbounded_string;
    string1 : String(1..6);
    size : Integer;

begin
    
    u_io.get_line(Item => stringBuffer);
    string1 := su.to_string(stringBuffer)(1..6);
    t_io.put(string1);



end fixedtest;



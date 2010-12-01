with m_io;
with ada.strings.unbounded;

procedure testit is
    
    package su renames ada.strings.unbounded;

    myInt : Integer;
    myFloat : Float;
    myString : String(1..5);
    myUnboundedString : su.unbounded_string;

begin

    myInt := m_io.getInt;
    myFloat := m_io.getFloat;
    myString := m_io.getString(5).all;
    myUnboundedString := m_io.getUnboundedString;

end testit;

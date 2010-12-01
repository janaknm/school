--package to convert standard ada.text_io procedures into functions

with ada.strings.unbounded;

package m_io is
    
    type StringPtr is access String;

    function getInt return Integer;
    function getFloat return Float;
    function getString(size : Positive) return StringPtr;
    function getUnboundedString return ada.strings.unbounded.unbounded_string;

end m_io;

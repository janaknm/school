with ada.text_io;
with ada.float_text_io;
with ada.integer_text_io;
with ada.strings.unbounded;

package robust_io is
    
    package t_io renames ada.text_io;
    package i_io renames ada.integer_text_io;
    package f_io renames ada.float_text_io;
    package su renames ada.strings.unbounded;

    procedure handleError(message : string); --for handling exceptions errors

    function getInt(message : string) return Integer; --robustly get an integer with message as prompt
    function getFloat(message :string) return Float; --""   "" but with float

end robust_io;

package lab7_helper is

    type IntArray is array(Integer range <>) of Integer;
    
    function get_size_of_file(fileName : String) return Natural;
    procedure get_ints_from_file(fileName : in String; data : out IntArray);
    procedure put_ints_to_file(fileName : in String; data : in IntArray);
    

end lab7_helper;

package math is

    type numArray is array(Integer range <>) of Float;
    type numArrayPtr is access numArray;

    function getNumArray(needed : in Integer) return numArrayPtr;

    procedure add(needed : Integer);
    procedure subtract(needed : Integer);
    procedure multiply(needed : Integer );
    procedure divide(needed : in Integer);

end math;

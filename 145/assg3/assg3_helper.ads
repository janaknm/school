with Ada.Text_IO;	    use Ada.Text_IO;
with Ada.Numerics.Discrete_Random;
with sorting;
package assg3_helper is
    
    subtype intRange is Integer range 0..100;
    package intRandom is new Ada.Numerics.Discrete_Random(intRange);
	use intRandom;


    type Obscure is
	record
	    ID : Natural;
	    Field1 : String(1..4) := "Matt";
	    Field2 : Float := 3.14159;
	end record;
        
    type IntArray is array(Integer range <>) of Integer;
    type FloatArray is array(Integer range <>) of Float;
    type ObscureArray is array(Integer range <>) of Obscure;

    type int_sort is access procedure (data : in out IntArray);
    type float_sort is access procedure (data : in out FloatArray);
    type obscure_sort is access procedure (data : in out ObscureArray);

    function getKey(n : in Integer; element : in Integer) return Integer;
    function getKey(n : in Integer; element : in Float) return Integer;
    function getKey(n : in Integer; element : in Obscure) return Integer;

    function numKeys(element : Integer) return Natural;
    function numKeys(element : Float) return Natural;
    function numKeys(element : Obscure) return Natural;

    function ">"(left, right : Obscure) return Boolean;
    function "<"(left, right : Obscure) return Boolean;

    procedure makeRandom(data : in out IntArray); 
    procedure makeRandom(data : in out FloatArray); 
    procedure makeRandom(data : in out ObscureArray); 

    procedure print(file : File_Type; element : Integer);
    procedure print(file : File_Type; element : Float);
    procedure print(file : File_Type; element : Obscure);

    generic
	type Element_t is private;
	type Array_t is array(Integer range <>) of Element_t;
	with procedure print(file : File_Type; element : Element_t) is <>;
    procedure printArr(file : File_Type; data : in Array_t);

    procedure open_or_create(file : in out File_Type; mode : in File_Mode; filename : in String);
    procedure get_size_of_ints(file : in out File_Type; size : out Natural);
    procedure get_ints_from_file(file : in File_Type; data : out IntArray);

    procedure int_counting_sort is new
	sorting.counting_sort(Integer, IntArray);
    procedure int_counting_sort_from_key is new
	sorting.counting_sort_from_key(Integer, Integer, IntArray, getKey, numKeys);
    procedure int_bucket_sort is new
	sorting.bucket_sort(Integer, IntArray);
    procedure int_bucket_sort_from_key is new
	sorting.bucket_sort_from_key(Integer, Integer, IntArray, getKey, numKeys);
    procedure int_radix_counting_sort is new
	sorting.radix_sort(Integer, IntArray, numKeys, int_counting_sort_from_key);
    procedure int_radix_bucket_sort is new
	sorting.radix_sort(Integer, IntArray, numKeys, int_bucket_sort_from_key);

    procedure float_counting_sort_from_key is new
	sorting.counting_sort_from_key(float, Integer, floatArray, getKey, numKeys);
    procedure float_bucket_sort_from_key is new
	sorting.counting_sort_from_key(float, Integer, floatArray, getKey, numKeys);
    procedure float_radix_counting_sort is new
	sorting.radix_sort(float, floatArray, numKeys, float_counting_sort_from_key);
    procedure float_radix_bucket_sort is new
	sorting.radix_sort(float, floatArray, numKeys, float_bucket_sort_from_key);

    procedure obscure_counting_sort_from_key is new
	sorting.counting_sort_from_key(obscure, Integer, obscureArray, getKey, numKeys);
    procedure obscure_bucket_sort_from_key is new
	sorting.counting_sort_from_key(obscure, Integer, obscureArray, getKey, numKeys);
    procedure obscure_radix_counting_sort is new
	sorting.radix_sort(obscure, obscureArray, numKeys, obscure_counting_sort_from_key);
    procedure obscure_radix_bucket_sort is new
	sorting.radix_sort(obscure, obscureArray, numKeys, obscure_bucket_sort_from_key);


end assg3_helper;

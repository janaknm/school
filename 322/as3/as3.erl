% Matt Forbes
% 322 Concurrency
% June 2011

% encrypt returns encrypted value the given filename with the given key
% decrypt decrypts the file

-module(as3).
-import(lists, [flatten/1, reverse/1, split/2, filter/2]).
-import(string, [to_upper/1, to_lower/1]).
-import(paramap, [pmap/2]).
-export([encrypt/2, decrypt/2]).


% utilites
is_upper(C) ->
    (C >= $A) and (C =< $Z).

is_alpha(C) when C >= $a, C =< $z -> true;
is_alpha(C) when C >= $A, C =< $Z -> true;
is_alpha(_) -> false.

letter_position(C) ->
    case is_upper(C) of
        true -> 
            C - $A;
        false ->
            C - $a
    end.

% shift a character in the alphabet either forward or backword
% depending on encryption mode
shift_by_key(C, Key, Mode) ->
    Shifts = letter_position(Key),
    case Mode of
        encrypt -> $a + ( (letter_position(C) + Shifts) rem 26);
        decrypt -> 
            Offset = letter_position(C) - Shifts,
            if
                Offset >= 0 -> $a + Offset;
                true -> $z + Offset + 1
            end
    end.

% split a string into sublists of length N
split_n(N, List) ->
    split_n_h(N, List, []).

% tail-recursive helper for split_n
split_n_h(N, List, Acc) 
  when length(List) < N ->
    reverse([List | Acc]);
split_n_h(N, List, Acc) ->
    {Str, Rest} = split(N, List),
    split_n_h(N, Rest, [Str | Acc]).
                

% applies vigenere encryption to a single string of length less or
% equal to the length of the key
single_vigenere(Str, Key, Mode) ->
    single_vigenere_h(Str, Key, Mode, []).

% tail recursive helper for single_vigenere
single_vigenere_h([], _, _, Acc) -> reverse(Acc);
single_vigenere_h([C | Tail], [Key | Key_Tail], Mode, Acc) ->
    Shifted = shift_by_key(C, Key, Mode),
    single_vigenere_h(Tail, Key_Tail, Mode, [Shifted | Acc]).

% applies vigenere encryption or decryption to the file located at
% file_path. reads the file in to a string and strips all
% non-alphabetic characters, then breaks the resulting string in to
% substrings of length(Key). Finally, calling single_vigenere on each
% substring and flattening the list. returns nil when file not found. 
vigenere(File_Path, Key, Mode) ->
    {Status, File} = file:read_file(File_Path),
    if 
        Status == ok ->
            File_Str = filter(fun is_alpha/1, binary_to_list(File)),
            Result = flatten(pmap(fun(Str) ->
                                          single_vigenere(Str, Key, Mode)
                                  end, 
                                  split_n(length(Key), File_Str))),
            case Mode of
                encrypt -> to_upper(Result);
                decrypt -> to_lower(Result)
            end;
        
        true -> nil
    end.

encrypt(File_Path, Key) ->
    vigenere(File_Path, Key, encrypt).

decrypt(File_Path, Key) ->
    vigenere(File_Path, Key, decrypt).



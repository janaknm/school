with Ada.Float_Text_IO;
use Ada.Float_Text_IO;
with Ada.text_io;
use ada.text_io;

package body Expressions is

    function isOperator(input : Character) return Boolean is
    begin
	return input = '-' or
	       input = '+' or
	       input = '/' or
	       input = '*' or
	       input = '(' or
	       input = ')';
    end isOperator;

    function ">"(left, right : token) return Boolean is
	opL, opR : Natural;
	function getVal(c : in Character) return Natural is
	begin
	    case c is
		when '/' | '*' => return 2;
		when '-' | '+' => return 1;
		when others => return 0;
	    end case;
	end getVal;
    begin
	opL := getVal(left.buffer(1));
	opR := getVal(right.buffer(1));
	return opL > opR;
    end ">";

    function tokenize(input : String) return tokenCollection is
	allTokens : tokenCollection;
	newToken : token;
	lastCursor, cursor : Natural;
	readingNumber : Boolean;

	--to reduce code bloat, group these lines that are repeated into a procedure
	--which simply adds a token to the collection given indices
	procedure addToken(first, last : Natural; tokenKind : tokenType) is
	    len : Natural;
	begin
	    len := last - first;
	    newToken.length := len;
	    newToken.buffer(1..len) := input(first..last-1);
	    newToken.tokenKind := tokenKind;
	    enqueue(allTokens, newToken);
	end addToken;

    begin

	cursor := 1;
	lastCursor := 1;
	readingNumber := true;
	allTokens := new_queue;

	--while we haven't hit the end of the string, and we haven't exceeded the number of tokens we can store
	while cursor < input'last+1 loop
	    --if we hit an operator, we have two cases
	    --we were reading a number. capture that number and push it
	    --we just read a different operator. simply add the new operator
	    if isOperator(input(cursor)) then
		if readingNumber then
		    readingNumber := false;
		    addToken(lastCursor, cursor, value);
		end if;
		addToken(cursor, cursor+1, operator);
		lastCursor := cursor+1;
	    --if we hit a space we have two cases
	    --we were reading a number: capture it and push it
	    --we read another space before it. skip it and keep track of the new last cursor positition
	    elsif input(cursor) = ' ' then
		if readingNumber then
		    readingNumber := false;
		    addToken(lastCursor, cursor, value);
		end if;
		lastCursor := cursor + 1;
	    else
		--if the thing we just read was not an operator or a space, we are reading a number/variable
		readingNumber := true;
	    end if;
	    --always increment the cursor
	    cursor := cursor + 1;
	end loop;
	return allTokens;
    end tokenize;

    procedure testTokens is
	a : tokenCollection := tokenize("1 + 3 * ( 2  + 1)");
	t : token;
    begin
	for i in 1..size(a) loop
	    t := dequeue(a);
	    put_line(t.buffer(1..t.length));
	end loop;
    end testTokens;
    
    function evalRPNExpr(input : tokenCollection) return Float is
    begin
	return 0.0;
    end evalRPNExpr;


    function evalRPNExpr(input : String) return Float is
    begin
	return evalRPNExpr(tokenize(input));
    end evalRPNExpr;
        
    function infixToRPN(input : tokenCollection) return tokenCollection is
	allTokens : tokenCollection;
	tmpTokens : tokenStack;
	curToken : token;
    begin
	allTokens := new_queue;
	tmpTokens := new_stack;
	for i in 1..size(input) loop

	    --curToken is the next token in the queue
	    curToken := dequeue(input);
	    
	    --curToken can be an operator or not. handle both cases
	    if curToken.tokenKind = operator then
		
		--handle cases for ( and ) and others
		case curToken.buffer(1) is
		    when '(' =>  
			--push onto tmpTokens
			push(tmpTokens, curToken);

		    when ')' => 
			--pop tmpTokens until ( popped. we have an error if we hit the end of the stack before that happens
			loop
			    if(empty(tmpTokens)) then
				raise Invalid_Expression;
			    end if;

			    --reusing curToken
			    curToken := pop(tmpTokens);

			    --if curToken is ( then we can just exit and do nothing with it
			    exit when curToken.buffer(1) = '(';

			    --if its anything else, put it on the queue
			    enqueue(allTokens, curToken);
			end loop;

		    when others =>
			--for any other operator
			--if tmpTokens is empty OR if curToken has a higher priority than top(tmpTokens) push token on stack
			loop
			    if(empty(tmpTokens) or curToken > top(tmpTokens) ) then
				push(tmpTokens, curToken);
				exit;
			    else
				enqueue(allTokens, pop(tmpTokens));
			    end if;
			end loop;
		end case;

	    else
		--if it's not an operator, just put it on the queue
		enqueue(allTokens, curToken);
	    end if;
	end loop;
	
	--we have reached the end of the expression. pop the rest of the stack and put it on the queue
	loop
	    exit when empty(tmpTokens);
	    enqueue(allTokens, pop(tmpTokens));
	end loop;
	    
	return allTokens;
    end infixToRPN;

    function evalInfixExpr(input : tokenCollection) return Float is
    begin
	return evalRPNExpr(infixToRPN(input));
    end evalInfixExpr;


    function evalInfixExpr(input : String) return Float is
    begin
	return evalInfixExpr(tokenize(input));
    end evalInfixExpr;

    
end Expressions;
   

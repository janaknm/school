--Matt Forbes
--Feb 4, 2010
--Package to evaluate both RPN and infix expressions using the standard operators -,+,/,*,(,)
with Generic_Stack;
with Generic_Queue;

package Expressions is
    Invalid_Expression : exception;
    
    --will evaluate an expression if it is in RPN format. 
    function evalRPNExpr(input : String) return Float;

    --will evaluate an expression if it is in infix notation. 
    function evalInfixExpr(input : String) return Float;

private
    --maximum number of tokens to evaluate
    MaxToken : constant Natural := 256;
    --max token length, no more than 15 digits/characters per token
    MaxTokenLen : constant Natural := 15;
    --tokenStr is a way to represent a token
    subtype tokenStr is String(1..MaxTokenLen);
    --token is a record that holds a tokenStr, length, and type of that tokenStr
    type tokenType is (operator, value);
    type token is 
	record
	    buffer : tokenStr;
	    length : Natural;
	    tokenKind : tokenType;
	end record;
    
    package pTokenStack is new Generic_Stack(token);
    package pFloatStack is new Generic_Stack(Float);
    package pTokenQueue is new Generic_Queue(token);
    use pTokenStack;
    use pTokenQueue;
    use pFloatStack;
    subtype tokenCollection is pTokenQueue.queuePtr;
    subtype tokenStack is pTokenStack.stackPtr;
    subtype floatStack is pFloatStack.stackPtr;

  end Expressions;

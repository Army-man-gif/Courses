{- 
Concrete syntax
A video on this section can be found here.
Here is a grammar for our language, written in BNF, where expressions with lower numbers describe operators with lower precedence.
The grammar is ambiguous regarding else. We resolve the ambiguity by associating else's to the closest if's to the left.
-}
Program ::= Identifier := Expr;
          | { [Program] }
          | while (Expr) Program
          | if (Expr) Program
          | if (Expr) Program else Program

Expr  ::= Expr1 | Expr1 OrOp   Expr
Expr1 ::= Expr2 | Expr2 AndOp  Expr1
Expr2 ::= Expr3 | Expr3 EqOp   Expr2
Expr3 ::= Expr4 | Expr4 CompOp Expr3
Expr4 ::= Expr5 | Expr5 AddOp  Expr4
Expr5 ::= Expr6 | Expr6 MulOp  Expr5
Expr6 ::= Expr7 | NotOp Expr6
Expr7 ::= Constant | Identifier | (Expr)

OrOp   ::=  ||
AndOp  ::=  &&
EqOp   ::=  ==
CompOp ::=  <=  |  <  |  >=  |  >
AddOp  ::=  +   |  -
MulOp  ::=  *   |  /  |  %
NotOp  ::=  !

{- 
We will use monadic parsing (please read chapter 13 of the book) to convert from concrete syntax to abstract syntax.
-}

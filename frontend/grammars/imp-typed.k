// Copyright (c) 2014-2016 K Team. All Rights Reserved.

module IMP-SYNTAX
  imports PREDEF
  syntax AExp  ::= Int | Id
                 | AExp "/" AExp              [left, strict, symbol(div)]
                 > AExp "+" AExp              [left, strict, symbol(plus)]
                 | "(" AExp ")"               [bracket, symbol(aExpBracket)]
  syntax BExp  ::= Bool
                 | AExp "<=" AExp             [seqstrict, symbol(lte)]
                 | "!" BExp                   [strict, symbol(not)]
                 > BExp "&&" BExp             [left, strict(1), symbol(and)]
                 | "(" BExp ")"               [bracket, symbol(bExpBracket)]
  syntax Block ::= "{" "}"                    [symbol(emptyBlock)]
                 | "{" Stmt "}"               [symbol(block)]
  syntax Stmt  ::= Block
                 | Id "=" AExp ";"            [strict(2), symbol(assignment)]
                 | "if" "(" BExp ")"
                   Block "else" Block         [strict(1), symbol(if)]
                 | "while" "(" BExp ")" Block [symbol(while)]
                 > Stmt Stmt                  [left, symbol(consStmt)]
  syntax Pgm ::= "int" Ids ";" Stmt           [symbol(program)]
  syntax Ids ::= ".Ids"      [symbol(emptyIds)]
               | Id "," Ids  [symbol(consIds)]
endmodule


module IMP
  imports IMP-SYNTAX
  syntax KResult ::= Int | Bool

  configuration <T color="yellow">
                  <k color="green"> $PGM:Pgm </k>
                  <state color="red"> .Map </state>
                </T>

// AExp
  rule <k> X:Id => I:Int ...</k> <state>... X:Id |-> I:Int ...</state>
  rule I1:Int / I2:Int => I1:Int /Int I2:Int  requires I2:Int =/=Int 0
  rule I1:Int + I2:Int => I1:Int +Int I2:Int
// BExp
  rule I1:Int <= I2:Int => I1:Int <=Int I2:Int
  rule ! T:Bool => notBool T:Bool
  rule true && B:BExp => B:BExp
  rule false && _:BExp => false
// Block
  rule {} => .   [structural]
  rule {S:Stmt} => S:Stmt  [structural]
// Stmt
  rule <k> X:Id = I:Int; => . ...</k> <state>... X:Id |-> (_:Int => I:Int) ...</state>
  rule S1:Stmt S2:Stmt => S1:Stmt ~> S2:Stmt  [structural]
  rule if (true)  S:Block else _:Block => S:Block
  rule if (false) _:Block else S:Block => S:Block
  rule while (B:BExp) S:Block => if (B:BExp) {S:Block while (B:BExp) S:Block} else {}  [structural]
// Pgm
  rule <k> int (X:Id,Xs:Ids => Xs:Ids);_:Stmt </k> <state> Rho:Map (.Map => X:Id|->0) </state>
    requires notBool (X:Id in_keys(Rho:Map))
  rule int .Ids; S:Stmt => S:Stmt  [structural]

// verification ids
  syntax Id ::= "n"     [token]
              | "sum"   [token]
endmodule


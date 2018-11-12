// parsing a configuration and printing KORE

module PREDEF
  syntax Id
  syntax Bool
  syntax Int
  syntax K
  syntax KResult
  syntax Map
  syntax KBott
  syntax Set
  syntax KVariable
  syntax Layout ::= r"(/\\*([^\\*]|(\\*+([^\\*/])))*\\*+/|//[^\n\r]*|[\\ \n\r\t])*"

  // kapp
  syntax K ::= K "=>" K [symbol(rewrites)]
  syntax K ::= K "~>" K [symbol(kSequence)]
  syntax K ::= "(" K ")" [symbol(bracket)]
  syntax KBott ::= KVariable // [symbol(inj)]
  syntax KVariable ::= r"[A-Z][A-Za-z0-9'_]*|_" [token]
  syntax K ::= KBott // [symbol(inj)]
  syntax K ::= "." [symbol(dotK)]
  
  syntax K ::= K "requires" K [symbol(kRequires)]

  // Map  
  syntax Map ::= K "|->" K [symbol(mapElement)]
  syntax Map ::= Map Map [symbol(consMap)]
  syntax Map ::= "(" Map ")" [symbol(bracket)]
  syntax Map ::= ".Map" [symbol(emptyMap)]
  
  // Int
  syntax Int ::= Int "+Int" Int [symbol(plusInt)]
  syntax Int ::= Int "/Int" Int [symbol(divInt)]
  syntax Int ::= Int "<=Int" Int [symbol(lteInt)]
  syntax Int ::= Int "=/=Int" Int [symbol(neInt)]
  syntax Int ::= r"[0-9]+" [token]
  
  // Bool
  syntax Bool ::= "true" [symbol(boolTrue)]
  syntax Bool ::= "false" [symbol(boolFalse)]
  syntax Bool ::= Bool "&&" Bool [symbol(boolAnd)]
  syntax Bool ::= "notBool" Bool [symbol(notBool)]
  
  // Set
  syntax Bool ::= K "in_keys" "(" Map ")" [symbol(inKeys)]
  

endmodule

module KCELLS
  imports PREDEF

  syntax Cell
  syntax Bag ::= Bag Bag  [left, assoc, symbol(consCells), unit(#cells)]
               | ".Bag"   [symbol(emptyCells)]
               | Cell // [symbol(inj)]
  syntax K ::= Bag // [symbol(inj)]
  syntax Bag ::= KBott // [symbol(inj)]
endmodule

module RULE-CELLS
  imports KCELLS
  syntax OptionalDots ::= "..." [symbol(dots)]
                        | ""    [symbol(noDots)]

  // should be automatically generated:
  syntax Cell ::= "<T>" OptionalDots K OptionalDots "</top>" [symbol(tCell)]
  syntax Cell ::= "<k>" OptionalDots K OptionalDots "</k>" [symbol(kCell)]
  syntax Cell ::= "<state>" OptionalDots K OptionalDots "</state>" [symbol(stateCell)]

endmodule

module IMP-SYNTAX // mostly untouched
  imports PREDEF
  syntax AExp  ::= Int // [symbol(inj)] | Id // [symbol(inj)]
                 | AExp "/" AExp              [left, strict, symbol(div)]
                 > AExp "+" AExp              [left, strict, symbol(plus)]
                 | "(" AExp ")"               [symbol(bracket)]
  syntax BExp  ::= Bool // [symbol(inj)]
                 | AExp "<=" AExp             [seqstrict, symbol(lte)]
                 | "!" BExp                   [strict, symbol(not)]
                 > BExp "&&" BExp             [left, strict(1), symbol(and)]
                 | "(" BExp ")"               [symbol(bracket)]
  syntax Block ::= "{" "}"                    [symbol(emptyBlock)]
                 | "{" Stmt "}"               [symbol(block)]
  syntax Stmt  ::= Block // [symbol(inj)]
                 | Id "=" AExp ";"            [strict(2), symbol(assignment)]
                 | "if" "(" BExp ")"
                   Block "else" Block         [strict(1), symbol(if)]
                 | "while" "(" BExp ")" Block [symbol(while)]
                 > Stmt Stmt                  [left, symbol(consStmt)]
  syntax Pgm ::= "int" Ids ";" Stmt           [symbol(program)]
  syntax Ids ::= ".Ids"      [symbol(emptyIds)]
               | Id "," Ids  [symbol(consIds)]
endmodule

module GENERATED
  imports IMP-SYNTAX
  imports RULE-CELLS

  // subsort diamond
  syntax K ::= Map // [symbol(inj)]
  syntax Map ::= KBott // [symbol(inj)]

  // casts
  syntax Int  ::= Int  ":Int"  [symbol(cast2Int)]
  syntax Id   ::= Id   ":Id"   [symbol(cast2Id)]
  syntax Stmt ::= Stmt ":Stmt" [symbol(cast2Stmt)]
  syntax Map  ::= Map  ":Map"  [symbol(cast2Map)]
  syntax Block::= Block":Block"[symbol(cast2Block)]
  syntax BExp ::= BExp ":BExp" [symbol(cast2BExp)]
  syntax Bool ::= Bool ":Bool" [symbol(cast2Bool)]
  syntax Ids  ::= Ids  ":Ids"  [symbol(cast2Ids)]

  syntax K ::= Pgm // [symbol(inj)]
  syntax Pgm ::= KBott // [symbol(inj)]
  syntax Pgm ::= Pgm "=>" Pgm [symbol(rewrites)]

  syntax Id ::= KBott // [symbol(inj)]
  syntax K ::= Id // [symbol(inj)]
  syntax Id ::= Id "=>" Id [symbol(rewrites)]

  syntax Int ::= KBott // [symbol(inj)]
  syntax K ::= Int // [symbol(inj)]
  syntax Int ::= Int "=>" Int [symbol(rewrites)]

  syntax Bool ::= KBott // [symbol(inj)]
  syntax K ::= Bool // [symbol(inj)]
  syntax Bool ::= Bool "=>" Bool [symbol(rewrites)]
  syntax Bool ::= "(" Bool ")" [symbol(bracket)]
  
  syntax Stmt ::= KBott // [symbol(inj)]
  syntax K ::= Stmt // [symbol(inj)]
  syntax Stmt ::= Stmt "=>" Stmt [symbol(rewrites)]
  
  syntax AExp ::= KBott // [symbol(inj)]
  syntax K ::= AExp // [symbol(inj)]
  syntax AExp ::= AExp "=>" AExp [symbol(rewrites)]

  syntax BExp ::= KBott // [symbol(inj)]
  syntax K ::= BExp // [symbol(inj)]
  syntax BExp ::= BExp "=>" BExp [symbol(rewrites)]
  
  syntax Block ::= KBott // [symbol(inj)]
  syntax K ::= Block // [symbol(inj)]
  syntax Block ::= Block "=>" Block [symbol(rewrites)]

  syntax Ids ::= KBott // [symbol(inj)]
  syntax K ::= Ids // [symbol(inj)]
  syntax Ids ::= Ids "=>" Ids [symbol(rewrites)]
  syntax Ids ::= "(" Ids ")" [symbol(bracket)]


endmodule

module IMP-RULES-GRAMMAR
  imports IMP-SYNTAX
  imports RULE-CELLS
  imports GENERATED

  syntax priorities 
        cast2Int cast2Id cast2Stmt cast2Map cast2Block cast2BExp cast2BExp cast2Bool cast2Ids
      > plus plusInt div divInt lte lteInt and consStmt if notBool boolAnd consIds program
      > kSequence
      > rewrites
      > kRequires

endmodule


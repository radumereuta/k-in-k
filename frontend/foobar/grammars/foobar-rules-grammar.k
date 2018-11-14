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

module FOO
  imports PREDEF
  syntax Foo ::= "bar" [klabel(bar), function]
               | "buzz" [klabel(buzz)]
endmodule

module GENERATED
  imports RULE-CELLS
  imports FOO

  // subsort diamond
  syntax K ::= Map // [symbol(inj)]
  syntax Map ::= KBott // [symbol(inj)]

  // casts
  syntax Foo  ::= Foo  ":Foo"  [symbol(cast2Foo)]

  syntax K ::= Foo // [symbol(inj)]
  syntax Foo ::= KBott // [symbol(inj)]
  syntax Foo ::= Foo "=>" Foo [symbol(rewrites)]

endmodule

module FOOBAR-RULES-GRAMMAR
  imports RULE-CELLS
  imports GENERATED

  syntax priorities 
        cast2Foo
      > kSequence
      > rewrites
      > kRequires

endmodule


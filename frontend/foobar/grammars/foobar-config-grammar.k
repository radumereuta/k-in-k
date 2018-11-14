// parsing a configuration and printing KORE

module PREDEF
  syntax Id
  syntax Bool
  syntax Int
  syntax K
  syntax KResult
  syntax Map
  syntax KBott
  syntax KVariable
  syntax Layout ::= r"(/\\*([^\\*]|(\\*+([^\\*/])))*\\*+/|//[^\n\r]*|[\\ \n\r\t])*"

  syntax Map ::= ".Map" [symbol(emptyMap)]
  syntax KBott ::= KVariable [symbol(inj)]
  syntax KVariable ::= r"$[A-Z][A-Za-z0-9'_]*|_" [token]
  syntax KString ::= r"[\\\"](([^\\\"\n\r\\\\])|([\\\\][nrtf\\\"\\\\])|([\\\\][x][0-9a-fA-F]{2})|([\\\\][u][0-9a-fA-F]{4})|([\\\\][U][0-9a-fA-F]{8}))*[\\\"]"      [token]
endmodule

module KCELLS
  imports PREDEF

  syntax Cell
  syntax Bag ::= Bag Bag  [left, assoc, symbol(consCells), unit(#cells)]
               | ".Bag"   [symbol(emptyCells)]
               | Cell [symbol(inj)]
  syntax K ::= Bag [symbol(inj)]
  syntax Bag ::= KBott [symbol(inj)]
endmodule

module CONFIG-CELLS
  imports KCELLS
  syntax CellName ::= r"[a-zA-Z][a-zA-Z0-9\\-]*"  [token, prec(1)]

  syntax Cell ::= "<" CellName CellProperties ">" K "</" CellName ">" [symbol(configCell)]
  syntax Cell ::= "<" CellName "/>" [symbol(externalCell)]

  syntax CellName ::= r"[a-zA-Z][a-zA-Z0-9\\-]*"  [token, prec(1)]
  syntax CellProperties ::= CellProperty CellProperties [klabel(cellPropertyList)]
                          | ""                          [klabel(cellPropertyListTerminator)]
  syntax CellProperty ::= CellName "=" KString          [klabel(cellProperty)]
endmodule

module FOO // mostly untouched
  imports PREDEF
  syntax Foo ::= "bar" [klabel(bar), function]
               | "buzz" [klabel(buzz)]
endmodule

module GENERATED
  imports IMP-SYNTAX
  imports CONFIG-CELLS

  // subsort diamond
  syntax K ::= Map // [symbol(inj)]
  syntax Map ::= KBott // [symbol(inj)]

  // casts
  syntax Foo  ::= Foo  ":Foo"  [symbol(cast2Foo)]

  syntax K ::= Foo // [symbol(inj)]
  syntax Foo ::= KBott // [symbol(inj)]


endmodule

module FOOBAR-CONFIG-GRAMMAR
  imports IMP-SYNTAX
  imports CONFIG-CELLS
  imports GENERATED

endmodule


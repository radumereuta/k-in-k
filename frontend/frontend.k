module COMMONS
  syntax Any

endmodule

module FRONTEND-SYNTAX
  imports COMMONS 
  syntax Any ::= r"([\\n\\r]|.)*" [token]
endmodule

module FRONTEND
  imports COMMONS
  imports K-IO

  syntax Bubble
  syntax Contents  ::= "dummy1" Bubble   [klabel(noAttrs)] // just so I can introduce the klabels
  syntax Contents  ::= "dummy1" Bubble   [klabel(attrs)]
  syntax KSentence ::= "dummy2" Contents [klabel(kRule)]
  syntax KSentence ::= "dummy2" Contents [klabel(kConfiguration)]

  configuration <k> $PGM:Any </k>
  // frontend pipeline
  rule S:Any => #parseString("k-light2k5.sh grammars/outer-k.k KDefinition", S)
  // TODO1: dynamically generate configuration parser - for now written by hand
  rule kConfiguration(noAttrs(S:Bubble)) => kConfiguration(noAttrs(#parseString("k-light2k5.sh grammars/imp-config-grammar.k K", S))) [anywhere]
  // TODO2: dynamically generate rule parser - for now written by hand
  rule kRule(noAttrs(S:Bubble)) => kRule(noAttrs(#parseString("k-light2k5.sh grammars/imp-rules-grammar.k K", S))) [anywhere]
  rule kRule(attrs(S:Bubble, At)) => kRule(attrs(#parseString("k-light2k5.sh grammars/imp-rules-grammar.k K", S), At)) [anywhere]


  // disambiguation rules for rules. These should be used only for disambiguation in the front end
  syntax KItem ::= amb(K, K) [klabel(amb)]
  syntax KItem ::= "bottom" [klabel(bottom)]

  rule amb(X, bottom) => X [anywhere]
  rule amb(bottom, X) => X [anywhere]
  rule amb(X, X) => X [anywhere]
  // for brevity, priority disambiguation rules are handled natively by the parser in imp-rules-grammar.k

endmodule


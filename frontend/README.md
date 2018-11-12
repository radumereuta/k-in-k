frontend.k file should simulate the parsing steps fround in the frontend of K

1. use outer parser to parse the given file and extract the syntax declarations and configuration and rules as bubbles
2. generate a configuration parser (TODO - for now written by hand for IMP)
3. parse the configuration bubbles
4. extract information about cell labels and generate a rule parser (TODO - for now written by hand for IMP)
5. parse the rule bubbles and disambiguate (TODO: for now most of the disambiguation is done natively by the parser. Also variable type inference is not implemented. Expecting all variable occurances to be typed)

All of this is simulated in K5 by running:

`kompile frontend.k --backend java` // modified to accept `#parseString` with two arguments: a string containing a path to execute an external parser, and a token containing the string to parse.

`krun grammars/imp-typed.k --output kast` // returns the complete AST of the given K definition

Ignored details

- parsing rules or the configuration is not possible without the predefined sorts and productions from kast.k and domains.k. These are integrated in the hand written grammars. The final AST doesn't contain references to those. Only the file given as input.
- `#parseString` takes an external path to execute and expectes a K5 AST. There is no connection with the K5 parser since it is limited in parsing power.
- parsing errors in k-light (the external parser) are returned as an AST node: `parseError(#token("input string", "Input"), #token("stdout string", "Stdout"), #token("stderr string", "Stderr"))`.

Requirements:

K5

K-light


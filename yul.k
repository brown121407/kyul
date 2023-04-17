/*
Copyright 2023 Alexandru-Sergiu Marton

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program. If not, see <https://www.gnu.org/licenses/>.
*/

module YUL-SYNTAX
    imports BOOL
    imports UNSIGNED-INT-SYNTAX

    syntax Block ::= "{" Statement "}" | "{" "}"
    // FIXME: The parses is too dumb to work with List{Statement, ""}, and this stuff is
    // only mentioned in passing in a comment at https://kframework.org/k-distribution/pl-tutorial/2_languages/1_simple/1_untyped/simple-untyped/
    // syntax Statements ::= List{Statement, ""}
    syntax Statement ::= Block
                       | FunctionDefinition
                       | VariableDeclaration
                       | Assignment
                       | If
                       | Expression
                       | Switch
                       | ForLoop
                       | "break"
                       | "continue"
                       | "leave"
                       | Statement Statement [left]

    syntax FunctionDefinition ::= "function" Identifier "(" TypedIdentifierList ")" Block
                                 | "function" Identifier "(" TypedIdentifierList ")" "->" TypedIdentifierNeList Block
    syntax VariableDeclaration ::= "let" TypedIdentifierNeList
                                 | "let" TypedIdentifierNeList ":=" Expression
    syntax Assignment ::= IdentifierNeList ":=" Expression      [strict(2)]
    syntax Expression ::= FunctionCall
                        | Identifier
                        | Literal
    syntax If ::= "if" Expression Block
    syntax Switch ::= "switch" Expression Cases
                    | "switch" Expression Cases Default
                    | "switch" Expression Default
    syntax Cases ::= NeList{Case, ""}
    syntax Case ::= "case" Literal Block
    syntax Default ::= "default" Block
    syntax ForLoop ::= "for" Block Expression Block Block
    syntax FunctionCall ::= Identifier "(" FunctionArgs ")"     [strict(2)]
    syntax FunctionArgs ::= List{Expression, ","}               [strict]
    // FIXME: Find a way to add $ to the start of identifiers without messing up the builtin $PGM variable.
    syntax Identifier ::= r"[a-zA-Z_][a-zA-Z_$0-9.]*"           [token]
    syntax IdentifierNeList ::= NeList{Identifier, ","}
    syntax TypeName ::= Identifier
    syntax TypedIdentifier ::= Identifier
                         // TODO: Enable typed identifiers
                         //     | Identifier ":" TypeName
    syntax TypedIdentifierList ::= List{TypedIdentifier, ","}
    syntax TypedIdentifierNeList ::= NeList{TypedIdentifier, ","}

    syntax LiteralUntyped ::= NumberLiteral
                        | StringLiteral
                        | TrueLiteral
                        | FalseLiteral
    syntax Literal ::= LiteralUntyped
                     | LiteralUntyped ":" TypeName

    syntax NumberLiteral ::= HexNumber | DecimalNumber
    syntax StringLiteral ::= r"[\\\"]([^\\\"\\r\\n\\\\]|\\\\.)*[\\\"]"                  [token]
    syntax TrueLiteral ::= "true"
    syntax FalseLiteral ::= "false"
    syntax HexNumber ::= r"0x[0-9a-fA-F]+"                                              [token]
    syntax DecimalNumber ::= Int

    syntax Object ::= "object" StringLiteral "{" Code ObjectOrDataList "}"
    syntax ObjectOrDataList ::= List{ObjectOrData, ""}
    syntax ObjectOrData ::= Object | Data
    syntax Code ::= "code" Block
    syntax Data ::= "data" StringLiteral HexLiteral
                  | "data" StringLiteral StringLiteral
    syntax HexLiteral ::= r"hex([\\\"]([0-9a-fA-F]{2})*[\\\"]|'([0-9a-fA-F]{2})*')"     [token]

    // TODO: Object | Block
    syntax Pgm ::= Block
endmodule

module YUL
    imports MAP
    imports LIST
    imports INT
    imports YUL-SYNTAX

    syntax KResult ::= Int
    syntax KItem ::= #envRestore(Map)
                   | #start()
                   | #save(Identifier, Int)

    configuration <T>
        <k> #start() ~> $PGM:Pgm </k>
        <env> .Map </env>
        <store> .Map </store>
        <to-filter> . </to-filter>
        <filtered> .List </filtered>
        <eval-result> . </eval-result>
    </T>

    // Desugaring
    rule for { S:Statement } COND:Expression POST:Block BODY:Block => S ~> for { } COND POST BODY   [structural]

    // Execution
    rule <k> #start() ~> { } => . </k>
    rule <k> #start() ~> { S:Statement } => . </k>
         <to-filter> . => S </to-filter>

    rule <k> { } => . </k>
    rule <k> { S:Statement } => . </k>
         <to-filter> . => S </to-filter>
         <filtered> .List => ListItem(#envRestore(ENV)) ... </filtered>
         <env> ENV </env>                                               [priority(0)]
    rule <k> . => S </k>
         <to-filter> . </to-filter>
         <filtered> ListItem(S) => .List ... </filtered>
    rule <k> let ID , IDS:TypedIdentifierNeList => #save(ID, 0) ~> let IDS </k>
    rule <k> let .TypedIdentifierNeList => . </k>
    rule <k> #save(ID, VAL:Int) => . ... </k>
         <to-filter> . </to-filter>
         <env> ENV => ENV[ID <- !L:Int] </env>
         <store> ... .Map => !L |-> VAL ... </store>
    rule <k> #envRestore(ENV) => . ... </k>
         <to-filter> . </to-filter>
         <env> _ => ENV </env>

    // Function hoisting
    rule <to-filter> REST:Statement S:Statement => REST </to-filter>        
         <filtered> .List => ListItem(S) ... </filtered>                
        when notBool isFunctionDefinition(S)                            [priority(0)]
    rule <to-filter> S:Statement => . </to-filter>                      
         <filtered> .List => ListItem(S) ... </filtered>
        when notBool isFunctionDefinition(S)

    // TODO: Save FunctionDefinition in env/store
    rule <to-filter> REST:Statement _:FunctionDefinition => REST </to-filter>
    rule <to-filter> _:FunctionDefinition => . </to-filter>
endmodule
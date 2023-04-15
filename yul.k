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
    imports STRING-SYNTAX
    imports INT-SYNTAX
    imports ID-SYNTAX

    syntax Block ::= "{" Statement "}" | "{" "}"
    // FIXME: The parses is too dumb to work with List{Statement, ""}, and this shit is
    // only mentioned in passing in a comment at https://kframework.org/k-distribution/pl-tutorial/2_languages/1_simple/1_untyped/simple-untyped/
    // syntax Statements ::= List{Statement, ""}
    syntax Statement ::= Block
                       | FunctionDeclaration
                       | VariableDeclaration
                       | Assignment
                       | If
                       | Expression
                       | Switch
                       | ForLoop
                       | BreakContinue
                       | Leave
                       | Statement Statement [right]

    syntax FunctionDeclaration ::= "function" Identifier "(" TypedIdentifierList ")" Block
                                 | "function" Identifier "(" TypedIdentifierList ")" "->" TypedIdentifierNeList Block
    syntax VariableDeclaration ::= "let" TypedIdentifierNeList
                                 | "let" TypedIdentifierNeList ":=" Expression
    syntax Assignment ::= IdentifierList ":=" Expression
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
    syntax BreakContinue ::= "break" | "continue"
    syntax Leave ::= "leave"
    syntax FunctionCall ::= Identifier "(" FunctionArgs ")"
    syntax FunctionArgs ::= List{Expression, ","}
    syntax IdentifierList ::= NeList{Identifier, ","}
    syntax TypeName ::= Identifier
    syntax TypedIdentifier ::= Identifier
                             | Identifier ":" TypeName
    syntax TypedIdentifierList ::= List{TypedIdentifier, ","}
    syntax TypedIdentifierNeList ::= NeList{TypedIdentifier, ","}

    syntax LiteralVal ::= NumberLiteral
                        | StringLiteral
                        | TrueLiteral
                        | FalseLiteral
    syntax Literal ::= LiteralVal
                     | LiteralVal ":" TypeName

    syntax NumberLiteral ::= HexNumber | DecimalNumber
    syntax HexNumber ::= "0xTODO" // TODO
    syntax DecimalNumber ::= Int // TODO
    syntax TrueLiteral ::= "true"
    syntax FalseLiteral ::= "false"
    syntax Identifier ::= Id // TODO
    syntax StringLiteral ::= String // TODO
    syntax HexLiteral ::= "0xTODO" // TODO

    syntax Object ::= "object" StringLiteral "{" Code ObjectOrDataList "}"
    syntax ObjectOrDataList ::= List{ObjectOrData, ""}
    syntax ObjectOrData ::= Object | Data
    syntax Code ::= "code" Block
    syntax Data ::= "data" StringLiteral HexLiteral
                  | "data" StringLiteral StringLiteral

    syntax Pgm ::= Object | Block
endmodule

module YUL
    imports MAP
    imports LIST
    imports YUL-SYNTAX

    rule object _ { code { S:Statement } ODLIST:ObjectOrDataList } => S ~> ODLIST
    rule .ObjectOrDataList => .
    rule <k> { } => . ... </k>
    rule <k> { S } => S </k>
    rule <k> S0:Statement S1:Statement => S0 ~> S1 ... </k>
    rule <k> function ID ( PARAMS ) BODY => . ... </k>
        <funcs> FS => FS [ ID <- function ID ( PARAMS ) BODY ] </funcs>
    rule <k> S:Statement => . ... </k>
        <block-statements> ... .List => ListItem(S) </block-statements>

    syntax KItem ::= #foobar(K)
    configuration <T>
        // <k> $PGM:Pgm </k>
        <k></k>
        <funcs> .Map </funcs>
        // TODO: Make this a map of lists to handle nested blocks
        <block-statements> .List </block-statements>
    </T>
endmodule
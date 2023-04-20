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
    imports STRING-SYNTAX

    syntax Block ::= "{" Statement "}" | "{" "}"            [klabel("Block"), symbol]
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
                       | "#debug"
                       | Statement Statement [left]

    syntax FunctionDefinition ::= "function" Identifier "(" TypedIdentifierList ")" Block
                                 | "function" Identifier "(" TypedIdentifierList ")" "->" TypedIdentifierNeList Block
    syntax VariableDeclaration ::= "let" TypedIdentifierNeList
                                 | "let" TypedIdentifierNeList ":=" Expression
    syntax Assignment ::= IdentifierNeList ":=" Expression
    syntax Expression ::= FunctionCall
                        | Identifier
                        | Literal                               
    syntax If ::= "if" Expression Block                         [strict(1)]
    syntax Switch ::= "switch" Expression Cases
                    | "switch" Expression Cases Default
                    | "switch" Expression Default
    syntax Cases ::= NeList{Case, ""}
    syntax Case ::= "case" Literal Block
    syntax Default ::= "default" Block
    syntax ForLoop ::= "for" Block Expression Block Block
    syntax FunctionCall ::= Identifier "(" Expressions ")" 
    syntax Expressions ::= List{Expression, ","}    // FunctionArgs
    // syntax FunctionArgs ::= List{Expression, ","}

    // FIXME: Find a way to add $ to the start of identifiers without messing up the builtin $PGM variable.
    syntax Identifier ::= "stop"                                 [token]
                        | "add"                                  [token]
                        | "sub"                                  [token]
                        | "mul"                                  [token]
                        | "div"                                  [token]
                        | "sdiv"                                 [token]
                        | "mod"                                  [token]
                        | "smod"                                 [token]
                        | "exp"                                  [token]
                        | "not"                                  [token]
                        | "lt"                                   [token]
                        | "gt"                                   [token]
                        | "slt"                                  [token]
                        | "sgt"                                  [token]
                        | "eq"                                   [token]
                        | "iszero"                               [token]
                        | "and"                                  [token]
                        | "or"                                   [token]
                        | "xor"                                  [token]
                        | "byte"                                 [token]
                        | "shl"                                  [token]
                        | "shr"                                  [token]
                        | "sar"                                  [token]
                        | "addmod"                               [token]
                        | "mulmod"                               [token]
                        | "signextend"                           [token]
                        | "keccak256"                            [token]
                        | "pc"                                   [token]
                        | "pop"                                  [token]
                        | "mload"                                [token]
                        | "mstore"                               [token]
                        | "mstore8"                              [token]
                        | "sload"                                [token]
                        | "sstore"                               [token]
                        | "msize"                                [token]
                        | "gas"                                  [token]
                        | "address"                              [token]
                        | "balance"                              [token]
                        | "selfbalance"                          [token]
                        | "caller"                               [token]
                        | "callvalue"                            [token]
                        | "calldataload"                         [token]
                        | "calldatasize"                         [token]
                        | "calldatacopy"                         [token]
                        | "codesize"                             [token]
                        | "codecopy"                             [token]
                        | "extcodesize"                          [token]
                        | "extcodecopy"                          [token]
                        | "returndatasize"                       [token]
                        | "returndatacopy"                       [token]
                        | "extcodehash"                          [token]
                        | "create"                               [token]
                        | "create2"                              [token]
                        | "call"                                 [token]
                        | "callcode"                             [token]
                        | "delegatecall"                         [token]
                        | "staticcall"                           [token]
                        | "return"                               [token]
                        | "revert"                               [token]
                        | "selfdestruct"                         [token]
                        | "invalid"                              [token]
                        | "log0"                                 [token]
                        | "log1"                                 [token]
                        | "log2"                                 [token]
                        | "log3"                                 [token]
                        | "log4"                                 [token]
                        | "chainid"                              [token]
                        | "basefee"                              [token]
                        | "origin"                               [token]
                        | "gasprice"                             [token]
                        | "blockhash"                            [token]
                        | "coinbase"                             [token]
                        | "timestamp"                            [token]
                        | "number"                               [token]
                        | "difficulty"                           [token]
                        | "prevrandao"                           [token]
                        | "gaslimit"                             [token]
                        | r"[a-zA-Z_][a-zA-Z_$0-9.]*"            [token]
    syntax IdentifierNeList ::= NeList{Identifier, ","}
    syntax TypeName ::= "u256"  // The only type available in the EVM dialect.
    syntax TypedIdentifier ::= Identifier
                             | Identifier ":" TypeName
    syntax TypedIdentifierList ::= List{TypedIdentifier, ","}
    syntax TypedIdentifierNeList ::= NeList{TypedIdentifier, ","}

    syntax LiteralUntyped ::= NumberLiteral
                        | StringLiteral
                        | TrueLiteral
                        | FalseLiteral
    syntax Literal ::= LiteralUntyped
                     | LiteralUntyped ":" TypeName

    syntax NumberLiteral ::= HexNumber | DecimalNumber
    syntax StringLiteral ::= String
    // TODO: Solve the issue with the regex below. It makes using config attributes impossible:
    // [Error] Inner Parser: Parse error: unexpected token '"*"' following token '='.
    //     Source(/mnt/c/Users/brown/Code/kyul/yul.k)
    //     Location(112,31,112,34)
    //     112 |               <foo multiplicity="*" type="Map"></foo>
    // syntax StringLiteral ::= r"[\\\"]([^\\\"\\r\\n\\\\]|\\\\.)*[\\\"]"                  [token]
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

    syntax Pgm ::= Object | Block
endmodule

module YUL
    imports MAP
    imports LIST
    imports INT
    imports YUL-SYNTAX

    syntax KResult ::= Int
                     | Multi
    syntax KItem ::= #envRestore(Map, Map)
                   | "#start"
                   | "#funcEnd"
                   | #letBind(Identifier, Expression)   [strict(2)]
                   | #bind(Identifier, Expression)      [strict(2)]
                   | #functionCall(Identifier) 
                   | #evalArg(RealStuff)                [strict]
                   | #hoist(FunctionDefinition)
                   | #realStuff(RealStuff)
    syntax RealStuff ::= Expression
                       | Multi
    syntax Multi ::= #multi(Expressions)
    syntax RealVariableDeclaration ::= "#let" TypedIdentifierNeList
                                     | "#let" TypedIdentifierNeList ":=" "#realStuff" "(" RealStuff ")"             [strict(2)]
    syntax RealAssignment ::= "#assign" IdentifierNeList ":=" "#realStuff" "(" RealStuff ")"                      [strict(2)]

    configuration <T>
        <k> #start ~> $PGM:Pgm </k>
        <env>
            <vars> .Map </vars>
            <funcs> .Map </funcs>
            <reserved> .Map </reserved>
        </env>
        <store> .Map </store>
        <evaluation>
            <fn-args> . </fn-args>
            <hoisting>
                <to-filter> . </to-filter>
                <filtered> .List </filtered>
            </hoisting>
            <return> .List </return>
        </evaluation>
    </T>

    // Execution
    rule <k> #start ~> { } => . </k>

    rule <k> #start ~> { S:Statement } => . </k>
         <to-filter> . => S </to-filter>

    rule <k> { } => . ... </k>

    rule <k> { S:Statement } => . ... </k>
         <to-filter> . => S </to-filter>
         <filtered> .List => ListItem(#envRestore(VARS, FUNCS)) ... </filtered>
         <vars> VARS </vars>
         <funcs> FUNCS </funcs>                                         [priority(0)]

    rule <k> . => S ... </k>
         <to-filter> . </to-filter>
         <filtered> ... ListItem(S) => .List </filtered>                [priority(0)]

    rule <k> ID:Identifier => VAL ... </k>
         <vars> ... ID |-> L ... </vars> 
         <store> ... L |-> VAL:Int ... </store>
         <to-filter> . </to-filter>


    rule <k> let IDS => #let IDS ... </k>
         <to-filter> . </to-filter>

    rule <k> let IDS := E => #let IDS := #realStuff(E) ... </k>
         <to-filter> . </to-filter>

    rule <k> IDS := E => #assign IDS := #realStuff(E) ... </k>
         <to-filter> . </to-filter>


    rule <k> #let ID:Identifier : _:TypeName, IDS:TypedIdentifierNeList => #let ID, IDS ... </k>
         <to-filter> . </to-filter>

    rule <k> #let ID , IDS:TypedIdentifierNeList => #letBind(ID, 0) ~> #let IDS ... </k>
         <to-filter> . </to-filter>

    rule <k> #let .TypedIdentifierNeList => . ... </k>
         <to-filter> . </to-filter>


    rule <k> #let ID:Identifier : _:TypeName, IDS:TypedIdentifierNeList := #realStuff(RS) => #let ID, IDS := #realStuff(RS) ... </k>
         <to-filter> . </to-filter>

    rule <k> #let ID , IDS:TypedIdentifierNeList := #realStuff(#multi(E:Expression, REST)) => #letBind(ID, E) ~> #let IDS := #realStuff(#multi(REST)) ... </k>
         <to-filter> . </to-filter>

    rule <k> #let .TypedIdentifierNeList := #realStuff(#multi(.Expressions)) => . ... </k>
         <to-filter> . </to-filter>

    rule <k> #let ID , .TypedIdentifierNeList := #realStuff(E:Expression) => #letBind(ID, E) ... </k>
         <to-filter> . </to-filter>


    rule <k> #assign ID, IDS:IdentifierNeList := #realStuff(#multi(E:Expression, REST)) => #bind(ID, E) ~> #assign IDS := #realStuff(#multi(REST)) ... </k>
         <to-filter> . </to-filter>

    rule <k> #assign .IdentifierNeList := #realStuff(#multi(.Expressions)) => . ... </k>
         <to-filter> . </to-filter>

    rule <k> #assign ID, .IdentifierNeList := #realStuff(E:Expression) => #bind(ID, E) ... </k>
         <to-filter> . </to-filter> 


    rule <k> #letBind(ID, VAL:Int) => . ... </k>
         <vars> VARS:Map => VARS[ID <- !L:Int] </vars>
         <store> ... .Map => !L |-> VAL ... </store>  
         <funcs> FUNCS </funcs>      
         <to-filter> . </to-filter>
        when (notBool (ID in_keys(VARS))) andBool (notBool (ID in_keys(FUNCS)))

    rule <k> #bind(ID, VAL:Int) => . ... </k>
         <vars> ... ID |-> L ... </vars>
         <store> STORE => STORE[L <- VAL] </store>
         <to-filter> . </to-filter>

    // TODO: Do I need to use <to-filter> . </to-filter> everywhere??
    rule <k> #envRestore(VARS, FUNCS) => . ... </k>
         <vars> _ => VARS </vars>
         <funcs> _ => FUNCS </funcs>
         <to-filter> . </to-filter>

    rule <k> leave ~> #funcEnd => #funcEnd ... </k>
         <to-filter> . </to-filter>                                         [priority(51), structural]
    rule <k> leave ~> _:KItem => leave ... </k>
         <to-filter> . </to-filter>                                         [priority(52), structural]

    // If
    rule <k> if 0 _ => . ... </k>
         <to-filter> . </to-filter>
    rule <k> if _ BLOCK => BLOCK ... </k>
         <to-filter> . </to-filter>         [owise]

    // For
    rule <k> for { S } COND POST BODY => { S for { } COND POST BODY } ... </k>
         <to-filter> . </to-filter>                                                             [structural]
    rule <k> for { } COND POST BODY => if COND { BODY POST for { } COND POST BODY } ... </k>
         <to-filter> . </to-filter>                                                             [structural]
    

    // Function execution
    rule <k> FUN:Identifier ( ARGS:Expressions ) => ARGS ~> #functionCall(FUN) ... </k>
         <fn-args> K => .Expressions ~> K </fn-args>
         <to-filter> . </to-filter>

    // Arguments are evaluated from right to left.
    rule <k> ARG:Expression , ARGS:Expressions => ARGS ~> #evalArg(ARG) ... </k>
         <to-filter> . </to-filter>

    rule <k> .Expressions => . ... </k>
         <to-filter> . </to-filter>
    
    rule <k> #evalArg(#multi(ARG:Expression, .Expressions)) => . ... </k>
         <fn-args> ARGS:Expressions => ARG, ARGS ... </fn-args>
         <to-filter> . </to-filter>

    rule <k> #evalArg(ARG:Expression) => . ... </k>
         <fn-args> ARGS:Expressions => ARG, ARGS ... </fn-args>
         <to-filter> . </to-filter>

    // TODO: Check if these need to wrap around.
    rule <k> #functionCall(stop) ~> _ => . </k>
         <fn-args> .Expressions => . ... </fn-args>
         <to-filter> . </to-filter>
    rule <k> #functionCall(add) => I1 +Int I2 ... </k>
         <fn-args> I1:Int, I2:Int => . ... </fn-args>
         <to-filter> . </to-filter>
    rule <k> #functionCall(sub) => I1 -Int I2 ... </k>
         <fn-args> I1:Int, I2:Int => . ... </fn-args>
         <to-filter> . </to-filter>
    rule <k> #functionCall(mul) => I1 *Int I2 ... </k>
         <fn-args> I1:Int, I2:Int => . ... </fn-args>
         <to-filter> . </to-filter>
    rule <k> #functionCall(div) => I1 /Int I2 ... </k>
         <fn-args> I1:Int, I2:Int => . ... </fn-args>
         <to-filter> . </to-filter>
    // TODO: sdiv
    rule <k> #functionCall(mod) => I1 %Int I2 ... </k>
         <fn-args> I1:Int, I2:Int => . ... </fn-args>
         <to-filter> . </to-filter>
    // TODO: smod
    // TODO: exp
    // TODO: not
    rule <k> #functionCall(lt) => 1 ... </k>
         <fn-args> I1:Int, I2:Int => . ... </fn-args>
         <to-filter> . </to-filter>
        when I1 <Int I2
    rule <k> #functionCall(lt) => 0 ... </k>
         <fn-args> _:Int, _:Int => . ... </fn-args>
         <to-filter> . </to-filter>                         [owise]
    rule <k> #functionCall(gt) => 1 ... </k>
         <fn-args> I1:Int, I2:Int => . ... </fn-args>
         <to-filter> . </to-filter>
        when I1 >Int I2
    rule <k> #functionCall(gt) => 0 ... </k>
         <fn-args> _:Int, _:Int => . ... </fn-args>
         <to-filter> . </to-filter>                         [owise]
    // TODO: slt
    // TODO: sgt
    rule <k> #functionCall(eq) => 1 ... </k>
         <fn-args> I1:Int, I2:Int => . ... </fn-args>
         <to-filter> . </to-filter>
        when I1 ==Int I2
    rule <k> #functionCall(eq) => 0 ... </k>
         <fn-args> _:Int, _:Int => . ... </fn-args>   
         <to-filter> . </to-filter>                         [owise]
    rule <k> #functionCall(iszero) => 1 ... </k>
         <fn-args> I:Int, .Expressions => . ... </fn-args>
         <to-filter> . </to-filter>
        when I ==Int 0
    rule <k> #functionCall(iszero) => 0 ... </k>
         <fn-args> _:Int, .Expressions => . ... </fn-args>
         <to-filter> . </to-filter>                         [owise]

    // TODO: Shadowing is disallowed, i.e. you cannot declare an identifier at a point where another identifier with the same name is 
    // also visible, even if it is not possible to reference it because it was declared outside the current function.
    syntax KItem ::= #toReturn(TypedIdentifierNeList)
                   | #evalReturn(Expression)            [strict]
                   | "#fetchReturns"
                   | #argBind(TypedIdentifierList, Expressions)
                   | #prepareUserFunc(TypedIdentifierList, Expressions, Block, TypedIdentifierNeList)


    rule <k> #functionCall(ID:Identifier) => #prepareUserFunc(PARAMS, ARGS, BODY, .TypedIdentifierNeList) ... </k>
         <fn-args> ARGS:Expressions => . ... </fn-args>
         <funcs> ... ID |-> L ... </funcs>
         <store> ... L |-> (function ID ( PARAMS ) BODY) ... </store>
         <to-filter> . </to-filter>

    rule <k> #functionCall(ID:Identifier) => #prepareUserFunc(PARAMS, ARGS, BODY, RETURNS) ... </k>
         <fn-args> ARGS:Expressions => . ... </fn-args>
         <funcs> ... ID |-> L ... </funcs>
         <store> ... L |-> (function ID ( PARAMS ) -> RETURNS BODY) ... </store>
         <to-filter> . </to-filter>


    rule <k> #prepareUserFunc(PARAMS, ARGS, BODY, RETURNS) => #argBind(PARAMS, ARGS) ~> #let RETURNS ~> BODY ~> #funcEnd ~> #toReturn(RETURNS) ~> #envRestore(VARS, FUNCS) ... </k>
         <funcs> FUNCS </funcs>
         <vars> VARS => .Map </vars>
         <to-filter> . </to-filter>


    rule <k> #argBind(ID:Identifier, PARAMS:TypedIdentifierList, VAL:Expression, ARGS:Expressions) => #let ID := #realStuff(VAL) ~> #argBind(PARAMS, ARGS) ... </k> 
         <to-filter> . </to-filter>

    rule <k> #argBind(ID:Identifier : _:TypeName, PARAMS:TypedIdentifierList, VAL:Expression, ARGS:Expressions) => #let ID := #realStuff(VAL) ~> #argBind(PARAMS, ARGS) ... </k> 
         <to-filter> . </to-filter>

    rule <k> #argBind(.TypedIdentifierList, .Expressions) => . ... </k>
         <to-filter> . </to-filter>


    rule <k> #funcEnd => . ... </k>
         <to-filter> . </to-filter>


    rule <k> #toReturn(.TypedIdentifierNeList) => #fetchReturns ~> #multi(.Expressions) ... </k>
         <to-filter> . </to-filter>

    rule <k> #toReturn(ID : _:TypeName, REST) => #evalReturn(ID) ~> #toReturn(REST) ... </k>
         <to-filter> . </to-filter>
         
    rule <k> #toReturn(ID, REST) => #evalReturn(ID) ~> #toReturn(REST) ... </k>
         <to-filter> . </to-filter>


    rule <k> #evalReturn(VAL) => . ... </k>
         <return> ... .List => ListItem(VAL) </return>
         <to-filter> . </to-filter>


    rule <k> #fetchReturns ~> #multi(RETURNED) => #fetchReturns ~> #multi(VAL, RETURNED) ... </k>
         <return> ... ListItem(VAL) => .List </return>
         <to-filter> . </to-filter>

    rule <k> #fetchReturns ~> #multi(EXPRS) ~> #envRestore(VARS, FUNCS) => #envRestore(VARS, FUNCS) ~> #multi(EXPRS) ... </k>
         <return> .List </return>
         <to-filter> . </to-filter>


    rule <k> #multi(.Expressions) => . ... </k>
         <to-filter> . </to-filter>


    // Function hoisting
    rule <to-filter> REST:Statement S:Statement => REST </to-filter>        
         <filtered> .List => ListItem(S) ... </filtered>                
        when notBool isFunctionDefinition(S)                                                    [priority(0)]
        
    rule <to-filter> S:Statement => . </to-filter>                      
         <filtered> .List => ListItem(S) ... </filtered>
        when notBool isFunctionDefinition(S)                                                    [priority(4)]

    rule <to-filter> REST:Statement FD:FunctionDefinition => #hoist(FD) ~> REST </to-filter>    [priority(1)]
    rule <to-filter> FD:FunctionDefinition => #hoist(FD) </to-filter>                           [priority(2)]

    rule <to-filter> #hoist(function ID ( PARAMS ) -> RETURNS BLOCK) => . ... </to-filter>
         <funcs> FUNCS => FUNCS[ID <- !L:Int] </funcs>
         <store> ... .Map => !L |-> (function ID ( PARAMS ) -> RETURNS BLOCK) ... </store>
         <vars> VARS </vars>
        when (notBool (ID in_keys(FUNCS))) andBool (notBool (ID in_keys(VARS)))

    rule <to-filter> #hoist(function ID ( PARAMS ) BLOCK) => . ... </to-filter>
         <funcs> FUNCS => FUNCS[ID <- !L:Int] </funcs>
         <store> ... .Map => !L |-> (function ID ( PARAMS ) BLOCK) ... </store>
         <vars> VARS </vars>
        when (notBool (ID in_keys(FUNCS))) andBool (notBool (ID in_keys(VARS)))
endmodule
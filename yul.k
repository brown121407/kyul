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

requires "word.k"

module YUL-SYNTAX
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
                       // FIXME: Expressions that are also statements (i.e. at the block level) have to evaluate to zero values.
                       // This means that Expression here is restricted to FunctionCall, since that's the only thing that can evaluate
                       // to zero values.
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
    syntax Assignment ::= IdentifierNeList ":=" Expression
    syntax Expression ::= FunctionCall
                        | Identifier
                        | Literal
    syntax If ::= "if" Expression Block                         [strict(1)]
    syntax Switch ::= "switch" Expression Cases                 [strict(1)]
                    | "switch" Expression Cases Default         [strict(1)]
                    | "switch" Expression Default               [strict(1)]
    syntax Cases ::= NeList{Case, ""}
    syntax Case ::= "case" Literal Block                        [strict(1)]
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
                     // TODO: Typed Literals
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
    imports SET
    imports WORD
    imports K-REFLECTION
    imports STRING
    imports BOOL
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
                   | #toReturn(TypedIdentifierNeList)
                   | #evalReturn(Expression)            [strict]
                   | "#fetchReturns"
                   | #argBind(TypedIdentifierList, Expressions)
                   | #prepareUserFunc(TypedIdentifierList, Expressions, Block, TypedIdentifierNeList)
                   | #endFor(ForLoop)
                   | #evalForCond(Expression)           [strict]
    syntax Error ::= #error(String)
                   | #syntaxError(String)
                   | #declarationError(String)
    syntax RealStuff ::= Expression
                       | Multi
    syntax Multi ::= #multi(Expressions)
    syntax RealVariableDeclaration ::= "#let" TypedIdentifierNeList
                                     | "#let" TypedIdentifierNeList ":=" "#realStuff" "(" RealStuff ")"             [strict(2)]
    syntax RealAssignment ::= "#assign" IdentifierNeList ":=" "#realStuff" "(" RealStuff ")"                      [strict(2)]
    syntax RealFor ::= #for(Expression, Block, Block)
    syntax RealSwitch ::= #switch(Expression, Expression, Block, Switch)    [strict(2)]
    syntax AllowLoopControl ::= #allowLoopControlTop(Pgm)
                              | #allowLoopControl(Bool, Statement)
    syntax CheckNames ::= #checkNamesTop(Pgm)
                        | #checkNames(Statement)
                        | #checkNamesFunc(TypedIdentifierList, TypedIdentifierNeList, Block)
                        | "#popBlockNames"
                        | #reserveName(Identifier)

    configuration <yul>
        <k> #checkNamesTop($PGM) ~> #allowLoopControlTop($PGM) ~> #start ~> $PGM:Pgm </k>
        <env>
            <vars> .Map </vars>
            <funcs> .Map </funcs>
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
        <reserved-names>
            <block-names> .List </block-names>
            <all-names> .Set </all-names>
        </reserved-names>
        <evm>
            <storage> .Map </storage>
            <mem> .Map </mem>
        </evm>
    </yul>

    rule <k> #allowLoopControlTop(B:Block) => #allowLoopControl(false, B) ... </k>

    rule <k> #allowLoopControl(_, { }) => . ... </k>
    rule <k> #allowLoopControl(B, { S }) => #allowLoopControl(B, S) ... </k>
    rule <k> #allowLoopControl(B, S:Statement REST:Statement) => #allowLoopControl(B, S) ~> #allowLoopControl(B, REST) ... </k>
    rule <k> #allowLoopControl(_, function _ ( _ ) BODY) => #allowLoopControl(false, BODY) ... </k>
    rule <k> #allowLoopControl(_, function _ ( _ ) -> _ BODY) => #allowLoopControl(false, BODY) ... </k>
    rule <k> #allowLoopControl(_, for INIT _ POST BODY) => #allowLoopControl(false, INIT) ~> #allowLoopControl(false, POST) ~> #allowLoopControl(true, BODY) ... </k>
    rule <k> #allowLoopControl(B, if _ BLOCK) => #allowLoopControl(B, BLOCK) ... </k>
    rule <k> #allowLoopControl(B, switch EXPR case _ BLOCK REST:Cases) => #allowLoopControl(B, BLOCK) ~> #allowLoopControl(B, switch EXPR REST) ... </k>
    rule <k> #allowLoopControl(B, switch EXPR case _ BLOCK REST:Cases DEFAULT:Default) => #allowLoopControl(B, BLOCK) ~> #allowLoopControl(B, switch EXPR REST DEFAULT) ... </k>
    rule <k> #allowLoopControl(_, switch _ .Cases) => . ... </k>
    rule <k> #allowLoopControl(B, switch _ .Cases default BLOCK) => #allowLoopControl(B, BLOCK) ... </k>
    rule <k> #allowLoopControl(B, switch _ default BLOCK) => #allowLoopControl(B, BLOCK) ... </k>
    rule <k> #allowLoopControl(false, break) => #syntaxError("break is only allowed in a for loop's body.") ... </k>
    rule <k> #allowLoopControl(false, continue) => #syntaxError("continue is only allowed in a for loop's body.") ... </k>
    rule <k> #allowLoopControl(_, _) => . ... </k>  [owise]


    rule <k> #checkNamesTop(B:Block) => #checkNames(B) ... </k>

    rule <k> #checkNames({ }) => . ... </k>
    rule <k> #checkNames({ S }) => #checkNames(S) ~> #popBlockNames ... </k>
         <block-names> .List => ListItem(.Set) ... </block-names>
    rule <k> #checkNames(S:Statement REST:Statement) => #checkNames(S) ~> #checkNames(REST) ... </k>
    rule <k> #checkNames(let ID, IDS:TypedIdentifierNeList) => #reserveName(ID) ~> #checkNames(let IDS) ... </k>
    rule <k> #checkNames(let ID : _, IDS:TypedIdentifierNeList) => #reserveName(ID) ~> #checkNames(let IDS) ... </k>
    rule <k> #checkNames(let ID, IDS:TypedIdentifierNeList := _) => #reserveName(ID) ~> #checkNames(let IDS) ... </k>
    rule <k> #checkNames(let ID : _, IDS:TypedIdentifierNeList := _) => #reserveName(ID) ~> #checkNames(let IDS) ... </k>
    rule <k> #checkNames(let .TypedIdentifierNeList) => . ... </k>
    rule <k> #checkNames(function ID ( PARAMS ) BODY) => #reserveName(ID) ~> #checkNamesFunc(PARAMS, .TypedIdentifierNeList, BODY) ~> #popBlockNames ... </k>
         <block-names> .List => ListItem(.Set) ... </block-names>
    rule <k> #checkNames(function ID ( PARAMS ) -> RETURNS BODY) => #reserveName(ID) ~> #checkNamesFunc(PARAMS, RETURNS, BODY) ~> #popBlockNames ... </k>
         <block-names> .List => ListItem(.Set) ... </block-names>
    rule <k> #checkNames(for INIT _ POST BODY) => #checkNames(INIT) ~> #checkNames(POST) ~> #checkNames(BODY) ... </k>
    rule <k> #checkNames(if _ BLOCK) => #checkNames(BLOCK) ... </k>
    rule <k> #checkNames(switch EXPR case _ BLOCK REST:Cases) => #checkNames(BLOCK) ~> #checkNames(switch EXPR REST) ... </k>
    rule <k> #checkNames(switch EXPR case _ BLOCK REST:Cases DEFAULT:Default) => #checkNames(BLOCK) ~> #checkNames(switch EXPR REST DEFAULT) ... </k>
    rule <k> #checkNames(switch _ .Cases) => . ... </k>
    rule <k> #checkNames(switch _ .Cases default BLOCK) => #checkNames(BLOCK) ... </k>
    rule <k> #checkNames(switch _ default BLOCK) => #checkNames(BLOCK) ... </k>
    rule <k> #checkNames(_) => . ... </k>   [owise]

    rule <k> #checkNamesFunc(PARAM, PARAMS:TypedIdentifierList, RETURNS, BODY) => #reserveName(PARAM) ~> #checkNamesFunc(PARAMS, RETURNS, BODY) ... </k>
    rule <k> #checkNamesFunc(PARAM : _, PARAMS:TypedIdentifierList, RETURNS, BODY) => #reserveName(PARAM) ~> #checkNamesFunc(PARAMS, RETURNS, BODY) ... </k>
    rule <k> #checkNamesFunc(.TypedIdentifierList, RETID, RETURNS:TypedIdentifierNeList, BODY) => #reserveName(RETID) ~> #checkNamesFunc(.TypedIdentifierList, RETURNS, BODY) ... </k>
    rule <k> #checkNamesFunc(.TypedIdentifierList, RETID : _, RETURNS:TypedIdentifierNeList, BODY) => #reserveName(RETID) ~> #checkNamesFunc(.TypedIdentifierList, RETURNS, BODY) ... </k>
    rule <k> #checkNamesFunc(.TypedIdentifierList, .TypedIdentifierNeList, BODY) => #checkNames(BODY) ... </k>

    rule <k> #popBlockNames => . ... </k>
         <reserved-names>
            <block-names> ListItem(BLOCKNAMES) => .List ... </block-names>
            <all-names> ALLNAMES => ALLNAMES -Set BLOCKNAMES </all-names>
         </reserved-names>

    rule <k> #reserveName(ID) => . ... </k> 
         <reserved-names>
             <block-names> ListItem(BLOCKNAMES => BLOCKNAMES SetItem(ID)) ...  </block-names>
             <all-names> ALLNAMES => ALLNAMES SetItem(ID) </all-names>
         </reserved-names>
        requires notBool (ID in ALLNAMES)

    rule <k> #reserveName(ID) => #declarationError("Variable name " +String #unparseKORE(ID) +String " already taken in this scope.") ... </k>   [owise]


    rule <k> #start ~> { } => . </k>

    rule <k> #start ~> { S:Statement } => . </k>
         <to-filter> . => S </to-filter>

    rule <k> { } => . ... </k>                                          [structural]

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


    
    // TODO: How to prevent the user from writing #internals in $PGM?
    syntax String ::= #hexNumberToString(HexNumber) [function, hook(STRING.token2string)]
    syntax Int ::= #hexNumberStringToInt(String) [function]

    rule <k> X:HexNumber => #hexNumberStringToInt(#hexNumberToString(X)) ... </k>
         <to-filter> . </to-filter>
    rule #hexNumberStringToInt(S) => String2Base(replaceAll(S, "0x", ""), 16)

    rule <k> _:FalseLiteral => 0 ... </k>
         <to-filter> . </to-filter>
    rule <k> _:TrueLiteral => 1 ... </k>
         <to-filter> . </to-filter>

    // TODO: eval StringLiteral to Int

    rule <k> if 0 _ => . ... </k>
         <to-filter> . </to-filter>
    rule <k> if _ BLOCK => BLOCK ... </k>
         <to-filter> . </to-filter>         [owise]

    rule <k> for { S } COND POST BODY => S ~> #for(COND, POST, BODY) ~> #envRestore(VARS, FUNCS) ~> #endFor(for { } COND POST BODY) ... </k>
         <vars> VARS </vars>
         <funcs> FUNCS </funcs>
         <to-filter> . </to-filter>                                                             [structural]
    rule <k> for { } COND POST BODY => #for(COND, POST, BODY) ~> #envRestore(VARS, FUNCS) ~> #endFor(for { } COND POST BODY) ... </k>
         <vars> VARS </vars>
         <funcs> FUNCS </funcs>
         <to-filter> . </to-filter>                                                             [structural]

    rule <k> #for(COND, _, _) #as FOR:RealFor => #evalForCond(COND) ~> FOR ... </k>
         <to-filter> . </to-filter>

    rule <k> #evalForCond(EVALEDCOND) ~> #for(COND, POST, BODY) => BODY ~> POST ~> #for(COND, POST, BODY) ... </k>
         <to-filter> . </to-filter>
        requires #word2Bool(EVALEDCOND)

    rule <k> #evalForCond(_) ~> #for(_, _, _) => . ... </k>
         <to-filter> . </to-filter>                                                             [owise]

    rule <k> #endFor(_) => . ... </k>
         <to-filter> . </to-filter>                                                             [structural]

    rule <k> break ~> #envRestore(VARS, FUNCS) ~> #endFor(_) => #envRestore(VARS, FUNCS) ... </k>
         <to-filter> . </to-filter>     [structural]
    rule <k> break ~> _:KItem => break ... </k>
         <to-filter> . </to-filter>     [priority(51), structural]

    rule <k> continue ~> #envRestore(VARS, FUNCS) ~> #endFor((for { } _ POST _) #as LOOP) => POST ~> LOOP ~> #envRestore(VARS, FUNCS) ~> #endFor(LOOP) ... </k>
         <to-filter> . </to-filter>     [structural]
    rule <k> continue ~> _:KItem => continue ... </k>
         <to-filter> . </to-filter>     [priority(51), structural]


    rule <k> #switch(EXPR, EXPR, BLOCK, _) => BLOCK ... </k>
         <to-filter> . </to-filter>                                                             [structural]

    rule <k> #switch(_, _, _, SWITCH) => SWITCH ... </k>                    
         <to-filter> . </to-filter>                                                             [structural, owise]

    rule <k> switch EXPR case CASEEXPR BLOCK CASES:Cases => #switch(EXPR, CASEEXPR, BLOCK, switch EXPR CASES) ... </k>
         <to-filter> . </to-filter>                                                             [structural]

    rule <k> switch EXPR case CASEEXPR BLOCK CASES:Cases DEFAULT:Default => #switch(EXPR, CASEEXPR, BLOCK, switch EXPR CASES DEFAULT) ... </k>
         <to-filter> . </to-filter>                                                             [structural]

    rule <k> switch _ .Cases => . ... </k>
         <to-filter> . </to-filter>                                                             [structural]

    rule <k> switch _ .Cases default BLOCK => BLOCK ... </k>
         <to-filter> . </to-filter>                                                             [structural]

    rule <k> switch _ default BLOCK => BLOCK ... </k>
         <to-filter> . </to-filter>                                                             [structural]


    rule <k> let IDS => #let IDS ... </k>
         <to-filter> . </to-filter>                                     [structural]

    rule <k> let IDS := E => #let IDS := #realStuff(E) ... </k>
         <to-filter> . </to-filter>                                     [structural]

    rule <k> IDS := E => #assign IDS := #realStuff(E) ... </k>
         <to-filter> . </to-filter>                                     [structural]


    rule <k> #let ID:Identifier : _:TypeName, IDS:TypedIdentifierNeList => #let ID, IDS ... </k>
         <to-filter> . </to-filter>                                     [structural]

    rule <k> #let ID , IDS:TypedIdentifierNeList => #letBind(ID, 0) ~> #let IDS ... </k>
         <to-filter> . </to-filter>                                     [structural]

    rule <k> #let .TypedIdentifierNeList => . ... </k>
         <to-filter> . </to-filter>                                     [structural]


    rule <k> #let ID:Identifier : _:TypeName, IDS:TypedIdentifierNeList := #realStuff(RS) => #let ID, IDS := #realStuff(RS) ... </k>
         <to-filter> . </to-filter>                                     [structural]

    rule <k> #let ID , IDS:TypedIdentifierNeList := #realStuff(#multi(E:Expression, REST)) => #letBind(ID, E) ~> #let IDS := #realStuff(#multi(REST)) ... </k>
         <to-filter> . </to-filter>                                     [structural]

    rule <k> #let .TypedIdentifierNeList := #realStuff(#multi(.Expressions)) => . ... </k>
         <to-filter> . </to-filter>                                     [structural]

    rule <k> #let ID , .TypedIdentifierNeList := #realStuff(E:Expression) => #letBind(ID, E) ... </k>
         <to-filter> . </to-filter>                                     [structural]


    rule <k> #assign ID, IDS:IdentifierNeList := #realStuff(#multi(E:Expression, REST)) => #bind(ID, E) ~> #assign IDS := #realStuff(#multi(REST)) ... </k>
         <to-filter> . </to-filter>                                     [structural]

    rule <k> #assign .IdentifierNeList := #realStuff(#multi(.Expressions)) => . ... </k>
         <to-filter> . </to-filter>                                     [structural]

    rule <k> #assign ID, .IdentifierNeList := #realStuff(E:Expression) => #bind(ID, E) ... </k>
         <to-filter> . </to-filter>                                     [structural]


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


    // Function execution
    rule <k> FUN:Identifier ( ARGS:Expressions ) => ARGS ~> #functionCall(FUN) ... </k>
         <fn-args> K => .Expressions ~> K </fn-args>
         <to-filter> . </to-filter>

    // Arguments are evaluated from right to left.
    rule <k> ARG:Expression , ARGS:Expressions => ARGS ~> #evalArg(ARG) ... </k>
         <to-filter> . </to-filter>                                                             [structural]

    rule <k> .Expressions => . ... </k>
         <to-filter> . </to-filter>
    
    rule <k> #evalArg(#multi(ARG:Expression, .Expressions)) => . ... </k>
         <fn-args> ARGS:Expressions => ARG, ARGS ... </fn-args>
         <to-filter> . </to-filter>

    rule <k> #evalArg(ARG:Expression) => . ... </k>
         <fn-args> ARGS:Expressions => ARG, ARGS ... </fn-args>
         <to-filter> . </to-filter>


    rule <k> #functionCall(stop) ~> _ => . </k>
         <fn-args> .Expressions => . ... </fn-args>
         <to-filter> . </to-filter>

    rule <k> #functionCall(add) => W0 +Word W1 ... </k>
         <fn-args> W0:Int, W1:Int => . ... </fn-args>
         <to-filter> . </to-filter>

    rule <k> #functionCall(sub) => W0 -Word W1 ... </k>
         <fn-args> W0:Int, W1:Int => . ... </fn-args>
         <to-filter> . </to-filter>

    rule <k> #functionCall(mul) => W0 *Word W1 ... </k>
         <fn-args> W0:Int, W1:Int => . ... </fn-args>
         <to-filter> . </to-filter>

    rule <k> #functionCall(div) => W0 /Word W1 ... </k>
         <fn-args> W0:Int, W1:Int => . ... </fn-args>
         <to-filter> . </to-filter>

    rule <k> #functionCall(sdiv) => W0 /sWord W1 ... </k>
         <fn-args> W0:Int, W1:Int => . ... </fn-args>
         <to-filter> . </to-filter>

    rule <k> #functionCall(mod) => W0 %Word W1 ... </k>
         <fn-args> W0:Int, W1:Int => . ... </fn-args>
         <to-filter> . </to-filter>

    rule <k> #functionCall(smod) => W0 %sWord W1 ... </k>
         <fn-args> W0:Int, W1:Int => . ... </fn-args>
         <to-filter> . </to-filter>

    rule <k> #functionCall(exp) => W0 ^Word W1 ... </k>
         <fn-args> W0:Int, W1:Int => . ... </fn-args>
         <to-filter> . </to-filter>
    
    rule <k> #functionCall(not) => ~Word W ... </k>
         <fn-args> W:Int => . ... </fn-args>
         <to-filter> . </to-filter>

    rule <k> #functionCall(lt) => W0 <Word W1 ... </k>
         <fn-args> W0:Int, W1:Int => . ... </fn-args>
         <to-filter> . </to-filter>

    rule <k> #functionCall(gt) => W0 >Word W1 ... </k>
         <fn-args> W0:Int, W1:Int => . ... </fn-args>
         <to-filter> . </to-filter>

    rule <k> #functionCall(slt) => W0 s<Word W1 ... </k>
         <fn-args> W0:Int, W1:Int => . ... </fn-args>
         <to-filter> . </to-filter>

    rule <k> #functionCall(sgt) => W0 s>Word W1 ... </k>
         <fn-args> W0:Int, W1:Int => . ... </fn-args>
         <to-filter> . </to-filter>
    
    rule <k> #functionCall(eq) => W0 ==Word W1 ... </k>
         <fn-args> W0:Int, W1:Int => . ... </fn-args>
         <to-filter> . </to-filter>

    rule <k> #functionCall(iszero) => W ==Word 0 ... </k>
         <fn-args> W:Int, .Expressions => . ... </fn-args>
         <to-filter> . </to-filter>

    rule <k> #functionCall(and) => W0 &Word W1 ... </k>
         <fn-args> W0:Int, W1:Int => . ... </fn-args>
         <to-filter> . </to-filter>

    rule <k> #functionCall(or) => W0 |Word W1 ... </k>
         <fn-args> W0:Int, W1:Int => . ... </fn-args>
         <to-filter> . </to-filter>

    rule <k> #functionCall(xor) => W0 xorWord W1 ... </k>
         <fn-args> W0:Int, W1:Int => . ... </fn-args>
         <to-filter> . </to-filter>

    // TODO: byte

    rule <k> #functionCall(shl) => W0 <<Word W1 ... </k>
         <fn-args> W0:Int, W1:Int => . ... </fn-args>
         <to-filter> . </to-filter>

    rule <k> #functionCall(shr) => W0 >>Word W1 ... </k>
         <fn-args> W0:Int, W1:Int => . ... </fn-args>
         <to-filter> . </to-filter>

    rule <k> #functionCall(sar) => W0 >>sWord W1 ... </k>
         <fn-args> W0:Int, W1:Int => . ... </fn-args>
         <to-filter> . </to-filter>

    rule <k> #functionCall(addmod) => (W0 +Int W1) %Word W2 ... </k>
         <fn-args> W0:Int, W1:Int, W2:Int => . ... </fn-args>
         <to-filter> . </to-filter>

    rule <k> #functionCall(mulmod) => (W0 *Int W1) %Word W2 ... </k>
         <fn-args> W0:Int, W1:Int, W2:Int => . ... </fn-args>
         <to-filter> . </to-filter>

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
    
    rule <k> #multi(EXPR:Expression, .Expressions) => EXPR ... </k>
         <to-filter> . </to-filter>


    rule <k> leave ~> #funcEnd => #funcEnd ... </k>
         <to-filter> . </to-filter>                                         [priority(51), structural]

    rule <k> leave ~> _:KItem => leave ... </k>
         <to-filter> . </to-filter>                                         [priority(52), structural]


    // Function hoisting
    rule <to-filter> REST:Statement S:Statement => REST </to-filter>        
         <filtered> .List => ListItem(S) ... </filtered>                
        when notBool isFunctionDefinition(S)                                                    [priority(0)]
        
    rule <to-filter> S:Statement => . </to-filter>                      
         <filtered> .List => ListItem(S) ... </filtered>
        when notBool isFunctionDefinition(S)                                                    [priority(4)]

    rule <to-filter> REST:Statement FD:FunctionDefinition => #hoist(FD) ~> REST </to-filter>    [priority(1), structural]
    rule <to-filter> FD:FunctionDefinition => #hoist(FD) </to-filter>                           [priority(2), structural]

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
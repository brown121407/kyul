/*
Copyright 2023 Alexandru-Sergiu Marton

This file is part of KYUL.

KYUL is free software: you can redistribute it and/or modify it under the
terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later
version.

KYUL is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
details.

You should have received a copy of the GNU General Public License along
with KYUL. If not, see <https://www.gnu.org/licenses/>.
*/

requires "word.k"

module YUL-SYNTAX-COMMON
    imports UNSIGNED-INT-SYNTAX
    imports STRING-SYNTAX

    syntax Block ::= "{" Statement "}" | "{" "}"
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
    syntax Expressions ::= List{Expression, ","}    // also works as FunctionArgs

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

module YUL-SYNTAX
    imports YUL-SYNTAX-COMMON

    syntax Identifier ::= r"[a-zA-Z_$][a-zA-Z_$0-9.]*"           [token]
endmodule

module YUL-UTILS
    imports MAP
    imports LIST
    imports SET
    imports INT
    imports STRING
    imports BOOL
    imports BYTES
    imports K-REFLECTION
    imports WORD
    imports YUL-SYNTAX-COMMON

    syntax KResult ::= Int
                     | Multi
    syntax KItem ::= #envRestore(Map, Map)
                | "#start"

    syntax Ints ::= List{Int, ";"}
    syntax Multi ::= #multi(Ints)

    syntax Bind ::= #letBind(Identifier, Expression)   [strict(2)]
                  | #bind(Identifier, Expression)      [strict(2)]
                  | #argBind(TypedIdentifierList, Ints)

    syntax FunctionUtil ::= "#funcEnd"
                          | #functionCall(Identifier)
                          | #evalArg(MaybeMulti)                [strict]
                          | #hoist(FunctionDefinition)
                          | #toReturn(TypedIdentifierNeList)
                          | #evalReturn(Expression)            [strict]
                          | "#fetchReturns"
                          | #prepareUserFunc(TypedIdentifierList, Ints, Block, TypedIdentifierNeList)

    syntax ForUtil ::= #endFor(ForLoop)
                     | #evalForCond(Expression)           [strict]

    syntax Error ::= #error(String)
                   | #syntaxError(String)
                   | #declarationError(String)
                   | #typeError(String)

    syntax MaybeMulti ::= Expression
                        | Multi

    syntax RealVariableDeclaration ::= "#let" TypedIdentifierNeList
                                     | "#let" TypedIdentifierNeList ":=" MaybeMulti             [strict(2)]

    syntax RealAssignment ::= "#assign" IdentifierNeList ":=" MaybeMulti                      [strict(2)]

    syntax RealFor ::= #for(Expression, Block, Block)

    syntax RealSwitch ::= #switch(Expression, Expression, Block, Switch)    [strict(2)]

    syntax Check ::= #checkTop(Pgm)
                   | #check(Statement)
                   | #checkExitFn(Bool, Bool)
                   | #checkNoFns(Statement)
                   | "#checkBcAllowed"
                   | "#checkBcDisallowed"
                   | #checkBcRestore(Bool)
                   | #reserveName(Identifier)
                   | #checkNamesFunc(TypedIdentifierList, TypedIdentifierNeList)
                   | "#popBlockNames"
                   | "#pushBlockNames"
    syntax ToFilter ::= #toFilter(Statement)
    syntax String ::= #IdToString(Identifier) [function, hook(STRING.token2string)]
endmodule

module YUL-CONFIG
    /*
    This module (YUL-CONFIG) is adapted from the KEVM project: https://github.com/runtimeverification/evm-semantics
    Originally licensed under the BSD 3-Clause "New" or "Revised" License:

    BSD 3-Clause License

    Copyright (c) 2016-2022, Runtime Verification Inc.

    All rights reserved.

    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:

    1. Redistributions of source code must retain the above copyright notice, this
    list of conditions and the following disclaimer.

    2. Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

    3. Neither the name of the copyright holder nor the names of its
    contributors may be used to endorse or promote products derived from
    this software without specific prior written permission.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
    AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
    IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
    DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
    FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
    DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
    SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
    CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
    OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
    OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
    */

    imports YUL-UTILS


    syntax LoadEthConfig ::= #loadEthConfig(EthereumCell)

    configuration <yul>
        <k> #loadEthConfig($ETHCONFIG) ~> #checkTop($PGM) ~> #start ~> $PGM:Pgm </k>
        <env>
            <vars> .Map </vars>
            <funcs> .Map </funcs>
        </env>
        <store> .Map </store>
        <evaluation>
            <fn-args> . </fn-args>
            <return> .List </return>
        </evaluation>

        <checking>
            <check-bc> false:Bool </check-bc>
            <check-leave> false:Bool </check-leave>
            <reserved-names>
                <block-names> .List </block-names>
                <all-names> .Set </all-names>
            </reserved-names>
        </checking>


        <ethereum>
            <evm>
                <call-state>
                    <id> 0 </id>
                    <caller> 0 </caller>
                    <call-data> .Bytes </call-data>
                    <call-value> 0 </call-value>
                    <local-mem> .Bytes </local-mem>
                    <memory-used> 0 </memory-used>
                </call-state>

                <gas-price> 0 </gas-price>
                <origin> 0 </origin>

                <block>
                    <coinbase>   0 </coinbase>
                    <difficulty> 0 </difficulty>
                    <number>     0 </number>
                    <gas-limit>  0 </gas-limit>
                    <timestamp>  0 </timestamp>
                    <base-fee>   0 </base-fee>
                </block>
            </evm>

            <network>
                <chain-id> 1 </chain-id>

                <active-accounts> .Set </active-accounts>
                <accounts>
                    <account multiplicity="*" type="Map">
                        <account-id> 0    </account-id>
                        <balance>    0    </balance>
                        <storage>    .Map </storage>
                        <nonce>      0    </nonce>
                    </account>
                </accounts>
            </network>
        </ethereum>
    </yul>
endmodule

module YUL
    imports YUL-CONFIG


    rule <k> #loadEthConfig(ETHCONFIG) => . ... </k>
         (<ethereum> _ </ethereum> => ETHCONFIG)

    rule <k> #checkTop(B:Block) => #check(B) ... </k>
    rule <k> #check({ }) => . ... </k>
    rule <k> #check({ S }) => #pushBlockNames ~> #check(S) ~> #popBlockNames ... </k>

    rule <k> #pushBlockNames => . ... </k>
         <block-names> .List => ListItem(.Set) ... </block-names>

    rule <k> #popBlockNames => . ... </k>
         <reserved-names>
            <block-names> ListItem(BLOCKNAMES) => .List ... </block-names>
            <all-names> ALLNAMES => ALLNAMES -Set BLOCKNAMES </all-names>
         </reserved-names>

    rule <k> #check(REST:Statement S:Statement) => #check(REST) ~> #check(S) ... </k>

    rule <k> #check(let ID, IDS:TypedIdentifierNeList) => #reserveName(ID) ~> #check(let IDS) ... </k>
    rule <k> #check(let ID : _, IDS:TypedIdentifierNeList) => #reserveName(ID) ~> #check(let IDS) ... </k>
    rule <k> #check(let ID, IDS:TypedIdentifierNeList := EXPR) => #reserveName(ID) ~> #check(let IDS) ~> #check(EXPR) ... </k>
    rule <k> #check(let ID : _, IDS:TypedIdentifierNeList := EXPR) => #reserveName(ID) ~> #check(let IDS) ~> #check(EXPR) ... </k>
    rule <k> #check(let .TypedIdentifierNeList) => . ... </k>

    rule <k> #check(function ID ( PARAMS ) BODY) =>
            #reserveName(ID)
            ~> #pushBlockNames
            ~> #checkNamesFunc(PARAMS, .TypedIdentifierNeList)
            ~> #check(BODY)
            ~> #popBlockNames
            ~> #checkExitFn(LEAVE, BC) ...
         </k>
         <check-leave> LEAVE => true </check-leave>
         <check-bc> BC => false </check-bc>

    rule <k> #check(function ID ( PARAMS ) -> RETURNS BODY) =>
            #reserveName(ID)
            ~> #pushBlockNames
            ~> #checkNamesFunc(PARAMS, RETURNS)
            ~> #check(BODY)
            ~> #popBlockNames
            ~> #checkExitFn(LEAVE, BC) ...
         </k>
         <check-leave> LEAVE => true </check-leave>
         <check-bc> BC => false </check-bc>

    rule <k> #checkNamesFunc(PARAM, PARAMS:TypedIdentifierList, RETURNS) => #reserveName(PARAM) ~> #checkNamesFunc(PARAMS, RETURNS) ... </k>
    rule <k> #checkNamesFunc(PARAM : _, PARAMS:TypedIdentifierList, RETURNS) => #reserveName(PARAM) ~> #checkNamesFunc(PARAMS, RETURNS) ... </k>
    rule <k> #checkNamesFunc(.TypedIdentifierList, RETID, RETURNS:TypedIdentifierNeList) => #reserveName(RETID) ~> #checkNamesFunc(.TypedIdentifierList, RETURNS) ... </k>
    rule <k> #checkNamesFunc(.TypedIdentifierList, RETID : _, RETURNS:TypedIdentifierNeList) => #reserveName(RETID) ~> #checkNamesFunc(.TypedIdentifierList, RETURNS) ... </k>
    rule <k> #checkNamesFunc(.TypedIdentifierList, .TypedIdentifierNeList) => . ... </k>

    rule <k> #checkExitFn(LEAVE, BC) => . ... </k>
         <check-leave> _ => LEAVE </check-leave>
         <check-bc> _ => BC </check-bc>

    rule <k> #reserveName(ID) => . ... </k>
         <reserved-names>
             <block-names> ListItem(BLOCKNAMES => BLOCKNAMES SetItem(ID)) ...  </block-names>
             <all-names> ALLNAMES => ALLNAMES SetItem(ID) </all-names>
         </reserved-names>
        requires notBool (ID in ALLNAMES)
    rule <k> #reserveName(ID) => #declarationError("Variable name " +String #IdToString(ID) +String " already taken in this scope.") ... </k>   [owise]

    rule <k> #check(for { INIT } COND POST BODY) => #checkNoFns(INIT) ~> #check({ INIT for {} COND POST BODY }) ... </k>
    rule <k> #check(for { } COND POST BODY) => #check(COND) ~> #checkBcAllowed ~> #check(BODY) ~> #checkBcDisallowed ~> #check(POST) ~> #checkBcRestore(BC) ... </k>
         <check-bc> BC </check-bc>

    rule <k> #checkBcAllowed => . ... </k>
         <check-bc> _ => true </check-bc>

    rule <k> #checkBcDisallowed => . ... </k>
         <check-bc> _ => false </check-bc>

    rule <k> #checkBcRestore(BC) => . ... </k>
         <check-bc> _ => BC </check-bc>

    rule <k> #checkNoFns(_ _:FunctionDefinition) => #syntaxError("Functions cannot be defined inside a for-loop init block.") ... </k>
    rule <k> #checkNoFns(_:FunctionDefinition) => #syntaxError("Functions cannot be defined inside a for-loop init block.") ...  </k>
    rule <k> #checkNoFns(REST _:Statement) => #checkNoFns(REST) ... </k>    [priority(51)]
    rule <k> #checkNoFns(_:Statement) => . ... </k>                         [priority(52)]

    rule <k> #check(if COND BLOCK) => #check(COND) ~> #check(BLOCK) ... </k>
    rule <k> #check(switch EXPR case CEXPR BLOCK REST:Cases) => #check(CEXPR) ~> #check(BLOCK) ~> #check(switch EXPR REST) ... </k>
    rule <k> #check(switch EXPR case CEXPR BLOCK REST:Cases DEFAULT:Default) => #check(EXPR) ~> #check(CEXPR) ~> #check(BLOCK) ~> #check(switch EXPR REST DEFAULT) ... </k>
    rule <k> #check(switch EXPR .Cases) => #check(EXPR) ... </k>
    rule <k> #check(switch EXPR .Cases default BLOCK) => #check(EXPR) ~> #check(BLOCK) ... </k>
    rule <k> #check(break) => #syntaxError("break is only allowed in a for loop's body.") ... </k>
         <check-bc> false </check-bc>
    rule <k> #check(continue) => #syntaxError("continue is only allowed in a for loop's body.") ... </k>
         <check-bc> false </check-bc>
    rule <k> #check(leave) => #syntaxError("leave is only allowed in a function's body.") ... </k>
         <check-leave> false </check-leave>
    rule <k> #check(FUN:Identifier (ARG:Expression, ARGS:Expressions)) => #check(ARG) ~> #check(FUN (ARGS)) ... </k>
    rule <k> #check(LIT:LiteralUntyped : _) => #check(LIT) ... </k>
    rule <k> #check(STR:StringLiteral) => #typeError("String literal too long") ... </k>
        requires lengthBytes(String2Bytes({STR}:>String)) >Int 32
    rule <k> #check(INT:DecimalNumber) => #typeError("TypeError: Number literal too large (> 256 bits)") ... </k>
        requires {INT}:>Int >=Int #pow256
    rule <k> #check(HEX:HexNumber) => #typeError("TypeError: Number literal too large (> 256 bits)") ... </k>
        requires #hexNumberStringToInt(#hexNumberToString(HEX)) >=Int #pow256
    rule <k> #check(_) => . ... </k>  [owise]


    rule <k> #start ~> { } => . </k>

    rule <k> #start ~> { S:Statement } => #toFilter(S) </k>

    rule <k> { } => . ... </k>  [structural]

    rule <k> { S:Statement } => #toFilter(S) ~> #envRestore(VARS, FUNCS) ... </k>
         <vars> VARS </vars>
         <funcs> FUNCS </funcs>

    rule <k> ID:Identifier => VAL ... </k>
         <vars> ... ID |-> L ... </vars>
         <store> ... L |-> VAL:Int ... </store>


    syntax String ::= #hexNumberToString(HexNumber)     [function, hook(STRING.token2string)]
    syntax Int ::= #hexNumberStringToInt(String)        [function]

    rule <k> X:HexNumber => #hexNumberStringToInt(#hexNumberToString(X)) ... </k>
    rule #hexNumberStringToInt(S) => String2Base(replaceAll(S, "0x", ""), 16)

    rule <k> _:FalseLiteral => 0 ... </k>
    rule <k> _:TrueLiteral => 1 ... </k>

    rule <k> STR:StringLiteral => Bytes2Int(padRightBytes(String2Bytes({STR}:>String), 32, 0), BE, Unsigned) ... </k>

    rule <k> LIT:LiteralUntyped : _:TypeName => LIT ... </k>

    rule <k> if 0 _ => . ... </k>
    rule <k> if _ BLOCK => BLOCK ... </k> [owise]

    rule <k> for { S } COND POST BODY => S ~> #for(COND, POST, BODY) ~> #envRestore(VARS, FUNCS) ~> #endFor(for { } COND POST BODY) ... </k>
         <vars> VARS </vars>
         <funcs> FUNCS </funcs>     [structural]
    rule <k> for { } COND POST BODY => #for(COND, POST, BODY) ~> #envRestore(VARS, FUNCS) ~> #endFor(for { } COND POST BODY) ... </k>
         <vars> VARS </vars>
         <funcs> FUNCS </funcs>     [structural]

    rule <k> #for(COND, _, _) #as FOR:RealFor => #evalForCond(COND) ~> FOR ... </k>

    rule <k> #evalForCond(EVALEDCOND) ~> #for(COND, POST, BODY) => BODY ~> POST ~> #for(COND, POST, BODY) ... </k>
        requires #word2Bool(EVALEDCOND)

    rule <k> #evalForCond(_) ~> #for(_, _, _) => . ... </k> [owise]

    rule <k> #endFor(_) => . ... </k> [structural]

    rule <k> break ~> #envRestore(VARS, FUNCS) ~> #endFor(_) => #envRestore(VARS, FUNCS) ... </k>   [structural]
    rule <k> break ~> _:KItem => break ... </k>                                                     [priority(51), structural]

    rule <k> continue ~> #envRestore(VARS, FUNCS) ~> #endFor((for { } _ POST _) #as LOOP) => POST ~> LOOP ~> #envRestore(VARS, FUNCS) ~> #endFor(LOOP) ... </k> [structural]
    rule <k> continue ~> _:KItem => continue ... </k>                                                                                                           [priority(51), structural]


    rule <k> #switch(EXPR, EXPR, BLOCK, _) => BLOCK ... </k>    [structural]
    rule <k> #switch(_, _, _, SWITCH) => SWITCH ... </k>        [structural, owise]

    rule <k> switch EXPR case CASEEXPR BLOCK CASES:Cases => #switch(EXPR, CASEEXPR, BLOCK, switch EXPR CASES) ... </k>                          [structural]
    rule <k> switch EXPR case CASEEXPR BLOCK CASES:Cases DEFAULT:Default => #switch(EXPR, CASEEXPR, BLOCK, switch EXPR CASES DEFAULT) ... </k>  [structural]
    rule <k> switch _ .Cases => . ... </k>                                                                                                      [structural]
    rule <k> switch _ .Cases default BLOCK => BLOCK ... </k>                                                                                    [structural]
    rule <k> switch _ default BLOCK => BLOCK ... </k>                                                                                           [structural]


    rule <k> let IDS => #let IDS ... </k>                           [structural]
    rule <k> let IDS := E => #let IDS := E ... </k>     [structural]

    rule <k> IDS := E => #assign IDS := E ... </k>      [structural]


    rule <k> #let ID:Identifier : _:TypeName, IDS:TypedIdentifierNeList => #let ID, IDS ... </k>    [structural]
    rule <k> #let ID , IDS:TypedIdentifierNeList => #letBind(ID, 0) ~> #let IDS ... </k>            [structural]
    rule <k> #let .TypedIdentifierNeList => . ... </k>                                              [structural]


    rule <k> #let ID:Identifier : _:TypeName, IDS:TypedIdentifierNeList := RS => #let ID, IDS := RS ... </k>                            [structural]
    rule <k> #let ID , IDS:TypedIdentifierNeList := #multi(E; REST) => #letBind(ID, E) ~> #let IDS := #multi(REST) ... </k>  [structural]
    rule <k> #let .TypedIdentifierNeList := #multi(.Ints) => . ... </k>                                                                      [structural]
    rule <k> #let ID , .TypedIdentifierNeList := E:Expression => #letBind(ID, E) ... </k>                                                           [structural]


    rule <k> #assign ID, IDS:IdentifierNeList := #multi(E; REST) => #bind(ID, E) ~> #assign IDS := #multi(REST) ... </k> [structural]
    rule <k> #assign .IdentifierNeList := #multi(.Ints) => . ... </k>                                                                    [structural]
    rule <k> #assign ID, .IdentifierNeList := E:Expression => #bind(ID, E) ... </k>                                                             [structural]


    rule <k> #letBind(ID, VAL:Int) => . ... </k>
         <vars> VARS:Map => VARS[ID <- !L:Int] </vars>
         <store> ... .Map => !L |-> VAL ... </store>
         <funcs> FUNCS </funcs>
        requires (notBool (ID in_keys(VARS))) andBool (notBool (ID in_keys(FUNCS)))

    rule <k> #bind(ID, VAL:Int) => . ... </k>
         <vars> ... ID |-> L ... </vars>
         <store> STORE => STORE[L <- VAL] </store>

    rule <k> #envRestore(VARS, FUNCS) => . ... </k>
         <vars> _ => VARS </vars>
         <funcs> _ => FUNCS </funcs>


    // Function execution
    rule <k> FUN:Identifier ( ARGS:Expressions ) => ARGS ~> #functionCall(FUN) ... </k>
         <fn-args> K => .Ints ~> K </fn-args>

    // Arguments are evaluated from right to left.
    rule <k> ARG:Expression , ARGS:Expressions => ARGS ~> #evalArg(ARG) ... </k>    [structural]

    rule <k> .Expressions => . ... </k>

    rule <k> #evalArg(#multi(ARG; .Ints)) => . ... </k>
         <fn-args> ARGS:Ints => ARG; ARGS ... </fn-args>

    rule <k> #evalArg(ARG) => . ... </k>
         <fn-args> ARGS:Ints => ARG; ARGS ... </fn-args>

    // stop()
    rule <k> #functionCall(stop) ~> _ => . </k>
         <fn-args> .Ints => . ... </fn-args>

    // add(x, y)
    rule <k> #functionCall(add) => W0 +Word W1 ... </k>
         <fn-args> W0; W1 => . ... </fn-args>

    // sub(x, y)
    rule <k> #functionCall(sub) => W0 -Word W1 ... </k>
         <fn-args> W0; W1 => . ... </fn-args>

    // mul(x, y)
    rule <k> #functionCall(mul) => W0 *Word W1 ... </k>
         <fn-args> W0; W1 => . ... </fn-args>

    // div(x, y)
    rule <k> #functionCall(div) => W0 /Word W1 ... </k>
         <fn-args> W0; W1 => . ... </fn-args>

    // sdiv(x, y)
    rule <k> #functionCall(sdiv) => W0 /sWord W1 ... </k>
         <fn-args> W0; W1 => . ... </fn-args>

    // mod(x, y)
    rule <k> #functionCall(mod) => W0 %Word W1 ... </k>
         <fn-args> W0; W1 => . ... </fn-args>

    // smod(x, y)
    rule <k> #functionCall(smod) => W0 %sWord W1 ... </k>
         <fn-args> W0; W1 => . ... </fn-args>

    // exp(x, y)
    rule <k> #functionCall(exp) => W0 ^Word W1 ... </k>
         <fn-args> W0; W1 => . ... </fn-args>

    // not(x)
    rule <k> #functionCall(not) => ~Word W ... </k>
         <fn-args> W; .Ints => . ... </fn-args>

    // lt(x, y)
    rule <k> #functionCall(lt) => W0 <Word W1 ... </k>
         <fn-args> W0; W1 => . ... </fn-args>

    // gt(x, y)
    rule <k> #functionCall(gt) => W0 >Word W1 ... </k>
         <fn-args> W0; W1 => . ... </fn-args>

    // slt(x, y)
    rule <k> #functionCall(slt) => W0 s<Word W1 ... </k>
         <fn-args> W0; W1 => . ... </fn-args>

    // sgt(x, y)
    rule <k> #functionCall(sgt) => W1 s<Word W0 ... </k>
         <fn-args> W0; W1 => . ... </fn-args>

    // eq(x, y)
    rule <k> #functionCall(eq) => W0 ==Word W1 ... </k>
         <fn-args> W0; W1 => . ... </fn-args>

    // iszero(x)
    rule <k> #functionCall(iszero) => W ==Word 0 ... </k>
         <fn-args> W; .Ints => . ... </fn-args>

    // and(x, y)
    rule <k> #functionCall(and) => W0 &Word W1 ... </k>
         <fn-args> W0; W1 => . ... </fn-args>

    // or(x, y)
    rule <k> #functionCall(or) => W0 |Word W1 ... </k>
         <fn-args> W0; W1 => . ... </fn-args>

    // xor(x, y)
    rule <k> #functionCall(xor) => W0 xorWord W1 ... </k>
         <fn-args> W0; W1 => . ... </fn-args>

    // byte(n, x)
    rule <k> #functionCall(byte) => #byte(N, X) ... </k>
         <fn-args> N; X => . ... </fn-args>

    // shl(x, y)
    rule <k> #functionCall(shl) => W0 <<Word W1 ... </k>
         <fn-args> W0; W1 => . ... </fn-args>

    // shr(x, y)
    rule <k> #functionCall(shr) => W0 >>Word W1 ... </k>
         <fn-args> W0; W1 => . ... </fn-args>

    // sar(x, y)
    rule <k> #functionCall(sar) => W0 >>sWord W1 ... </k>
         <fn-args> W0; W1 => . ... </fn-args>

    // addmod(x, y, m)
    rule <k> #functionCall(addmod) => (W0 +Int W1) %Word W2 ... </k>
         <fn-args> W0; W1; W2 => . ... </fn-args>

    // mulmod(x, y, m)
    rule <k> #functionCall(mulmod) => (W0 *Int W1) %Word W2 ... </k>
         <fn-args> W0; W1; W2 => . ... </fn-args>

    // signextend(i, x)
    rule <k> #functionCall(signextend) => #signextend(W0, W1) ... </k>
         <fn-args> W0; W1 => . </fn-args>


    // keccak256(p, n)
    syntax Int ::= #keccak256(String) [function, hook(YUL.keccak256)]

    rule <k> #functionCall(keccak256) => #keccak256(Bytes2String(substrBytes(MEM, ADDR, ADDR +Int NBYTES))) ... </k>
         <fn-args> ADDR; NBYTES => . ... </fn-args>
         <local-mem> MEM </local-mem>
         <memory-used> MU </memory-used>
        requires ADDR +Int NBYTES <=Int MU *Int 32

    rule <k> #functionCall(keccak256) => #expandMem((ADDR +Int NBYTES) /Int 32 +Int (#if ((ADDR +Int NBYTES) %Int 32) ==Int 0 #then 0 #else 1 #fi)) ~> #functionCall(keccak256) ... </k>
         <fn-args> ADDR; NBYTES ... </fn-args>
         <memory-used> MU </memory-used>
        requires ADDR +Int NBYTES >Int MU *Int 32

    // TODO: pc

    // pop(x)
    rule <k> #functionCall(pop) => . ... </k>
         <fn-args> _; .Ints => . ... </fn-args>

    syntax ExpandMem ::= #expandMem(to: Int)
    rule <k> #expandMem(NEWMU) => . ... </k>
         <local-mem> MEM => padRightBytes(MEM, NEWMU *Int 32, 0) </local-mem>
         <memory-used> _ => NEWMU </memory-used>

    // mload(p)
    rule <k> #functionCall(mload) => Bytes2Int(substrBytes(MEM, ADDR, ADDR +Int 32), BE, Unsigned) ... </k>
         <fn-args> ADDR; .Ints => . ... </fn-args>
         <local-mem> MEM </local-mem>
         <memory-used> MU </memory-used>
        requires (MU -Int 1) *Int 32 >=Int ADDR

    rule <k> #functionCall(mload) => #expandMem(ADDR /Int 32 +Int (#if ADDR %Int 32 ==Int 0 #then 1 #else 2 #fi)) ~> #functionCall(mload) ... </k>
         <fn-args> ADDR; .Ints ... </fn-args>
         <memory-used> MU </memory-used>
        requires (MU -Int 1) *Int 32 <Int ADDR

    // mstore(p, v)
    rule <k> #functionCall(mstore) => . ... </k>
         <fn-args> ADDR; VAL => . ... </fn-args>
         <local-mem> MEM => replaceAtBytes(MEM, ADDR, Int2Bytes(32, VAL, BE)) </local-mem>
         <memory-used> MU </memory-used>
        requires (MU -Int 1) *Int 32 >=Int ADDR

    rule <k> #functionCall(mstore) => #expandMem(ADDR /Int 32 +Int (#if ADDR %Int 32 ==Int 0 #then 1 #else 2 #fi)) ~> #functionCall(mstore) ... </k>
         <fn-args> ADDR; _ ... </fn-args>
         <memory-used> MU </memory-used>
        requires (MU -Int 1) *Int 32 <Int ADDR

    // mstore8(p, v)
    rule <k> #functionCall(mstore8) => . ... </k>
         <fn-args> ADDR; VAL => . ... </fn-args>
         <local-mem> MEM => MEM[ADDR <- VAL] </local-mem>
         <memory-used> MU </memory-used>
        requires MU *Int 32 >Int ADDR

    rule <k> #functionCall(mstore8) => #expandMem(ADDR /Int 32 +Int 1) ~> #functionCall(mstore8) ... </k>
         <fn-args> ADDR; _ ... </fn-args>
         <memory-used> MU </memory-used>
        requires MU *Int 32 <=Int ADDR

    // sload(p)
    rule <k> #functionCall(sload) => VAL ... </k>
         <fn-args> SLOT; .Ints => . ... </fn-args>
         <id> CONTRACT </id>
         <account>
            <account-id> CONTRACT </account-id>
            <storage> ... SLOT |-> VAL ... </storage>
            ...
         </account>

    rule <k> #functionCall(sload) => 0 ... </k>
         <fn-args> _; .Ints => . ... </fn-args>       [owise]

    // sstore(p, v)
    rule <k> #functionCall(sstore) => . ... </k>
         <fn-args> SLOT; 0 => . ... </fn-args>
         <id> CONTRACT </id>
         <account>
            <account-id> CONTRACT </account-id>
            <storage> STORAGE => STORAGE[SLOT <- undef] </storage>
            ...
         </account>

    rule <k> #functionCall(sstore) => . ... </k>
         <fn-args> SLOT; VAL => . ... </fn-args>
         <id> CONTRACT </id>
         <account>
            <account-id> CONTRACT </account-id>
            <storage> STORAGE => STORAGE[SLOT <- VAL] </storage>
            ...
         </account>                                                 [owise]

    // msize()
    rule <k> #functionCall(msize) => 32 *Int MU ... </k>
         <fn-args> .Ints => . ... </fn-args>
         <memory-used> MU </memory-used>

    // address()
    rule <k> #functionCall(address) => ADDR ... </k>
         <fn-args> .Ints => . ... </fn-args>
         <id> ADDR </id>

    // balance(a)
    rule <k> #functionCall(balance) => BALANCE ... </k>
         <fn-args> ADDR; .Ints => . ... </fn-args>
         <account>
            <account-id> ADDR </account-id>
            <balance> BALANCE </balance>
            ...
         </account>

    // selfbalance()
    rule <k> #functionCall(selfbalance) => BALANCE ... </k>
         <fn-args> .Ints => . ... </fn-args>
         <id> ADDR </id>
         <account>
            <account-id> ADDR </account-id>
            <balance> BALANCE </balance>
            ...
         </account>

    // caller()
    rule <k> #functionCall(caller) => ADDR ... </k>
         <fn-args> .Ints => . ... </fn-args>
         <caller> ADDR </caller>

    // TODO: gas

    // callvalue()
    rule <k> #functionCall(callvalue) => CALLVALUE ... </k>
         <fn-args> .Ints => . ... </fn-args>
         <call-value> CALLVALUE </call-value>

    // calldataload(p)
    rule <k> #functionCall(calldataload) => Bytes2Int(substrBytes(CALLDATA, OFFSET, OFFSET +Int 32), BE, Unsigned) ... </k>
         <fn-args> OFFSET; .Ints => . ... </fn-args>
         <call-data> CALLDATA </call-data>
        requires OFFSET +Int 32 <=Int lengthBytes(CALLDATA)

    rule <k> #functionCall(calldataload) => Bytes2Int(padRightBytes(substrBytes(CALLDATA, OFFSET, lengthBytes(CALLDATA)), 32, 0), BE, Unsigned) ... </k>
         <fn-args> OFFSET; .Ints => . ... </fn-args>
         <call-data> CALLDATA </call-data>
        requires OFFSET <Int lengthBytes(CALLDATA) andBool OFFSET +Int 32 >Int lengthBytes(CALLDATA)

    rule <k> #functionCall(calldataload) => 0 ... </k>
         <fn-args> OFFSET; .Ints => . ... </fn-args>
         <call-data> CALLDATA </call-data>
        requires OFFSET >=Int lengthBytes(CALLDATA)

    // calldatasize()
    rule <k> #functionCall(calldatasize) => lengthBytes(CALLDATA) ... </k>
         <fn-args> .Ints => . ... </fn-args>
         <call-data> CALLDATA </call-data>

    // calldatacopy(t, f, s)
    rule <k> #functionCall(calldatacopy) => . ... </k>
         <fn-args> MEMADDR; CDADDR; NBYTES => . ... </fn-args>
         <call-data> CALLDATA </call-data>
         <local-mem> MEM => replaceAtBytes(MEM, MEMADDR, substrBytes(CALLDATA, CDADDR, CDADDR +Int NBYTES)) </local-mem>
         <memory-used> MU </memory-used>
        requires (MEMADDR +Int NBYTES <=Int MU *Int 32) andBool (CDADDR +Int NBYTES <=Int lengthBytes(CALLDATA))

    rule <k> #functionCall(calldatacopy) => . ... </k>
         <fn-args> MEMADDR; CDADDR; NBYTES => . ... </fn-args>
         <call-data> CALLDATA </call-data>
         <local-mem> MEM => replaceAtBytes(MEM, MEMADDR, padRightBytes(substrBytes(CALLDATA, CDADDR, lengthBytes(CALLDATA)), NBYTES, 0)) </local-mem>
         <memory-used> MU </memory-used>
        requires (MEMADDR +Int NBYTES <=Int MU *Int 32) andBool ((CDADDR <Int lengthBytes(CALLDATA)) andBool (CDADDR +Int NBYTES >Int lengthBytes(CALLDATA)))

    rule <k> #functionCall(calldatacopy) => . ... </k>
         <fn-args> MEMADDR; CDADDR; NBYTES => . ... </fn-args>
         <call-data> CALLDATA </call-data>
         <local-mem> MEM => replaceAtBytes(MEM, MEMADDR, padRightBytes(.Bytes, NBYTES, 0)) </local-mem>
         <memory-used> MU </memory-used>
        requires (MEMADDR +Int NBYTES <=Int MU *Int 32) andBool (CDADDR >Int lengthBytes(CALLDATA))

    rule <k> #functionCall(calldatacopy) => #expandMem((MEMADDR +Int NBYTES) /Int 32 +Int (#if ((MEMADDR +Int NBYTES) %Int 32) ==Int 0 #then 0 #else 1 #fi)) ~> #functionCall(calldatacopy) ... </k>
         <fn-args> MEMADDR; _; NBYTES ... </fn-args>
         <memory-used> MU </memory-used>
        requires MEMADDR +Int NBYTES >Int MU *Int 32


    // TODO: codesize, codecopy, extcodesize, extcodecopy, returndatasize, returndatacopy,
    // TODO: extcodehash, create, create2, call, callcode, delegatecall, staticcall, return,
    // TODO: revert, selfdestruct, invalid, log0, log1, log2, log3, log4

    // chainid()
    rule <k> #functionCall(chainid) => CHAINID ... </k>
         <fn-args> .Ints => . ... </fn-args>
         <chain-id> CHAINID </chain-id>

    // basefee()
    rule <k> #functionCall(basefee) => BASEFEE ... </k>
         <fn-args> .Ints => . ... </fn-args>
         <base-fee> BASEFEE </base-fee>

    // origin()
    rule <k> #functionCall(origin) => ORIGIN ... </k>
         <fn-args> .Ints => . ... </fn-args>
         <origin> ORIGIN </origin>

    // gasprice()
    rule <k> #functionCall(gasprice) => GASPRICE ... </k>
         <fn-args> .Ints => . ... </fn-args>
         <gas-price> GASPRICE </gas-price>

    // TODO: blockhash

    // coinbase()
    rule <k> #functionCall(coinbase) => COINBASE ... </k>
         <fn-args> .Ints => . ... </fn-args>
         <coinbase> COINBASE </coinbase>

    // timestamp()
    rule <k> #functionCall(timestamp) => TIMESTAMP ... </k>
         <fn-args> .Ints => . ... </fn-args>
         <timestamp> TIMESTAMP </timestamp>

    // number()
    rule <k> #functionCall(number) => NUMBER ... </k>
         <fn-args> .Ints => . ... </fn-args>
         <number> NUMBER </number>

    // difficulty()
    rule <k> #functionCall(difficulty) => DIFFICULTY ... </k>
         <fn-args> .Ints => . ... </fn-args>
         <difficulty> DIFFICULTY </difficulty>

    // TODO: prevrandao

    // gaslimit()
    rule <k> #functionCall(gaslimit) => GASLIMIT ... </k>
         <fn-args> .Ints => . ... </fn-args>
         <gas-limit> GASLIMIT </gas-limit>


    rule <k> #functionCall(ID:Identifier) => #prepareUserFunc(PARAMS, ARGS, BODY, .TypedIdentifierNeList) ... </k>
         <fn-args> ARGS:Ints => . ... </fn-args>
         <funcs> ... ID |-> L ... </funcs>
         <store> ... L |-> (function ID ( PARAMS ) BODY) ... </store>

    rule <k> #functionCall(ID:Identifier) => #prepareUserFunc(PARAMS, ARGS, BODY, RETURNS) ... </k>
         <fn-args> ARGS:Ints => . ... </fn-args>
         <funcs> ... ID |-> L ... </funcs>
         <store> ... L |-> (function ID ( PARAMS ) -> RETURNS BODY) ... </store>


    rule <k> #prepareUserFunc(PARAMS, ARGS, BODY, RETURNS) => #argBind(PARAMS, ARGS) ~> #let RETURNS ~> BODY ~> #funcEnd ~> #toReturn(RETURNS) ~> #envRestore(VARS, FUNCS) ... </k>
         <funcs> FUNCS </funcs>
         <vars> VARS => .Map </vars>


    rule <k> #argBind(ID:Identifier, PARAMS:TypedIdentifierList, VAL:Int; ARGS:Ints) => #let ID := VAL ~> #argBind(PARAMS, ARGS) ... </k>
    rule <k> #argBind(ID:Identifier : _:TypeName, PARAMS:TypedIdentifierList, VAL:Int; ARGS:Ints) => #let ID := VAL ~> #argBind(PARAMS, ARGS) ... </k>
    rule <k> #argBind(.TypedIdentifierList, .Ints) => . ... </k>


    rule <k> #funcEnd => . ... </k>


    rule <k> #toReturn(.TypedIdentifierNeList) => #fetchReturns ~> #multi(.Ints) ... </k>
    rule <k> #toReturn(ID : _:TypeName, REST) => #evalReturn(ID) ~> #toReturn(REST) ... </k>
    rule <k> #toReturn(ID, REST) => #evalReturn(ID) ~> #toReturn(REST) ... </k>


    rule <k> #evalReturn(VAL) => . ... </k>
         <return> ... .List => ListItem(VAL) </return>


    rule <k> #fetchReturns ~> #multi(RETURNED) => #fetchReturns ~> #multi(VAL; RETURNED) ... </k>
         <return> ... ListItem(VAL) => .List </return>

    rule <k> #fetchReturns ~> #multi(INTS) ~> #envRestore(VARS, FUNCS) => #envRestore(VARS, FUNCS) ~> #multi(INTS) ... </k>
         <return> .List </return>


    rule <k> #multi(.Ints) => . ... </k>
    rule <k> #multi(INT; .Ints) => {INT}:>KResult ... </k>


    rule <k> leave ~> #funcEnd => #funcEnd ... </k>     [priority(51), structural]
    rule <k> leave ~> _:KItem => leave ... </k>         [priority(52), structural]


    // Function hoisting
    rule <k> #toFilter(REST:Statement S:Statement) => #toFilter(REST) ~> S ... </k>
        requires notBool isFunctionDefinition(S)                                                                [priority(0)]

    rule <k> #toFilter(S:Statement) => S ... </k>
        requires notBool isFunctionDefinition(S)                                                                [priority(4)]

    rule <k> #toFilter(REST:Statement FD:FunctionDefinition) => #hoist(FD) ~> #toFilter(REST) ... </k>      [priority(1), structural]
    rule <k> #toFilter(FD:FunctionDefinition) => #hoist(FD) ... </k>                                        [priority(2), structural]

    rule <k> #hoist(function ID ( PARAMS ) -> RETURNS BLOCK) => . ... </k>
         <funcs> FUNCS => FUNCS[ID <- !L:Int] </funcs>
         <store> ... .Map => !L |-> (function ID ( PARAMS ) -> RETURNS BLOCK) ... </store>
         <vars> VARS </vars>
        requires (notBool (ID in_keys(FUNCS))) andBool (notBool (ID in_keys(VARS)))

    rule <k> #hoist(function ID ( PARAMS ) BLOCK) => . ... </k>
         <funcs> FUNCS => FUNCS[ID <- !L:Int] </funcs>
         <store> ... .Map => !L |-> (function ID ( PARAMS ) BLOCK) ... </store>
         <vars> VARS </vars>
        requires (notBool (ID in_keys(FUNCS))) andBool (notBool (ID in_keys(VARS)))
endmodule
requires "yul.k"

module YUL-SPEC-SYNTAX
    imports YUL-SYNTAX

endmodule

module VERIFICATION
    imports K-EQUAL
    imports YUL-SPEC-SYNTAX
    imports YUL

    rule { M:Map [ K <- V ] #Equals M [ K <- V' ] } => { V #Equals V' } [simplification]
    // FIXME: WTF?
    rule { X #Equals X +Int 1 } => true::Bool [simplification]
endmodule

module YUL-SPEC
    imports VERIFICATION

    syntax Identifier ::= "$x" [token]

    // FIXME: Requires X #Equals X +Int 1 => true
    claim <k> let $x => . </k>
        <vars> VARS:Map => VARS [ $x <- ?L:Int ] </vars>
        <funcs> FUNCS </funcs>
        <store> STORE:Map => STORE [ ?L:Int <- 0 ] </store>
    requires notBool ($x in_keys ( VARS )) andBool notBool ($x in_keys ( FUNCS ))

    claim <k> add(2, 3) => 5 </k>
        <funcs> FUNCS </funcs>
        requires notBool (add in_keys (FUNCS))
endmodule
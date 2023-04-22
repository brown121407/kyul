/*
Copyright 2016-2022, Runtime Verification Inc.
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

Adapted from the KEVM project: https://github.com/runtimeverification/evm-semantics
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

module WORD
    imports INT
    imports BOOL
    imports K-EQUAL

    syntax Int ::= "#pow256"                [function]
                 | "#pow255"                [function]
    rule #pow256 => 115792089237316195423570985008687907853269984665640564039457584007913129639936
    rule #pow255 => 57896044618658097711785492504343953926634992332820282019728792003956564819968

    syntax Int ::= #bool2Word(Bool) [function]
    rule #bool2Word(B:Bool) => 1 requires B
    rule #bool2Word(B:Bool) => 0 requires notBool B

    syntax Bool ::= #word2Bool(Int) [function]
    rule #word2Bool(W) => false requires W  ==Int 0
    rule #word2Bool(W) => true  requires W =/=Int 0

    syntax Int ::= #sgn(Int) [function]
                 | #abs(Int) [function]
    rule #sgn(I) => -1 requires #pow255 <=Int I andBool I <Int #pow256
    rule #sgn(I) =>  1 requires 0 <=Int I andBool I <Int #pow255
    rule #sgn(I) =>  0 requires I <Int 0 orBool #pow256 <=Int I

    rule #abs(I) => 0 -Word I requires #sgn(I) ==Int -1
    rule #abs(I) => I         requires #sgn(I) ==Int  1
    rule #abs(I) => 0         requires #sgn(I) ==Int  0

    syntax Int ::= #chop(Int)               [function]
                 | Int "+Word" Int          [function]
                 | Int "*Word" Int          [function]
                 | Int "-Word" Int          [function]
                 | Int "/Word" Int          [function]
                 | Int "%Word" Int          [function]
                 | Int "^Word" Int          [function]
                 | #powmod(Int, Int, Int)   [function]
                 | Int "/sWord" Int         [function]
                 | Int "%sWord" Int         [function]
                 | Int "<Word"  Int         [function]
                 | Int ">Word"  Int         [function]
                 | Int "<=Word" Int         [function]
                 | Int ">=Word" Int         [function]
                 | Int "==Word" Int         [function]
                 | Int "s<Word" Int         [function]
                 | "~Word" Int              [function]
                 | Int "|Word"   Int        [function]
                 | Int "&Word"   Int        [function]
                 | Int "xorWord" Int        [function]
                 | Int "<<Word"  Int        [function]
                 | Int ">>Word"  Int        [function]
                 | Int ">>sWord" Int        [function]

    rule #chop(I:Int) => I %Int #pow256
        requires I <Int 0 orBool I >=Int #pow256
    rule #chop(I:Int) => I

    rule W0 +Word W1 => #chop(W0 +Int W1)
    rule W0 -Word W1 => #chop(W0 -Int W1)
    rule W0 *Word W1 => #chop(W0 *Int W1)
    rule  _ /Word W1 => 0            requires W1  ==Int 0
    rule W0 /Word W1 => W0 /Int W1   requires W1 =/=Int 0
    rule  _ %Word W1 => 0            requires W1  ==Int 0
    rule W0 %Word W1 => W0 modInt W1 requires W1 =/=Int 0
    rule W0 ^Word W1 => #powmod(W0, W1, #pow256)
    rule #powmod(W0, W1, W2) => W0 ^%Int W1 W2  requires W2 =/=Int 0
    rule #powmod( _,  _, W2) => 0               requires W2  ==Int 0
    rule W0 /sWord W1 =>          #abs(W0) /Word #abs(W1)  requires #sgn(W0) *Int #sgn(W1) ==Int  1
    rule W0 /sWord W1 => 0 -Word (#abs(W0) /Word #abs(W1)) requires #sgn(W0) *Int #sgn(W1) ==Int -1
    rule W0 %sWord W1 =>          #abs(W0) %Word #abs(W1)  requires #sgn(W0) ==Int  1
    rule W0 %sWord W1 => 0 -Word (#abs(W0) %Word #abs(W1)) requires #sgn(W0) ==Int -1
    rule W0 <Word  W1 => #bool2Word(W0 <Int  W1)
    rule W0 >Word  W1 => #bool2Word(W0 >Int  W1)
    rule W0 <=Word W1 => #bool2Word(W0 <=Int W1)
    rule W0 >=Word W1 => #bool2Word(W0 >=Int W1)
    rule W0 ==Word W1 => #bool2Word(W0 ==Int W1)
    rule W0 s<Word W1 => W0 <Word W1                requires #sgn(W0) ==K 1  andBool #sgn(W1) ==K 1
    rule W0 s<Word W1 => #bool2Word(false)          requires #sgn(W0) ==K 1  andBool #sgn(W1) ==K -1
    rule W0 s<Word W1 => #bool2Word(true)           requires #sgn(W0) ==K -1 andBool #sgn(W1) ==K 1
    rule W0 s<Word W1 => #abs(W1) <Word #abs(W0)    requires #sgn(W0) ==K -1 andBool #sgn(W1) ==K -1
    rule ~Word W      => W xorInt (#pow256 -Int 1)
    rule W0 |Word   W1 => W0 |Int W1
    rule W0 &Word   W1 => W0 &Int W1
    rule W0 xorWord W1 => W0 xorInt W1
    rule W0 <<Word  W1 => #chop(W0 <<Int W1) requires W1 <Int 256
    rule  _ <<Word  W1 => 0 requires W1 >=Int 256
    rule W0 >>Word  W1 => W0 >>Int W1
    rule W0 >>sWord W1 => #chop((#abs(W0) *Int #sgn(W0)) >>Int W1)

    syntax Int ::= Int "<<Byte" Int [function]
    rule N <<Byte M => N <<Int (8 *Int M)

    syntax Int ::= #nBits(Int)      [function]
                 | #nBytes(Int)     [function]
    rule #nBits(N)  => (1 <<Int N) -Int 1 requires N >=Int 0
    rule #nBytes(N) => #nBits(N *Int 8)   requires N >=Int 0

    syntax Int ::= #bit(Int, Int)   [function]
                 | #byte(Int, Int)  [function]
    rule #bit(N, _)  => 0 requires notBool (N >=Int 0 andBool N <Int 256)
    rule #bit (N, W) => bitRangeInt(W, (255 -Int N),       1) requires N >=Int 0 andBool N <Int 256
    rule #byte(N, _) => 0 requires notBool (N >=Int 0 andBool N <Int  32)
    rule #byte(N, W) => bitRangeInt(W, (31 -Int N) *Int 8, 8) requires N >=Int 0 andBool N <Int  32

    syntax Int ::= #signextend(Int, Int) [function, total]
    rule #signextend(N, W) => W requires N >=Int 32 orBool N <Int 0
    rule #signextend(N, W) => #chop((#nBytes(31 -Int N) <<Byte (N +Int 1)) |Int W) requires N <Int 32 andBool N >=Int 0 andBool         #word2Bool(#bit(256 -Int (8 *Int (N +Int 1)), W))
    rule #signextend(N, W) => #chop(#nBytes(N +Int 1)                      &Int W) requires N <Int 32 andBool N >=Int 0 andBool notBool #word2Bool(#bit(256 -Int (8 *Int (N +Int 1)), W))
endmodule
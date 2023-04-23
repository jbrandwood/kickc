/**
 * @file call-banked-phi-case-1-near-0.c
 * @author Sven Van de Velde (sven.van.de.velde@telenet.be)
 * @author Jesper Gravgaard
 * @brief Test a procedure with calling convention PHI - case #1.
 * @version 0.1
 * @date 2023-04-11
 * 
 * @copyright Copyright (c) 2023
 * 
 * The following cases exist in banked calling implementations:
 * 
 *   - case #1 - unbanked to unbanked and no banking areas
 *   - case #2 - unbanked to banked to any bank area
 *   - case #3 - banked to unbanked from any bank area
 *   - case #4 - banked to same bank in same bank area
 *   - case #5 - banked to different bank in same bank area
 *   - case #6 - banked to any bank between different bank areas
 * 
 * This brings us to the call types:
 * 
 *   - near = case #1, #3, #4
 *   - close = case #2, #6
 *   - far = case #5 
 * 
 */
  .file                               [name="call-banked-phi-case-1-near-0.prg", type="prg", segments="Program"]
.segmentdef Program                 [segments="Basic, Code, Data"]
.segmentdef Basic                   [start=$0801]
.segmentdef Code                    [start=$80d]
.segmentdef Data                    [startAfter="Code"]
.segmentdef RAM_Bank1               [start=$A000, min=$A000, max=$BFFF, align=$100]
.segmentdef RAM_Bank2               [start=$A000, min=$A000, max=$BFFF, align=$100]
.segmentdef ROM_Bank1               [start=$C000, min=$C000, max=$FFFF, align=$100]
.segment Basic
:BasicUpstart(main)
.segment Code
.segment Data


  .label SCREEN = $400
.segment Code
main: {
    // plus('0', 7)
    lda #7
    ldx #'0'
    jsr plus
    // plus('0', 7)
    // SCREEN[0] = plus('0', 7)
    sta SCREEN
    // plus('1', 6)
    lda #6
    ldx #'1'
    jsr plus
    // plus('1', 6)
    // SCREEN[1] = plus('1', 6)
    // near call
    sta SCREEN+1
    // }
    rts
}
// __register(A) char plus(__register(X) char a, __register(A) char b)
plus: {
    // a+b
    stx.z $ff
    clc
    adc.z $ff
    // }
    rts
}

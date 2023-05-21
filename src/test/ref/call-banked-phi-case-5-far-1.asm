/**
 * @file call-banked-phi-case-5-far-1.c
 * @author Sven Van de Velde (sven.van.de.velde@telenet.be), 
 * @author Jesper Gravgaard
 * @brief Test a procedure with calling convention PHI - case #5.
 * Implementation using the #pragma bank and nobank directives.
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
  .file                               [name="call-banked-phi-case-5-far-1.prg", type="prg", segments="Program"]
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
    ldx #7
    lda #'0'
    sta.z $ff
    lda.z 0
    pha
    lda #1
    sta.z 0
    lda.z $ff
    jsr plus
    sta.z $ff
    pla
    sta.z 0
    lda.z $ff
    // plus('0', 7)
    txa
    // SCREEN[0] = plus('0', 7)
    sta SCREEN
    // plus('1', 6)
    ldx #6
    lda #'1'
    sta.z $ff
    lda.z 0
    pha
    lda #1
    sta.z 0
    lda.z $ff
    jsr plus
    sta.z $ff
    pla
    sta.z 0
    lda.z $ff
    // plus('1', 6)
    txa
    // SCREEN[1] = plus('1', 6)
    // close call
    sta SCREEN+1
    // }
    rts
}
.segment RAM_Bank1
// __register(X) char plus(__register(A) char a, __register(X) char b)
// __bank(cx16_ram, 1) 
plus: {
    // add(a, b)
    sta.z add.a
    txa
    jsr $ff6e
    .byte <add
    .byte >add
    .byte 2
    tax
    // }
    rts
}
.segment RAM_Bank2
// __register(A) char add(__zp(2) char a, __register(A) char b)
// __bank(cx16_ram, 2) 
add: {
    .label a = 2
    // a+b
    clc
    adc.z a
    // }
    rts
}

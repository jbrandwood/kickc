/**
 * @file call-banked-phi-case-4-near-1.c
 * @author Sven Van de Velde (sven.van.de.velde@telenet.be), 
 * @author Jesper Gravgaard
 * @brief Test a procedure with calling convention PHI - case #4.
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
  .file                               [name="call-banked-phi-case-4-near-1.prg", type="prg", segments="Program"]
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
    lda.z 0
    pha
    lda #1
    sta.z 0
    jsr plus
    pla
    sta.z 0
    // SCREEN[0] = plus('0', 7)
    lda #min.return
    sta SCREEN
    // }
    rts
}
.segment RAM_Bank1
// char plus(char a, char b)
// __bank(cx16_ram, 1) 
plus: {
    .label a = '0'
    .label b = 7
    // min(a, b)
    jsr min
    // }
    rts
}
// char min(char a, char b)
// __bank(cx16_ram, 1) 
min: {
    .label return = plus.a+plus.b
    rts
}

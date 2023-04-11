// Test a procedure with calling convention PHI - case #6
  .file                               [name="call-banked-phi-case-6-close-0.prg", type="prg", segments="Program"]
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
    lda #1
    sta.z 0
    pha
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
plus: {
    .label a = '0'
    .label b = 7
    // min(a, b)
    lda #1
    sta.z 1
    pha
    jsr min
    pla
    sta.z 1
    // }
    rts
}
.segment ROM_Bank1
// char min(char a, char b)
min: {
    .label return = plus.a+plus.b
    rts
}

// Test a procedure with calling convention PHI - case #2
  .file                               [name="call-banked-phi-case-2-close-1.prg", type="prg", segments="Program"]
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
    lda #plus.return
    sta SCREEN
    // }
    rts
}
.segment RAM_Bank1
// char plus(char a, char b)
plus: {
    .const a = '0'
    .const b = 7
    .label return = a+b
    rts
}

// Test a far call procedure with a calling convention PHI into ROM
.cpu _65c02
  .segmentdef Program                 [segments="Basic, Code, Data, stage, platform"]
.segmentdef Basic                   [start=$0801]
.segmentdef Code                    [start=$80d]
.segmentdef Data                    [startAfter="Code"]
.segmentdef stage                   [start=$0400, min=$0400, max=$07FF, align=$100]
.segmentdef platform                [start=$C000, min=$C000, max=$C7FF, align=$100]


  .label SCREEN = $400
.segment stage
main: {
    // plus('0', 7)
    jsr $ff6e
    .byte <plus
    .byte >plus
    .byte 1
    // SCREEN[0] = plus('0', 7)
    lda #plus.return
    sta SCREEN
    // }
    rts
}
// test rom bank
// char plus(char a, char b)
plus: {
    .const a = '0'
    .const b = 7
    .label return = a+b
    rts
}

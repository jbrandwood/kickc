// Test a far call procedure with a calling convention sp
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
    .assert "Missing ASM fragment Fragment not found call_far_cx16_stage_prepare. Attempted variations call_far_cx16_stage_prepare ", 0, 1
    // SCREEN[0] = plus('0', 7)
    lda #plus.return
    sta SCREEN
    // }
    rts
}
// char plus(char a, char b)
plus: {
    .const a = '0'
    .const b = 7
    .label return = a+b
    rts
}

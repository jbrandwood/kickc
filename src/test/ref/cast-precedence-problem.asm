// Tests that casting inside constants in the output handles precedence between cast and + correctly - should generate the following KA-expression ($ff & sumw>>1)+1
  // Commodore 64 PRG executable file
.file [name="cast-precedence-problem.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .const min = $a
    .const max = $c8
    .const sumw = min+max
    .const sumb = min+max
    .const midw = (sumw>>1)+1
    .const midb = (sumb>>1)+1
    .label SCREEN = $400
    .label BG_COLOR = $d021
    // SCREEN[0] = midw
    lda #midw
    sta SCREEN
    // SCREEN[1] = midb
    lda #midb
    sta SCREEN+1
    // if(SCREEN[0]==SCREEN[1])
    lda SCREEN
    cmp SCREEN+1
    beq __b1
    // *BG_COLOR = 2
    lda #2
    sta BG_COLOR
    // }
    rts
  __b1:
    // *BG_COLOR = 5
    lda #5
    sta BG_COLOR
    rts
}

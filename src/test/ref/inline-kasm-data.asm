// Example of inline kickasm data
  // Commodore 64 PRG executable file
.file [name="inline-kasm-data.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label screen = 2
    .label cols = 4
    lda #<$d800
    sta.z cols
    lda #>$d800
    sta.z cols+1
    lda #<$400
    sta.z screen
    lda #>$400
    sta.z screen+1
    ldx #0
  __b1:
    // sin = sintab[i]
    ldy sintab,x
    // screen[sin] = '*'
    lda #'*'
    sta (screen),y
    // screen += 40
    lda #$28
    clc
    adc.z screen
    sta.z screen
    bcc !+
    inc.z screen+1
  !:
    // cols[sin] = 1
    lda #1
    sta (cols),y
    // cols += 40
    lda #$28
    clc
    adc.z cols
    sta.z cols
    bcc !+
    inc.z cols+1
  !:
    // for(byte i:0..24)
    inx
    cpx #$19
    bne __b1
    // }
    rts
}
.segment Data
.pc = $1000 "sintab"
sintab:
.fill 25, 20 + 20*sin(toRadians(i*360/25))


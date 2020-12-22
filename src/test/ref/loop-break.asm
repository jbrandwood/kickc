// Tests break statement in a simple loop
  // Commodore 64 PRG executable file
.file [name="loop-break.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    ldx #0
  __b1:
    // if(SCREEN[i]=='a')
    lda SCREEN,x
    cmp #'a'
    beq __breturn
    // SCREEN[i] = 'a'
    lda #'a'
    sta SCREEN,x
    // for( byte i: 0..40*6)
    inx
    cpx #$28*6+1
    bne __b1
  __breturn:
    // }
    rts
}

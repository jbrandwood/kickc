// Test fragment promotion of a constant (400) to signed word even if it also matches an unsigned word
  // Commodore 64 PRG executable file
.file [name="const-signed-promotion.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label screen = $400
    ldx #0
  __b1:
    // world[i]= 400
    txa
    asl
    tay
    lda #<$190
    sta world,y
    lda #>$190
    sta world+1,y
    // for(byte i:0..2)
    inx
    cpx #3
    bne __b1
    // *screen = world[0]
    lda world
    sta screen
    lda world+1
    sta screen+1
    // }
    rts
}
.segment Data
  world: .fill 2*3, 0

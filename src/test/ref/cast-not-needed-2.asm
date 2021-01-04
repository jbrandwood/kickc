// Tests a cast that is not needed
  // Commodore 64 PRG executable file
.file [name="cast-not-needed-2.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label getScreen1_return = 2
    .label spritePtr1_return = 2
    // return screens[id];
    lda screens
    sta.z getScreen1_return
    lda screens+1
    sta.z getScreen1_return+1
    // screen+$378
    clc
    lda.z spritePtr1_return
    adc #<$378
    sta.z spritePtr1_return
    lda.z spritePtr1_return+1
    adc #>$378
    sta.z spritePtr1_return+1
    // *spritePtr(screen) = $22
    lda #$22
    ldy #0
    sta (spritePtr1_return),y
    // }
    rts
}
.segment Data
  screens: .word $400, $1400

// Tests a cast that is not needed
  // Commodore 64 PRG executable file
.file [name="cast-not-needed-3.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label DSP = $400
    .label spritePtr1___0 = 2
    .label getScreen1_return = 2
    // return screens[id];
    lda screens
    sta.z getScreen1_return
    lda screens+1
    sta.z getScreen1_return+1
    // screen+$378
    clc
    lda.z spritePtr1___0
    adc #<$378
    sta.z spritePtr1___0
    lda.z spritePtr1___0+1
    adc #>$378
    sta.z spritePtr1___0+1
    // return (byte)*(screen+$378);
    ldy #0
    lda (spritePtr1___0),y
    // DSP[0] = spritePtr(getScreen(0))
    sta DSP
    // }
    rts
}
.segment Data
  screens: .word $400, $1400

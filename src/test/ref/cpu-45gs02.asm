// Test the 45GS02 CPU
// A program that uses 45GS02 instructions
.cpu _45gs02
  // Commodore 64 PRG executable file
.file [name="cpu-45gs02.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    .label sum = 7
    .label addend = 3
    .label i = 2
    lda #<$1e240
    sta.z addend
    lda #>$1e240
    sta.z addend+1
    lda #<$1e240>>$10
    sta.z addend+2
    lda #>$1e240>>$10
    sta.z addend+3
    lda #<0
    sta.z sum
    sta.z sum+1
    lda #<0>>$10
    sta.z sum+2
    lda #>0>>$10
    sta.z sum+3
    lda #0
    sta.z i
  __b1:
    // for(char i=0;i<100;i++)
    lda.z i
    cmp #$64
    bcc __b2
    // *SCREEN = sum
    ldq.z sum
    stq SCREEN
    // }
    rts
  __b2:
    // sum += addend
    clc
    ldq.z sum
    adcq.z addend
    stq.z sum
    // addend += i
    // will utilize ADQ/STQ
    lda.z i
    clc
    adc.z addend
    sta.z addend
    lda.z addend+1
    adc #0
    sta.z addend+1
    lda.z addend+2
    adc #0
    sta.z addend+2
    lda.z addend+3
    adc #0
    sta.z addend+3
    // for(char i=0;i<100;i++)
    inc.z i
    jmp __b1
}

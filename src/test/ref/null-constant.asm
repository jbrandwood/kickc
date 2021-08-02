// Test the NULL pointer
  // Commodore 64 PRG executable file
.file [name="null-constant.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_POINTER = 2
  .label screen = 4
.segment Code
main: {
    .label ptr = 2
    lda #<ptrs
    sta.z ptr
    lda #>ptrs
    sta.z ptr+1
  __b1:
    // for(char ** ptr = ptrs; *ptr; ptr++)
    ldy #0
    tya
    cmp (ptr),y
    bne __b2
    iny
    cmp (ptr),y
    bne __b2
    // }
    rts
  __b2:
    // **ptr = 'a'
    lda #'a'
    pha
    ldy #1
    lda (ptr),y
    sta.z $ff
    dey
    lda (ptr),y
    sta.z $fe
    pla
    sta ($fe),y
    // screen = *ptr
    ldy #0
    lda (ptr),y
    sta.z screen
    iny
    lda (ptr),y
    sta.z screen+1
    // screen[1] = 'b'
    lda #'b'
    ldy #1
    sta (screen),y
    // for(char ** ptr = ptrs; *ptr; ptr++)
    lda #SIZEOF_POINTER
    clc
    adc.z ptr
    sta.z ptr
    bcc !+
    inc.z ptr+1
  !:
    jmp __b1
}
.segment Data
  ptrs: .word $400, $450, $4a0, 0

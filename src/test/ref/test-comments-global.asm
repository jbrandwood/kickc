// Tests that global variables with initializer gets their comments
  // Commodore 64 PRG executable file
.file [name="test-comments-global.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  // The screen (should become a var-comment in ASM)
  .label screen = 2
.segment Code
__start: {
    // screen = 0x0400
    lda #<$400
    sta.z screen
    lda #>$400
    sta.z screen+1
    jsr main
    rts
}
// The program entry point
main: {
    // *screen = 'a'
    // Put 'a' in screen
    lda #'a'
    ldy #0
    sta (screen),y
    // screen++;
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    // *screen = 'a'
    // Put another 'a' in screen
    lda #'a'
    ldy #0
    sta (screen),y
    // }
    rts
}

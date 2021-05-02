  // Commodore 64 PRG executable file
.file [name="typedef-2.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  .label SCREEN = $400
  .label ptr = 2
.segment Code
__start: {
    // char* ptr = 0x1000
    lda #<$1000
    sta.z ptr
    lda #>$1000
    sta.z ptr+1
    jsr main
    rts
}
main: {
    // SCREEN[0] = <w
    lda #<ptr+$32
    sta SCREEN
    // }
    rts
}

// Complex procedure declaration and definition.
  // Commodore 64 PRG executable file
.file [name="procedure-declare-10.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_BYTE = 1
  .label SCREEN = $400
.segment Code
main: {
    // memcpy(SCREEN, STRING, sizeof(STRING))
    jsr memcpy
    // }
    rts
}
// Copy block of memory (forwards)
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination.
memcpy: {
    .const num = $c*SIZEOF_BYTE
    .label destination = SCREEN
    .label source = STRING
    .label src_end = source+num
    .label dst = 4
    .label src = 2
    lda #<destination
    sta.z dst
    lda #>destination
    sta.z dst+1
    lda #<source
    sta.z src
    lda #>source
    sta.z src+1
  __b1:
    // while(src!=src_end)
    lda.z src+1
    cmp #>src_end
    bne __b2
    lda.z src
    cmp #<src_end
    bne __b2
    // }
    rts
  __b2:
    // *dst++ = *src++
    ldy #0
    lda (src),y
    sta (dst),y
    // *dst++ = *src++;
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    inc.z src
    bne !+
    inc.z src+1
  !:
    jmp __b1
}
.segment Data
  STRING: .text "hello world"
  .byte 0

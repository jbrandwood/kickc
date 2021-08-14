// Test the NULL pointer
  // Commodore 64 PRG executable file
.file [name="null-constant-1.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label SCREEN = $400
    // get(SCREEN)
    lda #<SCREEN
    sta.z get.ptr
    lda #>SCREEN
    sta.z get.ptr+1
    jsr get
    // get(SCREEN)
    // SCREEN[1] = get(SCREEN)
    sta SCREEN+1
    // get(NULL)
    lda #<0
    sta.z get.ptr
    sta.z get.ptr+1
    jsr get
    // get(NULL)
    // SCREEN[0] = get(NULL)
    sta SCREEN
    // }
    rts
}
// __register(A) char get(__zp(2) char *ptr)
get: {
    .label ptr = 2
    // if(NULL==ptr)
    lda.z ptr
    ora.z ptr+1
    bne __b1
    lda #0
    rts
  __b1:
    // return *ptr;
    ldy #0
    lda (ptr),y
    // }
    rts
}

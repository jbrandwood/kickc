// A function that returns a constant boolean crashes the compiler because it produces illegal ASM
  // Commodore 64 PRG executable file
.file [name="const-bool-return-problem.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    .label ox = 3
    .label oy = 2
    lda #0
    sta.z ox
  __b1:
    // for(char ox=0;ox<5;ox++)
    lda.z ox
    cmp #5
    bcc __b4
    // }
    rts
  __b4:
    lda #0
    sta.z oy
  __b2:
    // for(char oy=0;oy<5;oy++)
    lda.z oy
    cmp #5
    bcc __b3
    // for(char ox=0;ox<5;ox++)
    inc.z ox
    jmp __b1
  __b3:
    // OBJ_is_solid(ox,oy)
    lda.z oy
    jsr OBJ_is_solid
    // if(OBJ_is_solid(ox,oy))
    cmp #0
    bne __b6
    jmp __b5
  __b6:
    // SCREEN[ox] = oy
    lda.z oy
    ldy.z ox
    sta SCREEN,y
  __b5:
    // for(char oy=0;oy<5;oy++)
    inc.z oy
    jmp __b2
}
// __register(A) bool OBJ_is_solid(char ox, __register(A) char oy)
OBJ_is_solid: {
    // if (oy==oy)
    tax
    tay
    stx.z $ff
    cpy.z $ff
    bne __b1
    lda #1
    rts
  __b1:
    // tile_flag_at()
    jsr tile_flag_at
    lda #tile_flag_at.return
    // }
    rts
}
tile_flag_at: {
    .label return = 0
    rts
}

// Demonstrates problem with structs containing arrays and auto-type conversion
// https://gitlab.com/camelot/kickc/-/issues/593
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_STRUCT_HOSTSLOTS = 0
  .label OUT = $8000
main: {
    // slots1 = {"some data that would fit a normal 8x32 double array"}
    ldy #SIZEOF_STRUCT_HOSTSLOTS
  !:
    lda __0-1,y
    sta slots1-1,y
    dey
    bne !-
    // slots2 = {"more data that would fit a normal 8x32 double array"}
    ldy #SIZEOF_STRUCT_HOSTSLOTS
  !:
    lda __1-1,y
    sta slots2-1,y
    dey
    bne !-
    // doStuff(&slots1)
    lda #<slots1
    sta.z doStuff.hs
    lda #>slots1
    sta.z doStuff.hs+1
    jsr doStuff
    // doStuff(&slots2)
    lda #<slots2
    sta.z doStuff.hs
    lda #>slots2
    sta.z doStuff.hs+1
    jsr doStuff
    // }
    rts
    slots1: .fill SIZEOF_STRUCT_HOSTSLOTS, 0
    slots2: .fill SIZEOF_STRUCT_HOSTSLOTS, 0
}
// doStuff(struct hostslots* zp(2) hs)
doStuff: {
    .label hsp = 5
    .label i = 4
    .label hs = 2
    lda #0
    sta.z i
  __b1:
    // for(unsigned char i = 0; i < 8; i++)
    lda.z i
    cmp #8
    bcc __b2
    // }
    rts
  __b2:
    // i * HOSTSLOT_SIZE
    lda.z i
    asl
    asl
    asl
    asl
    asl
    // hsp = hs->host[i * HOSTSLOT_SIZE]
    // should be:
    // if (hs->host[i][0] != 0) {
    .assert "Missing ASM fragment Fragment not found pbuz1=_ptr_pbuz2_derefidx_vbuaa. Attempted variations pbuz1=_ptr_pbuz2_derefidx_vbuaa ", 0, 1
    // if (*hsp != 0)
    ldy #0
    lda (hsp),y
    cmp #0
    bne __b3
    // *(OUT + i) = 2
    lda #2
    ldy.z i
    sta OUT,y
  __b4:
    // for(unsigned char i = 0; i < 8; i++)
    inc.z i
    jmp __b1
  __b3:
    // *(OUT + i) = 1
    lda #1
    ldy.z i
    sta OUT,y
    jmp __b4
}
  __0: .text "some data that would fit a normal 8x32 double array"
  .byte 0
  .fill $cc, 0
  __1: .text "more data that would fit a normal 8x32 double array"
  .byte 0
  .fill $cc, 0

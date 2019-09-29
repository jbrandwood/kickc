// Adding a missing word-fragment for Travis Fisher
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const MAX_OBJECTS = $10
main: {
    ldy #0
  __b1:
    jsr move_enemy
    iny
    cpy #6
    bne __b1
    rts
}
// move_enemy(byte register(Y) obj_slot)
move_enemy: {
    tya
    asl
    tax
    lda OBJ_WORLD_X,x
    bne !+
    dec OBJ_WORLD_X+1,x
  !:
    dec OBJ_WORLD_X,x
    rts
}
  OBJ_WORLD_X: .fill 2*MAX_OBJECTS, 0

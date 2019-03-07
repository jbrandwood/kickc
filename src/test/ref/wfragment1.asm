// Adding a missing word-fragment for Travis Fisher
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const MAX_OBJECTS = $10
main: {
    ldy #0
  b1:
    jsr move_enemy
    iny
    cpy #6
    bne b1
    rts
}
// move_enemy(byte register(Y) obj_slot)
move_enemy: {
    sec
    lda OBJ_WORLD_X,y
    sbc #1
    sta OBJ_WORLD_X,y
    lda OBJ_WORLD_X+1,y
    sbc #0
    sta OBJ_WORLD_X+1,y
    rts
}
  OBJ_WORLD_X: .fill 2*MAX_OBJECTS, 0

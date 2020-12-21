// Adding a missing word-fragment for Travis Fisher
  // Commodore 64 PRG executable file
.file [name="wfragment1.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const MAX_OBJECTS = $10
.segment Code
main: {
    ldy #0
  __b1:
    // move_enemy(i)
    tya
    jsr move_enemy
    // for(byte i:0..5)
    iny
    cpy #6
    bne __b1
    // }
    rts
}
// move_enemy(byte register(A) obj_slot)
move_enemy: {
    // OBJ_WORLD_X[obj_slot] -= 1
    asl
    tax
    lda OBJ_WORLD_X,x
    bne !+
    dec OBJ_WORLD_X+1,x
  !:
    dec OBJ_WORLD_X,x
    // }
    rts
}
.segment Data
  OBJ_WORLD_X: .fill 2*MAX_OBJECTS, 0

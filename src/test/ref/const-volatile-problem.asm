// Demonstrates problem where a pointer with constant value is never assigned - because it is only used in an IRQ
// PLEX_SCREEN_PTR1 is never assigned - while PLEX_SCREEN_PTR2 receives it's value.
// PLEX_SCREEN_PTR2 is saved by only being assigned once - thus is is identified as a constant.
// All assignments for PLEX_SCREEN_PTR1 are optimized away because it is only used in the IRQ.
// A potential fix is https://gitlab.com/camelot/kickc/-/issues/430
.pc = $801 "Basic"
:BasicUpstart(__start)
.pc = $80d "Program"
  .label IRQ = $314
  .label PLEX_SCREEN_PTR2 = $400+$3f8
  .label plex_sprite_idx = 4
  // The address of the sprite pointers on the current screen (screen+0x3f8).
  .label PLEX_SCREEN_PTR1 = 2
__start: {
    // plex_sprite_idx = 0
    lda #0
    sta.z plex_sprite_idx
    jsr main
    rts
}
// Interrupt Routine
irq: {
    // PLEX_SCREEN_PTR1[plex_sprite_idx] = 7
    lda #7
    ldy.z plex_sprite_idx
    sta (PLEX_SCREEN_PTR1),y
    // PLEX_SCREEN_PTR2[plex_sprite_idx] = 7
    sta PLEX_SCREEN_PTR2,y
    // plex_sprite_idx++;
    inc.z plex_sprite_idx
    // }
    jmp $ea31
}
main: {
    // *IRQ = &irq
    lda #<irq
    sta IRQ
    lda #>irq
    sta IRQ+1
    // }
    rts
}

// Demonstrates problem where a pointer with constant value is never assigned - because it is only used in an IRQ
// PLEX_SCREEN_PTR1 is never assigned - while PLEX_SCREEN_PTR2 receives it's value.
// PLEX_SCREEN_PTR2 is saved by only being assigned once - thus is is identified as a constant.
// All assignments for PLEX_SCREEN_PTR1 are optimized away because it is only used in the IRQ.
// A potential fix is https://gitlab.com/camelot/kickc/-/issues/430
  // Commodore 64 PRG executable file
.file [name="const-volatile-problem.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  .label IRQ = $314
  .label PLEX_SCREEN_PTR2 = $500
  .label idx = 4
  // The address of the sprite pointers on the current screen (screen+0x3f8).
  .label PLEX_SCREEN_PTR1 = 2
.segment Code
__start: {
    // volatile char idx = 0
    lda #0
    sta.z idx
    jsr main
    rts
}
// Interrupt Routine
irq: {
    // PLEX_SCREEN_PTR1[idx]++;
    ldy.z idx
    lda (PLEX_SCREEN_PTR1),y
    clc
    adc #1
    sta (PLEX_SCREEN_PTR1),y
    // PLEX_SCREEN_PTR2[idx]++;
    ldx.z idx
    inc PLEX_SCREEN_PTR2,x
    // idx++;
    inc.z idx
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

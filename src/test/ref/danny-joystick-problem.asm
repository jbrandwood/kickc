// Tests problem writing/reading joystick encountered by Danny Spijksma
// https://www.protovision.games/hardw/build4player.php?language=en&fbclid=IwAR1MJLgQjOU0zVa0ax2aNeGa-xVbE9IGY9zC6b6eInTV4HQzoUAoCPoXu14
  // Commodore 64 PRG executable file
.file [name="danny-joystick-problem.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const OFFSET_STRUCT_MOS6526_CIA_PORT_B = 1
  // The CIA#2: Serial bus, RS-232, VIC memory bank
  .label CIA2 = $dd00
  .label SCREEN = $400
.segment Code
main: {
    // (CIA2->PORT_B) &= 0x7f
    lda #$7f
    and CIA2+OFFSET_STRUCT_MOS6526_CIA_PORT_B
    sta CIA2+OFFSET_STRUCT_MOS6526_CIA_PORT_B
    // asm
    lda #0
    // char port4Value = CIA2->PORT_B
    lda CIA2+OFFSET_STRUCT_MOS6526_CIA_PORT_B
    // *SCREEN = port4Value
    sta SCREEN
    // }
    rts
}

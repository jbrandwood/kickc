// Test declaring a variable as "memory", meaning it will be stored in memory and accessed through an implicit pointer (using load/store)
// Test a memory variable struct value - containing a fixed size array
  // Commodore 64 PRG executable file
.file [name="declared-memory-var-4.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const OFFSET_STRUCT_FOO_THING2 = 1
  .const OFFSET_STRUCT_FOO_THING3 = 2
.segment Code
main: {
    .label SCREEN = $400
    .label barp = bar
    // SCREEN[i++] = barp->thing1
    lda barp
    sta SCREEN
    // SCREEN[i++] = barp->thing2
    lda barp+OFFSET_STRUCT_FOO_THING2
    sta SCREEN+1
    ldx #2
    ldy #0
  __b1:
    // SCREEN[i++] = barp->thing3[j]
    lda barp+OFFSET_STRUCT_FOO_THING3,y
    sta SCREEN,x
    // SCREEN[i++] = barp->thing3[j];
    inx
    // for( char j: 0..11)
    iny
    cpy #$c
    bne __b1
    // }
    rts
}
.segment Data
  bar: .byte 'a', 'b'
  .text "qwe"
  .byte 0
  .fill 8, 0

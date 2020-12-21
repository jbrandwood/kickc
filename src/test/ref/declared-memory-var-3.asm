// Test declaring a variable as "memory", meaning it will be stored in memory and accessed through an implicit pointer (using load/store)
// Test a memory variable struct value
  // Commodore 64 PRG executable file
.file [name="declared-memory-var-3.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const OFFSET_STRUCT_FOO_THING2 = 1
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
    // }
    rts
}
.segment Data
  bar: .byte 'a', 'b'

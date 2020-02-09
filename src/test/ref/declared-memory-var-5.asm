// Test declaring a variable as "memory", meaning it will be stored in memory and accessed through an implicit pointer (using load/store)
// Test a memory variable struct value
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const OFFSET_STRUCT_FOO_THING2 = 1
main: {
    .label SCREEN = $400
    lda bar
    sta SCREEN
    lda bar+OFFSET_STRUCT_FOO_THING2
    sta SCREEN+1
    rts
}
  bar: .byte 'a', 'b'

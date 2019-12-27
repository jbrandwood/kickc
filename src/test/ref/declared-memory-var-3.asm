// Test declaring a variable as "memory", meaning it will be stored in memory and accessed through an implicit pointer (using load/store)
// Test a memory variable struct value
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  .const OFFSET_STRUCT_FOO_THING2 = 1
__bbegin:
  lda #'a'
  sta bar
  lda #'b'
  sta bar+OFFSET_STRUCT_FOO_THING2
  jsr main
  rts
main: {
    .label SCREEN = $400
    .label barp = bar
    lda barp
    sta SCREEN
    lda barp+OFFSET_STRUCT_FOO_THING2
    sta SCREEN+1
    rts
}
  bar: .byte 0, 0

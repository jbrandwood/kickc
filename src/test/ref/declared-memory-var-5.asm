// Test declaring a variable as "memory", meaning it will be stored in memory and accessed through an implicit pointer (using load/store)
// Test a memory variable struct value
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
__bbegin:
  lda #'a'
  sta bar_thing1
  lda #'b'
  sta bar_thing2
  jsr main
  rts
main: {
    .label SCREEN = $400
    lda bar_thing1
    sta SCREEN
    lda bar_thing2
    sta SCREEN+1
    rts
}
  bar_thing1: .byte 0
  bar_thing2: .byte 0

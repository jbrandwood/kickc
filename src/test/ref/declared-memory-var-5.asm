// Test declaring a variable as "memory", meaning it will be stored in memory and accessed through an implicit pointer (using load/store)
// Test a memory variable struct value
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  .const SIZEOF_STRUCT_FOO = 2
  .const OFFSET_STRUCT_FOO_THING2 = 1
__bbegin:
  ldy #SIZEOF_STRUCT_FOO
!:
  lda __0-1,y
  sta bar-1,y
  dey
  bne !-
  jsr main
  rts
main: {
    .label SCREEN = $400
    lda bar
    sta SCREEN
    lda bar+OFFSET_STRUCT_FOO_THING2
    sta SCREEN+1
    rts
}
  __0: .byte 'a', 'b'
  bar: .fill SIZEOF_STRUCT_FOO, 0

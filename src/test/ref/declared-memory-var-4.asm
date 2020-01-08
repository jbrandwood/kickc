// Test declaring a variable as "memory", meaning it will be stored in memory and accessed through an implicit pointer (using load/store)
// Test a memory variable struct value - containing a fixed size array
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  .const SIZEOF_STRUCT_FOO = $e
  .const OFFSET_STRUCT_FOO_THING2 = 1
  .const OFFSET_STRUCT_FOO_THING3 = 2
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
    .label barp = bar
    lda barp
    sta SCREEN
    lda barp+OFFSET_STRUCT_FOO_THING2
    sta SCREEN+1
    ldx #2
    ldy #0
  __b1:
    lda barp+OFFSET_STRUCT_FOO_THING3,y
    sta SCREEN,x
    inx
    iny
    cpy #$c
    bne __b1
    rts
}
  __0: .byte 'a', 'b'
  .text "qwe"
  .byte 0
  .fill 8, 0
  bar: .fill SIZEOF_STRUCT_FOO, 0

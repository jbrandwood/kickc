// Test declaring a variable as "memory", meaning it will be stored in memory and accessed through an implicit pointer (using load/store)
// Test a memory variable struct value - containing a fixed size array
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const OFFSET_STRUCT_FOO_THING2 = 1
  .const OFFSET_STRUCT_FOO_THING3 = 2
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
  bar: .byte 'a', 'b'
  .text "qwe"
  .byte 0
  .fill 8, 0

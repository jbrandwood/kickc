// Test declaring a variable as "memory", meaning it will be stored in memory and accessed through an implicit pointer (using load/store)
// Test a memory variable struct value
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  .const OFFSET_STRUCT_FOO_THING2 = 1
  .label bar_ptr = bar_thing1
  .label bar_thing1 = 2
  .label bar_thing2 = 3
__bbegin:
  lda #'a'
  sta.z bar_thing1
  lda #'b'
  sta.z bar_thing2
  jsr main
  rts
main: {
    .label SCREEN = $400
    .label barp = 4
    lda #<bar_ptr
    sta.z barp
    lda #>bar_ptr
    sta.z barp+1
    ldy #0
    lda (barp),y
    sta SCREEN
    ldy #OFFSET_STRUCT_FOO_THING2
    lda (barp),y
    sta SCREEN+1
    rts
}

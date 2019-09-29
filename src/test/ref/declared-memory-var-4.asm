// Test declaring a variable as "memory", meaning it will be stored in memory and accessed through an implicit pointer (using load/store)
// Test a memory variable struct value - containing a fixed size array
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  .const OFFSET_STRUCT_FOO_THING2 = 1
  .const OFFSET_STRUCT_FOO_THING3 = 2
  .label bar_ptr = bar_thing1
  .label bar_thing1 = 2
  .label bar_thing2 = 3
  .label bar_thing3 = 4
__bbegin:
  lda #'a'
  sta.z bar_thing1
  lda #'b'
  sta.z bar_thing2
  lda #<__0
  sta.z bar_thing3
  lda #>__0
  sta.z bar_thing3+1
  jsr main
  rts
main: {
    .label SCREEN = $400
    .label __4 = 8
    .label barp = 6
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
    ldx #2
    ldy #0
  __b1:
    lda #OFFSET_STRUCT_FOO_THING3
    clc
    adc.z barp
    sta.z __4
    lda #0
    adc.z barp+1
    sta.z __4+1
    lda (__4),y
    sta SCREEN,x
    inx
    iny
    cpy #$c
    bne __b1
    rts
}
  __0: .text "qwe"
  .byte 0

// Test declaring a variable as "memory", meaning it will be stored in memory and accessed through an implicit pointer (using load/store)
// Test a memory variable struct value
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const bar_thing1 = 'a'
  .const bar_thing2 = 'b'
main: {
    .label SCREEN = $400
    lda #bar_thing1
    sta SCREEN
    lda #bar_thing2
    sta SCREEN+1
    rts
}

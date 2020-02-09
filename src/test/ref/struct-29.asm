// Minimal struct with C-Standard behavior - global main-mem struct should be initialized in data, not code
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const OFFSET_STRUCT_POINT_INITIALS = 1
main: {
    lda point1
    sta SCREEN
    lda point1+OFFSET_STRUCT_POINT_INITIALS
    sta SCREEN+1
    lda point1+OFFSET_STRUCT_POINT_INITIALS+1
    sta SCREEN+2
    rts
}
  point1: .byte 2, 'j', 'g'

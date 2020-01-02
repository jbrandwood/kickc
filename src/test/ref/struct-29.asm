// Minimal struct with C-Standard behavior - global main-mem struct should be initialized in data, not code
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  .label SCREEN = $400
  .const OFFSET_STRUCT_POINT_INITIALS = 1
__bbegin:
  lda #2
  sta point1
  tay
!:
  lda __0-1,y
  sta point1+OFFSET_STRUCT_POINT_INITIALS-1,y
  dey
  bne !-
  jsr main
  rts
main: {
    lda point1
    sta SCREEN
    lda point1+OFFSET_STRUCT_POINT_INITIALS
    sta SCREEN+1
    lda point1+OFFSET_STRUCT_POINT_INITIALS+1
    sta SCREEN+2
    rts
}
  __0: .byte 'j', 'g'
  point1: .byte 0

// Tests that inline kickasm supports the clobbering directive
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    .label l = 3
    .label k = 2
    lda #0
    sta.z k
  b1:
    lda #0
    sta.z l
  b2:
    ldy #0
  b3:
    lda #0
                    ldx #0
                    sta SCREEN,x
                
    iny
    cpy #$b
    bne b3
    inc.z l
    lda #$b
    cmp.z l
    bne b2
    inc.z k
    cmp.z k
    bne b1
    rts
}

// java.lang.NullPointerException during Pass2TypeInference.java
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
// Initialize the mulf_sqr multiplication tables with f(x)=int(x*x/2) and g(x) = f(1-x) 
main: {
    ldy #0
  b1:
    tya
    eor #$ff
    tax
    axs #-$ff-1
    lda #0
    sta table,x
    iny
    cpy #$81
    bne b1
    rts
}
  table: .fill $100, 0

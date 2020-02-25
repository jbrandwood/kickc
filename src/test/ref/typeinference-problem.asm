// java.lang.NullPointerException during Pass2TypeInference.java
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
// Initialize the mulf_sqr multiplication tables with f(x)=int(x*x/2) and g(x) = f(1-x) 
main: {
    ldy #0
  __b1:
    // 255-i
    tya
    eor #$ff
    tax
    axs #-$ff-1
    // table[255-i] = 0
    lda #0
    sta table,x
    // for( byte i:0..128)
    iny
    cpy #$81
    bne __b1
    // }
    rts
}
  table: .fill $100, 0

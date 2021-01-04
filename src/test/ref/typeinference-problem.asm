// java.lang.NullPointerException during Pass2TypeInference.java
  // Commodore 64 PRG executable file
.file [name="typeinference-problem.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
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
.segment Data
  table: .fill $100, 0

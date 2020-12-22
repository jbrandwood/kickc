// Tests the different ASM addressing modes
.cpu _65c02
  // Commodore 64 PRG executable file
.file [name="cpu-65c02-addressing-modes.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    // asm
    inx
    lda #$12
    lda.z $12
    lda.z $12,x
    ldx.z $12,y
    ora.z ($12)
    lda ($12,x)
    lda ($12),y
    lda $1234
    lda $1234,x
    lda $1234,y
    beq lbl1
    bbr0 $12,lbl2
  lbl1:
    jmp ($1234)
  lbl2:
    jmp ($1234,x)
    // }
}

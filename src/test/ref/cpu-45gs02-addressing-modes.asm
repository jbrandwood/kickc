// Tests the different ASM addressing modes
.cpu _45gs02
  // Commodore 64 PRG executable file
.file [name="cpu-45gs02-addressing-modes.prg", type="prg", segments="Program"]
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
    phw #$1234
    lda.z $12
    lda.z $12,x
    ldx.z $12,y
    lda ($12,x)
    lda ($12),y
    ora ($12),z
    lda ($12,sp),y
    lda $1234
    lda $1234,x
    lda $1234,y
    beq lbl1
    lbeq far
    bbr0 $12,lbl2
  lbl1:
    jmp ($1234)
  lbl2:
    jmp ($1234,x)
  lbl3:
    ldq ($12),z
    lda (($12)),z
    ldq (($12)),z
    stq (($12))
    // }
    rts
}
.segment Data
.pc = $2000 "far"
  far: .byte $60

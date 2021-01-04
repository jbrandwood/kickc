// Tests encoding of literal chars
  // Commodore 64 PRG executable file
.file [name="encoding-literal-char.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.encoding "petscii_mixed"
  .const cpm = 'A'
.encoding "petscii_upper"
  .const ccpu = 'A'
.encoding "screencode_mixed"
  .const csm = 'A'
.encoding "screencode_upper"
  .const csu = 'A'
  .label screen = $400
.segment Code
main: {
    // screen[idx++] = cpm
    lda #cpm
    sta screen
    // screen[idx++] = ccpu
    lda #ccpu
    sta screen+1
    // screen[idx++] = csm
    lda #csm
    sta screen+2
    // screen[idx++] = csu
    lda #csu
    sta screen+3
    // screen[idx++] = spm[0]
    lda spm
    sta screen+$28
    // screen[idx++] = spu[0]
    lda spu
    sta screen+$29
    // screen[idx++] = ssm[0]
    lda ssm
    sta screen+$2a
    // screen[idx++] = ssu[0]
    lda ssu
    sta screen+$2b
    // }
    rts
}
.segment Data
.encoding "petscii_mixed"
  spm: .text "A"
  .byte 0
.encoding "petscii_upper"
  spu: .text "A"
  .byte 0
.encoding "screencode_mixed"
  ssm: .text "A"
  .byte 0
.encoding "screencode_upper"
  ssu: .text "A"
  .byte 0

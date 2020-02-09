.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_STRUCT_FILEENTRY = 2
  .label filesEnd = 0
  .label dir = 0
main: {
    .label file = 2
    lda #<0
    sta.z file
    sta.z file+1
  __b1:
    lda.z file+1
    cmp #>filesEnd
    bne __b2
    lda.z file
    cmp #<filesEnd
    bne __b2
    rts
  __b2:
    jsr PrintName
    lda #SIZEOF_STRUCT_FILEENTRY
    clc
    adc.z file
    sta.z file
    bcc !+
    inc.z file+1
  !:
    jmp __b1
}
// PrintName(struct fileentry* zp(2) file)
PrintName: {
    .label file = 2
    lda.z file+1
    cmp #>dir
    bne __breturn
    lda.z file
    cmp #<dir
    bne __breturn
    lda #1
    sta $c7
  __breturn:
    rts
}

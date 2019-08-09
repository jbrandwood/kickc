// XMega65 Kernal Development Template
// Each function of the kernal is a no-args function
// The functions are placed in the SYSCALLS table surrounded by JMP and NOP
  .file [name="xmega65.bin", type="bin", segments="XMega65Bin"]
.segmentdef XMega65Bin [segments="Syscall, Code, Data, Stack, Zeropage"]
.segmentdef Syscall [start=$8000, max=$81ff]
.segmentdef Code [start=$8200, min=$8200, max=$bdff]
.segmentdef Data [startAfter="Code", min=$8200, max=$bdff]
.segmentdef Stack [min=$be00, max=$beff, fill]
.segmentdef Zeropage [min=$bf00, max=$bfff, fill]
  .const JMP = $4c
  .const NOP = $ea
  .label CALLS = SYSCALLS+1
.segment Code
main: {
    .label fn = 3
    .label i = 2
  b1:
    lda #0
    sta.z i
  // Call functions one at a time
  b2:
    lda.z i
    asl
    asl
    tay
    lda CALLS,y
    sta.z fn
    lda CALLS+1,y
    sta.z fn+1
    jsr bi_fn
    inc.z i
    lda #2
    cmp.z i
    bne b2
    jmp b1
  bi_fn:
    jmp (fn)
}
fn2: {
    .label BGCOL = $d021
    inc BGCOL
    rts
}
fn1: {
    .label BORDERCOL = $d020
    inc BORDERCOL
    rts
}
.segment Syscall
  SYSCALLS: .byte JMP, <fn1, >fn1, NOP, JMP, <fn2, >fn2, NOP

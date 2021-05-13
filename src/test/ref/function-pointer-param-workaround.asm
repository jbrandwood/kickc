// Demonstrates work-around for passing parameters to function pointers
// Save the return address, declare parameter variables
// Restore the return address
// Declare and pull a char parameter
// Begin passing parameters using the stack. Declares parameter variables.
// Pass a char parameter
  // Commodore 64 PRG executable file
.file [name="function-pointer-param-workaround.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  .label SCREEN1 = $400
  .label SCREEN2 = $428
  .label idx1 = 4
  .label idx2 = 5
.segment Code
__start: {
    // volatile char idx1 = 0
    lda #0
    sta.z idx1
    // volatile char idx2 = 0
    sta.z idx2
    jsr main
    rts
}
fn2: {
    .label ret_addr = 6
    .label param_char = 8
    // PARAM_BEGIN
    lda #<0
    sta.z ret_addr
    sta.z ret_addr+1
    sta.z param_char
    pla
    sta ret_addr
    pla
    sta ret_addr+1
    // PARAM_CHAR
    pla
    sta param_char
    tay
    pla
    sta param_char
    tax
    // PARAM_END
    lda ret_addr+1
    pha
    lda ret_addr
    pha
    // SCREEN2[idx2++] = b
    // Function body
    tya
    ldy.z idx2
    sta SCREEN2,y
    // SCREEN2[idx2++] = b;
    inc.z idx2
    // SCREEN2[idx2++] = c
    ldy.z idx2
    txa
    sta SCREEN2,y
    // SCREEN2[idx2++] = c;
    inc.z idx2
    // }
    rts
}
fn1: {
    .label ret_addr = 9
    .label param_char = $b
    // PARAM_BEGIN
    lda #<0
    sta.z ret_addr
    sta.z ret_addr+1
    sta.z param_char
    pla
    sta ret_addr
    pla
    sta ret_addr+1
    // PARAM_CHAR
    pla
    sta param_char
    tay
    pla
    sta param_char
    tax
    // PARAM_END
    lda ret_addr+1
    pha
    lda ret_addr
    pha
    // SCREEN1[idx1++] = b
    // Function body
    tya
    ldy.z idx1
    sta SCREEN1,y
    // SCREEN1[idx1++] = b;
    inc.z idx1
    // SCREEN1[idx1++] = c
    ldy.z idx1
    txa
    sta SCREEN1,y
    // SCREEN1[idx1++] = c;
    inc.z idx1
    // }
    rts
}
main: {
    .label param_char = $c
    .label f = $d
    .label j = 3
    .label i = 2
    lda #'a'
    sta.z i
  __b1:
    // for(char i='a';i<='p';i++)
    lda #'p'
    cmp.z i
    bcs __b4
    // }
    rts
  __b4:
    lda #0
    sta.z j
  __b2:
    // for(char j=0;j<2;j++)
    lda.z j
    cmp #2
    bcc __b3
    // for(char i='a';i<='p';i++)
    inc.z i
    jmp __b1
  __b3:
    // CALL_BEGIN
    lda #0
    sta.z param_char
    // CALL_CHAR
    lda.z i
    sta.z param_char
    pha
    lda.z j
    sta.z param_char
    pha
    // void(*f)() = fns[j]
    lda.z j
    asl
    tay
    lda fns,y
    sta.z f
    lda fns+1,y
    sta.z f+1
    // (*f)()
    jsr bi_f
    // for(char j=0;j<2;j++)
    inc.z j
    jmp __b2
  bi_f:
    jmp (f)
  .segment Data
    fns: .word fn1, fn2
}

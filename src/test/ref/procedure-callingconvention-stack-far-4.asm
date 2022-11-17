// Test a procedure with calling convention stack
// Illustrates live range problem with function variable printother::i and global variable val
  // Commodore 64 PRG executable file
.file [name="procedure-callingconvention-stack-far-4.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  .label SCREEN = $400
  .label val = 2
.segment Code
__start: {
    // char val = 0
    lda #0
    sta.z val
    jsr main
    rts
}
printother: {
    ldx #0
  __b1:
    // (SCREEN+40)[i]++;
    inc SCREEN+$28,x
    // for(char i:0..5)
    inx
    cpx #6
    bne __b1
    // }
    rts
}
incval: {
    // val++;
    inc.z val
    // }
    rts
}
printval: {
    // SCREEN[0] = val
    lda.z val
    sta SCREEN
    // }
    rts
}
ival: {
    // incval()
    .assert "Missing ASM fragment Fragment not found call_far_c64_entry. Attempted variations call_far_c64_entry ", 0, 1
    // }
    rts
}
pval: {
    // printval()
    .assert "Missing ASM fragment Fragment not found call_far_c64_entry. Attempted variations call_far_c64_entry ", 0, 1
    // }
    rts
}
main: {
    .label i = 3
    lda #0
    sta.z i
  __b1:
    // pval()
    .assert "Missing ASM fragment Fragment not found call_far_c64_entry. Attempted variations call_far_c64_entry ", 0, 1
    // printother()
    .assert "Missing ASM fragment Fragment not found call_far_c64_entry. Attempted variations call_far_c64_entry ", 0, 1
    // ival()
    .assert "Missing ASM fragment Fragment not found call_far_c64_entry. Attempted variations call_far_c64_entry ", 0, 1
    // for(char i:0..5)
    inc.z i
    lda #6
    cmp.z i
    bne __b1
    // }
    rts
}

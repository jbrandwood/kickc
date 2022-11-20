  // File Comments
// Test a procedure with calling convention stack
// Illustrates live range problem with function variable printother::i and global variable val
  // Upstart
.cpu _65c02
  // Commodore 64 PRG executable file
.file [name="procedure-callingconvention-stack-far-3.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  // Global Constants & labels
  .label SCREEN = $400
  .label val = 3
.segment Code
  // __start
__start: {
    // __start::__init1
    // char val = 0
    // [1] val = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z val
    // [2] phi from __start::__init1 to __start::@1 [phi:__start::__init1->__start::@1]
    // __start::@1
    // [3] callexecute main  -- call_vprc1 
    jsr main
    // __start::@return
    // [4] return 
    rts
}
  // printother
printother: {
    .label i = 2
    // [6] phi from printother to printother::@1 [phi:printother->printother::@1]
    // [6] phi printother::i#2 = 0 [phi:printother->printother::@1#0] -- vbuz1=vbuc1 
    lda #0
    sta.z i
    // [6] phi from printother::@1 to printother::@1 [phi:printother::@1->printother::@1]
    // [6] phi printother::i#2 = printother::i#1 [phi:printother::@1->printother::@1#0] -- register_copy 
    // printother::@1
  __b1:
    // (SCREEN+40)[i]++;
    // [7] (SCREEN+$28)[printother::i#2] = ++ (SCREEN+$28)[printother::i#2] -- pbuc1_derefidx_vbuz1=_inc_pbuc1_derefidx_vbuz1 
    ldx.z i
    inc SCREEN+$28,x
    // for(char i:0..5)
    // [8] printother::i#1 = ++ printother::i#2 -- vbuz1=_inc_vbuz1 
    inc.z i
    // [9] if(printother::i#1!=6) goto printother::@1 -- vbuz1_neq_vbuc1_then_la1 
    lda #6
    cmp.z i
    bne __b1
    // printother::@return
    // }
    // [10] return 
    rts
}
  // incval
incval: {
    // val++;
    // [11] val = ++ val -- vbuz1=_inc_vbuz1 
    inc.z val
    // incval::@return
    // }
    // [12] return 
    rts
}
  // printval
printval: {
    // SCREEN[0] = val
    // [13] *SCREEN = val -- _deref_pbuc1=vbuz1 
    lda.z val
    sta SCREEN
    // printval::@return
    // }
    // [14] return 
    rts
}
  // ival
ival: {
    // incval()
    // [16] callexecute incval  -- call_far_cx16_exit 
    jsr $ff6e
    .byte <incval
    .byte >incval
    .byte $15
    // ival::@return
    // }
    // [17] return 
    rts
}
  // pval
pval: {
    // printval()
    // [19] callexecute printval  -- call_far_cx16_exit 
    jsr $ff6e
    .byte <printval
    .byte >printval
    .byte $14
    // pval::@return
    // }
    // [20] return 
    rts
}
  // main
main: {
    .label i = 4
    // [22] phi from main to main::@1 [phi:main->main::@1]
    // [22] phi main::i#2 = 0 [phi:main->main::@1#0] -- vbuz1=vbuc1 
    lda #0
    sta.z i
    // [22] phi from main::@1 to main::@1 [phi:main::@1->main::@1]
    // [22] phi main::i#2 = main::i#1 [phi:main::@1->main::@1#0] -- register_copy 
    // main::@1
  __b1:
    // pval()
    // [23] callexecute pval  -- call_far_cx16_exit 
    jsr $ff6e
    .byte <pval
    .byte >pval
    .byte $14
    // printother()
    // [24] callexecute printother  -- call_vprc1 
    jsr printother
    // ival()
    // [25] callexecute ival  -- call_far_cx16_exit 
    jsr $ff6e
    .byte <ival
    .byte >ival
    .byte $15
    // for(char i:0..5)
    // [26] main::i#1 = ++ main::i#2 -- vbuz1=_inc_vbuz1 
    inc.z i
    // [27] if(main::i#1!=6) goto main::@1 -- vbuz1_neq_vbuc1_then_la1 
    lda #6
    cmp.z i
    bne __b1
    // main::@return
    // }
    // [28] return 
    rts
}
  // File Data

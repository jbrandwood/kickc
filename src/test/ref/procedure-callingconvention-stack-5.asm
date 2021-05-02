// Test a procedure with calling convention stack
// Return value larger than parameter
  // Commodore 64 PRG executable file
.file [name="procedure-callingconvention-stack-5.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  .const SIZEOF_SIGNED_WORD = 2
  .const STACK_BASE = $103
  .label SCREEN = $400
  .label current = 4
.segment Code
__start: {
    // int  current = 48
    lda #<$30
    sta.z current
    lda #>$30
    sta.z current+1
    jsr main
    rts
}
next: {
    .const OFFSET_STACK_RETURN = 0
    .label return = 2
    // return current++;
    lda.z current
    sta.z return
    lda.z current+1
    sta.z return+1
    inc.z current
    bne !+
    inc.z current+1
  !:
    // }
    tsx
    lda.z return
    sta STACK_BASE+OFFSET_STACK_RETURN,x
    lda.z return+1
    sta STACK_BASE+OFFSET_STACK_RETURN+1,x
    rts
}
main: {
    .label __0 = 2
    .label __1 = 4
    // next()
    pha
    pha
    jsr next
    pla
    sta.z __0
    pla
    sta.z __0+1
    // SCREEN[0] = next()
    lda.z __0
    sta SCREEN
    lda.z __0+1
    sta SCREEN+1
    // next()
    pha
    pha
    jsr next
    pla
    sta.z __1
    pla
    sta.z __1+1
    // SCREEN[1] = next()
    lda.z __1
    sta SCREEN+1*SIZEOF_SIGNED_WORD
    lda.z __1+1
    sta SCREEN+1*SIZEOF_SIGNED_WORD+1
    // }
    rts
}

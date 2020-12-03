// Tests trouble passing a function pointer
// See https://gitlab.com/camelot/kickc/-/issues/557
  // Atari XL/XE executable XEX file with a single segment
// https://www.atarimax.com/jindroush.atari.org/afmtexe.html
.plugin "dk.camelot64.kickass.xexplugin.AtariXex"
.file [name="function-pointer-noarg-call-13.xex", type="bin", segments="XexFile"]
.segmentdef XexFile [segments="Program", modify="XexFormat", _RunAddr=main]
.segmentdef Program [segments="Code, Data"]
.segmentdef Code [start=$2000]
.segmentdef Data [startAfter="Code"]
  .label r = $8000
.segment Code
fn2: {
    // *r = 2
    lda #2
    sta r
    // }
    rts
}
fn1: {
    // *r = 1
    lda #1
    sta r
    // }
    rts
}
main: {
    // enableDLI(&fn1)
    lda #<fn1
    sta.z enableDLI.dliptr
    lda #>fn1
    sta.z enableDLI.dliptr+1
    jsr enableDLI
    // enableDLI(&fn2)
    lda #<fn2
    sta.z enableDLI.dliptr
    lda #>fn2
    sta.z enableDLI.dliptr+1
    jsr enableDLI
    // }
    rts
}
// enableDLI(void* zp($80) dliptr)
enableDLI: {
    .label dliptr = $80
    // asm
    lda dliptr
    sta dlivec
    lda dliptr+1
    sta dlivec+1
    jmp !+
  dlivec:
    .byte 0, 0
  !:
    // }
    rts
}

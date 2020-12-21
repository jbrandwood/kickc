// Test all types of pointers
  // Commodore 64 PRG executable file
.file [name="ptrtest.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    // lvalue()
    jsr lvalue
    // rvalue()
    jsr rvalue
    // rvaluevar()
    jsr rvaluevar
    // lvaluevar()
    jsr lvaluevar
    // }
    rts
}
lvalue: {
    // A constant pointer
    .label SCREEN = $400
    // *SCREEN = 1
    // LValue constant pointer dereference
    lda #1
    sta SCREEN
    // SCREEN[1] = 2
    // LValue constant array constant indexing
    lda #2
    sta SCREEN+1
    tax
  __b1:
    // while(i<10)
    cpx #$a
    bcc __b2
    // }
    rts
  __b2:
    // SCREEN[i++] = 3
    lda #3
    sta SCREEN,x
    // SCREEN[i++] = 3;
    inx
    jmp __b1
}
rvalue: {
    // A constant pointer
    .label SCREEN = $400
    .label screen2 = $400
    // b = SCREEN[1]
    // RValue constant array pointer constant index
    lda SCREEN+1
    ldx #2
  __b1:
    // while(i<10)
    cpx #$a
    bcc __b2
    // *screen2 = b
    sta screen2
    // }
    rts
  __b2:
    // b = SCREEN[i++]
    lda SCREEN,x
    // b = SCREEN[i++];
    inx
    jmp __b1
}
rvaluevar: {
    .label screen2 = $400
    .label screen = 2
    ldy #0
    lda #<$400
    sta.z screen
    lda #>$400
    sta.z screen+1
    ldx #2
  __b1:
    // while(i<10)
    cpx #$a
    bcc __b2
    // *screen2 = b
    sty screen2
    // }
    rts
  __b2:
    // b = *screen
    ldy #0
    lda (screen),y
    tay
    // screen++;
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    // i++;
    inx
    jmp __b1
}
lvaluevar: {
    // LValue Variable pointer dereference
    .const b = 4
    .label screen = 2
    lda #<$400
    sta.z screen
    lda #>$400
    sta.z screen+1
    ldx #2
  __b1:
    // while(i<10)
    cpx #$a
    bcc __b2
    // }
    rts
  __b2:
    // *screen = b
    lda #b
    ldy #0
    sta (screen),y
    // screen++;
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    // i++;
    inx
    jmp __b1
}

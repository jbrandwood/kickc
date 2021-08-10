// Includes a system library - ignores the local file with the same name
  // Commodore 64 PRG executable file
.file [name="includes-1.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    .label __0 = 4
    // strlen(STR)
    jsr strlen
    // strlen(STR)
    // SCREEN [0] = (char) strlen(STR)
    lda.z __0
    sta SCREEN
    // }
    rts
}
// Computes the length of the string str up to but not including the terminating null character.
// __zp(4) unsigned int strlen(__zp(2) char *str)
strlen: {
    .label len = 4
    .label str = 2
    .label return = 4
    lda #<0
    sta.z len
    sta.z len+1
    lda #<STR
    sta.z str
    lda #>STR
    sta.z str+1
  __b1:
    // while(*str)
    ldy #0
    lda (str),y
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // len++;
    inc.z len
    bne !+
    inc.z len+1
  !:
    // str++;
    inc.z str
    bne !+
    inc.z str+1
  !:
    jmp __b1
}
.segment Data
  STR: .text "camelot!"
  .byte 0

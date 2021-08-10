// Test using operator byte0() in an lvalue
  // Commodore 64 PRG executable file
.file [name="operator-byte0-lvalue-1.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_UNSIGNED_INT = 2
.segment Code
main: {
    .label SCREEN = $400
    .label i = 3
    .label j = 2
    // SCREEN[i++] = w
    lda #<$3039
    sta SCREEN
    lda #>$3039
    sta SCREEN+1
    lda #<$3039&$ffffff00|1
    sta SCREEN+1*SIZEOF_UNSIGNED_INT
    lda #>$3039&$ffffff00|1
    sta SCREEN+1*SIZEOF_UNSIGNED_INT+1
    lda #<($3039&$ffffff00|1)&$ffff00ff|2*$100
    sta SCREEN+2*SIZEOF_UNSIGNED_INT
    lda #>($3039&$ffffff00|1)&$ffff00ff|2*$100
    sta SCREEN+2*SIZEOF_UNSIGNED_INT+1
    lda #3
    sta.z i
    lda #0
    sta.z j
  __b1:
    // for(char j=0;j<2;j++)
    lda.z j
    cmp #2
    bcc __b2
    // }
    rts
  __b2:
    // SCREEN[i++] = ws[j]
    lda.z j
    asl
    tax
    lda.z i
    asl
    tay
    lda ws,x
    sta SCREEN,y
    lda ws+1,x
    sta SCREEN+1,y
    // SCREEN[i++] = ws[j];
    inc.z i
    // BYTE0(ws[j]) = 2
    lda #2
    sta ws,x
    // SCREEN[i++] = ws[j]
    lda.z i
    asl
    tay
    lda ws,x
    sta SCREEN,y
    lda ws+1,x
    sta SCREEN+1,y
    // SCREEN[i++] = ws[j];
    inc.z i
    // for(char j=0;j<2;j++)
    inc.z j
    jmp __b1
  .segment Data
    ws: .word $5ba0, $8707
}

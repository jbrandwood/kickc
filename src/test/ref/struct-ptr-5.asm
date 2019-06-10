// Minimal struct - simple linked list implemented using pointers
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_STRUCT_ENTRY = 3
  .const OFFSET_STRUCT_ENTRY_VALUE = 2
  .label ENTRIES = $1000
main: {
    // Run through the linked list
    .label SCREEN = $400
    .label entry1 = ENTRIES+1*SIZEOF_STRUCT_ENTRY
    .label entry2 = ENTRIES+2*SIZEOF_STRUCT_ENTRY
    .label next = 4
    .label entry = 2
    lda #<entry2
    sta ENTRIES
    lda #>entry2
    sta ENTRIES+1
    lda #1
    sta ENTRIES+OFFSET_STRUCT_ENTRY_VALUE
    lda #<entry1
    sta entry2
    lda #>entry1
    sta entry2+1
    lda #2
    sta entry2+OFFSET_STRUCT_ENTRY_VALUE
    lda #<0
    sta entry1
    sta entry1+1
    lda #3
    sta entry1+OFFSET_STRUCT_ENTRY_VALUE
    ldx #0
    lda #<ENTRIES
    sta entry
    lda #>ENTRIES
    sta entry+1
  b1:
    lda entry+1
    cmp #>0
    bne b2
    lda entry
    cmp #<0
    bne b2
    rts
  b2:
    lda #'0'
    ldy #OFFSET_STRUCT_ENTRY_VALUE
    clc
    adc (entry),y
    sta SCREEN,x
    inx
    ldy #0
    lda (entry),y
    sta next
    iny
    lda (entry),y
    sta next+1
    lda next
    sta SCREEN,x
    inx
    lda next+1
    sta SCREEN,x
    inx
    lda #' '
    sta SCREEN,x
    inx
    ldy #0
    lda (entry),y
    pha
    iny
    lda (entry),y
    sta entry+1
    pla
    sta entry
    jmp b1
}

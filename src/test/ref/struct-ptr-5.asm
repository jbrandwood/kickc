// Minimal struct - simple linked list implemented using pointers
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_STRUCT_ENTRY = 3
  .const OFFSET_STRUCT_ENTRY_NEXT = 1
  .label ENTRIES = $1000
main: {
    // Run through the linked list
    .label SCREEN = $400
    .label entry1 = ENTRIES+1*SIZEOF_STRUCT_ENTRY
    .label entry2 = ENTRIES+2*SIZEOF_STRUCT_ENTRY
    .label entry = 2
    lda #<entry2
    sta ENTRIES+OFFSET_STRUCT_ENTRY_NEXT
    lda #>entry2
    sta ENTRIES+OFFSET_STRUCT_ENTRY_NEXT+1
    lda #1
    sta ENTRIES
    lda #<entry1
    sta entry2+OFFSET_STRUCT_ENTRY_NEXT
    lda #>entry1
    sta entry2+OFFSET_STRUCT_ENTRY_NEXT+1
    lda #2
    sta entry2
    lda #<0
    sta entry1+OFFSET_STRUCT_ENTRY_NEXT
    sta entry1+OFFSET_STRUCT_ENTRY_NEXT+1
    lda #3
    sta entry1
    ldx #0
    lda #<ENTRIES
    sta entry
    lda #>ENTRIES
    sta entry+1
  b2:
    lda #'0'
    clc
    ldy #0
    adc (entry),y
    sta SCREEN,x
    inx
    ldy #OFFSET_STRUCT_ENTRY_NEXT
    lda (entry),y
    sta SCREEN,x
    inx
    ldy #OFFSET_STRUCT_ENTRY_NEXT+1
    lda (entry),y
    sta SCREEN,x
    inx
    lda #' '
    sta SCREEN,x
    inx
    ldy #OFFSET_STRUCT_ENTRY_NEXT
    lda (entry),y
    pha
    iny
    lda (entry),y
    sta entry+1
    pla
    sta entry
    lda entry+1
    cmp #>0
    bne b2
    lda entry
    cmp #<0
    bne b2
    rts
}

// Minimal struct - simple linked list implemented using pointers
  // Commodore 64 PRG executable file
.file [name="struct-ptr-5.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_STRUCT_ENTRY = 3
  .const OFFSET_STRUCT_ENTRY_NEXT = 1
  .label ENTRIES = $1000
.segment Code
main: {
    // Run through the linked list
    .label SCREEN = $400
    .label entry1 = ENTRIES+1*SIZEOF_STRUCT_ENTRY
    .label entry2 = ENTRIES+2*SIZEOF_STRUCT_ENTRY
    .label entry = 2
    // entry0->next = entry2
    lda #<entry2
    sta ENTRIES+OFFSET_STRUCT_ENTRY_NEXT
    lda #>entry2
    sta ENTRIES+OFFSET_STRUCT_ENTRY_NEXT+1
    // entry0->value = 1
    lda #1
    sta ENTRIES
    // entry2->next = entry1
    lda #<entry1
    sta entry2+OFFSET_STRUCT_ENTRY_NEXT
    lda #>entry1
    sta entry2+OFFSET_STRUCT_ENTRY_NEXT+1
    // entry2->value = 2
    lda #2
    sta entry2
    // entry1->next = (struct Entry*)0
    lda #<0
    sta entry1+OFFSET_STRUCT_ENTRY_NEXT
    sta entry1+OFFSET_STRUCT_ENTRY_NEXT+1
    // entry1->value = 3
    lda #3
    sta entry1
    ldx #0
    lda #<ENTRIES
    sta.z entry
    lda #>ENTRIES
    sta.z entry+1
  __b1:
    // while(entry)
    lda.z entry+1
    cmp #>0
    bne __b2
    lda.z entry
    cmp #<0
    bne __b2
    // }
    rts
  __b2:
    // '0'+entry->value
    lda #'0'
    clc
    ldy #0
    adc (entry),y
    // SCREEN[idx++] = '0'+entry->value
    sta SCREEN,x
    // SCREEN[idx++] = '0'+entry->value;
    inx
    // <entry->next
    ldy #OFFSET_STRUCT_ENTRY_NEXT
    lda (entry),y
    // SCREEN[idx++] = <entry->next
    sta SCREEN,x
    // SCREEN[idx++] = <entry->next;
    inx
    // >entry->next
    ldy #OFFSET_STRUCT_ENTRY_NEXT+1
    lda (entry),y
    // SCREEN[idx++] = >entry->next
    sta SCREEN,x
    // SCREEN[idx++] = >entry->next;
    inx
    // SCREEN[idx++] = ' '
    lda #' '
    sta SCREEN,x
    // SCREEN[idx++] = ' ';
    inx
    // entry = entry->next
    ldy #OFFSET_STRUCT_ENTRY_NEXT
    lda (entry),y
    pha
    iny
    lda (entry),y
    sta.z entry+1
    pla
    sta.z entry
    jmp __b1
}

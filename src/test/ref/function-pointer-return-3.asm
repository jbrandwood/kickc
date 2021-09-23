// Calling a function pointer with return value
// Calling a function pointer inside a struct without *
  // Commodore 64 PRG executable file
.file [name="function-pointer-return-3.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_STRUCT_TASK = 3
  .const OFFSET_STRUCT_TASK_HANDLER = 1
  .const STACK_BASE = $103
  .label BORDER = $d020
  .label BACKGROUND = $d021
.segment Code
main: {
    .label i = 4
  __b3:
    lda #0
    sta.z i
  __b1:
    // for(char i=0; i < sizeof(tasks)/sizeof(struct Task); i++)
    lda.z i
    cmp #4*SIZEOF_STRUCT_TASK/SIZEOF_STRUCT_TASK
    bcc __b2
    jmp __b3
  __b2:
    // tasks+i
    lda.z i
    asl
    clc
    adc.z i
    tax
    // run(tasks+i)
    txa
    clc
    adc #<tasks
    sta.z run.task
    lda #>tasks
    adc #0
    sta.z run.task+1
    jsr run
    // for(char i=0; i < sizeof(tasks)/sizeof(struct Task); i++)
    inc.z i
    jmp __b1
}
// void set_bg(__register(A) char col)
set_bg: {
    .const OFFSET_STACK_COL = 0
    tsx
    lda STACK_BASE+OFFSET_STACK_COL,x
    // *BACKGROUND = col
    sta BACKGROUND
    // }
    rts
}
// void set_border(__register(A) char col)
set_border: {
    .const OFFSET_STACK_COL = 0
    tsx
    lda STACK_BASE+OFFSET_STACK_COL,x
    // *BORDER = col
    sta BORDER
    // }
    rts
}
// void run(__zp(2) struct Task *task)
run: {
    .label task = 2
    // task->handler(task->param)
    lda tasks,x
    pha
    ldy #OFFSET_STRUCT_TASK_HANDLER
    lda (task),y
    sta !+ +1
    iny
    lda (task),y
    sta !+ +2
  !:
    jsr 0
    pla
    // }
    rts
}
.segment Data
  tasks: .byte 0
  .word set_border
  .byte 0
  .word set_bg
  .byte 1
  .word set_border
  .byte 2
  .word set_bg

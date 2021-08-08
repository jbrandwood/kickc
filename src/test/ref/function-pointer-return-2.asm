// Calling a function pointer with return value
// Reference the function without &, Call it without *
  // Commodore 64 PRG executable file
.file [name="function-pointer-return-2.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const STACK_BASE = $103
  .label RASTER = $d012
  .label BORDER = $d020
.segment Code
main: {
  __b1:
    // set_border(fn1)
  // Create pointer to function without &
    lda #<fn1
    sta.z set_border.fn
    lda #>fn1
    sta.z set_border.fn+1
    jsr set_border
    // set_border(fn2)
    lda #<fn2
    sta.z set_border.fn
    lda #>fn2
    sta.z set_border.fn+1
    jsr set_border
    jmp __b1
}
fn2: {
    .const OFFSET_STACK_RETURN_0 = 0
    .const return = 0
    // }
    lda #return
    tsx
    sta STACK_BASE+OFFSET_STACK_RETURN_0,x
    rts
}
fn1: {
    .const OFFSET_STACK_RETURN_0 = 0
    // return *RASTER;
    lda RASTER
    // }
    tsx
    sta STACK_BASE+OFFSET_STACK_RETURN_0,x
    rts
}
// set_border(byte()* zp(2) fn)
set_border: {
    .label fn = 2
    // fn()
    pha
    jsr icall1
    pla
    // *BORDER = fn()
    // Call pointer to a function without *
    sta BORDER
    // }
    rts
  icall1:
    jmp (fn)
}

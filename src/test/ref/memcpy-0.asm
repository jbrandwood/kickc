// Test memcpy - copy charset and screen using memcpy() from stdlib string
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  // Processor Port Register controlling RAM/ROM configuration and the datasette
  .label PROCPORT = 1
  // RAM in $A000, $E000 CHAR ROM in $D000
  .const PROCPORT_RAM_CHARROM = 1
  // BASIC in $A000, I/O in $D000, KERNEL in $E000
  .const PROCPORT_BASIC_KERNEL_IO = 7
  // The address of the CHARGEN character set
  .label CHARGEN = $d000
  .label D018 = $d018
  .label CHARSET = $2000
  .label SCREEN = $400
  .label SCREEN_COPY = $2400
main: {
    .const toD0181_return = (>(SCREEN_COPY&$3fff)*4)|(>CHARSET)/4&$f
    lda #toD0181_return
    sta D018
    lda #<$400
    sta.z memcpy.num
    lda #>$400
    sta.z memcpy.num+1
    lda #<SCREEN_COPY
    sta.z memcpy.destination
    lda #>SCREEN_COPY
    sta.z memcpy.destination+1
    lda #<SCREEN
    sta.z memcpy.source
    lda #>SCREEN
    sta.z memcpy.source+1
    jsr memcpy
    sei
    lda #PROCPORT_RAM_CHARROM
    sta PROCPORT
    lda #<$800
    sta.z memcpy.num
    lda #>$800
    sta.z memcpy.num+1
    lda #<CHARSET
    sta.z memcpy.destination
    lda #>CHARSET
    sta.z memcpy.destination+1
    lda #<CHARGEN
    sta.z memcpy.source
    lda #>CHARGEN
    sta.z memcpy.source+1
    jsr memcpy
    lda #PROCPORT_BASIC_KERNEL_IO
    sta PROCPORT
    cli
    rts
}
// Copy block of memory (forwards)
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination.
// memcpy(void* zp(4) destination, void* zp(2) source, word zp(6) num)
memcpy: {
    .label src_end = 6
    .label dst = 4
    .label src = 2
    .label source = 2
    .label destination = 4
    .label num = 6
    lda.z src_end
    clc
    adc.z source
    sta.z src_end
    lda.z src_end+1
    adc.z source+1
    sta.z src_end+1
  __b1:
    lda.z src+1
    cmp.z src_end+1
    bne __b2
    lda.z src
    cmp.z src_end
    bne __b2
    rts
  __b2:
    ldy #0
    lda (src),y
    sta (dst),y
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    inc.z src
    bne !+
    inc.z src+1
  !:
    jmp __b1
}

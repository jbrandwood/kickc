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
    sta memcpy.num
    lda #>$400
    sta memcpy.num+1
    lda #<SCREEN_COPY
    sta memcpy.destination
    lda #>SCREEN_COPY
    sta memcpy.destination+1
    lda #<SCREEN
    sta memcpy.source
    lda #>SCREEN
    sta memcpy.source+1
    jsr memcpy
    sei
    lda #PROCPORT_RAM_CHARROM
    sta PROCPORT
    lda #<$800
    sta memcpy.num
    lda #>$800
    sta memcpy.num+1
    lda #<CHARSET
    sta memcpy.destination
    lda #>CHARSET
    sta memcpy.destination+1
    lda #<CHARGEN
    sta memcpy.source
    lda #>CHARGEN
    sta memcpy.source+1
    jsr memcpy
    lda #PROCPORT_BASIC_KERNEL_IO
    sta PROCPORT
    cli
    rts
}
// Copy block of memory (forwards)
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination.
// memcpy(void* zeropage(4) destination, void* zeropage(2) source, word zeropage(6) num)
memcpy: {
    .label src_end = 6
    .label dst = 4
    .label src = 2
    .label source = 2
    .label destination = 4
    .label num = 6
    lda src_end
    clc
    adc source
    sta src_end
    lda src_end+1
    adc source+1
    sta src_end+1
  b1:
    lda src+1
    cmp src_end+1
    bne b2
    lda src
    cmp src_end
    bne b2
    rts
  b2:
    ldy #0
    lda (src),y
    sta (dst),y
    inc dst
    bne !+
    inc dst+1
  !:
    inc src
    bne !+
    inc src+1
  !:
    jmp b1
}

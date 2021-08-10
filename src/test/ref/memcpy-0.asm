// Test memcpy - copy charset and screen using memcpy() from stdlib string
  // Commodore 64 PRG executable file
.file [name="memcpy-0.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  /// RAM in 0xA000, 0xE000 CHAR ROM in 0xD000
  .const PROCPORT_RAM_CHARROM = 1
  /// BASIC in 0xA000, I/O in 0xD000, KERNEL in 0xE000
  .const PROCPORT_BASIC_KERNEL_IO = 7
  /// $D018 VIC-II base addresses
  // @see #VICII_MEMORY
  .label D018 = $d018
  /// Processor Port Register controlling RAM/ROM configuration and the datasette
  .label PROCPORT = 1
  /// The address of the CHARGEN character set
  .label CHARGEN = $d000
  .label CHARSET = $2000
  .label SCREEN = $400
  .label SCREEN_COPY = $2400
.segment Code
main: {
    .const toD0181_return = (>(SCREEN_COPY&$3fff)*4)|(>CHARSET)/4&$f
    // *D018 = toD018(SCREEN_COPY, CHARSET)
    lda #toD0181_return
    sta D018
    // memcpy(SCREEN_COPY, SCREEN, 0x0400)
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
    // asm
    sei
    // *PROCPORT = PROCPORT_RAM_CHARROM
    lda #PROCPORT_RAM_CHARROM
    sta PROCPORT
    // memcpy(CHARSET, CHARGEN, 0x0800)
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
    // *PROCPORT = PROCPORT_BASIC_KERNEL_IO
    lda #PROCPORT_BASIC_KERNEL_IO
    sta PROCPORT
    // asm
    cli
    // }
    rts
}
// Copy block of memory (forwards)
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination.
// void * memcpy(__zp(4) void *destination, __zp(2) void *source, __zp(6) unsigned int num)
memcpy: {
    .label src_end = 6
    .label dst = 4
    .label src = 2
    .label source = 2
    .label destination = 4
    .label num = 6
    // char* src_end = (char*)source+num
    clc
    lda.z src_end
    adc.z source
    sta.z src_end
    lda.z src_end+1
    adc.z source+1
    sta.z src_end+1
  __b1:
    // while(src!=src_end)
    lda.z src+1
    cmp.z src_end+1
    bne __b2
    lda.z src
    cmp.z src_end
    bne __b2
    // }
    rts
  __b2:
    // *dst++ = *src++
    ldy #0
    lda (src),y
    sta (dst),y
    // *dst++ = *src++;
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

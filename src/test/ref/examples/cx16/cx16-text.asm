// Example program for the Commander X16
// Displays text on the screen by transfering data to VERA
.cpu _65c02
  // Commodore 64 PRG executable file
.file [name="cx16-text.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const VERA_INC_1 = $10
  .const VERA_ADDRSEL = 1
  .const SIZEOF_CHAR = 1
  /// $9F20 VRAM Address (7:0)
  .label VERA_ADDRX_L = $9f20
  /// $9F21 VRAM Address (15:8)
  .label VERA_ADDRX_M = $9f21
  /// $9F22 VRAM Address (7:0)
  /// Bit 4-7: Address Increment  The following is the amount incremented per value value:increment
  ///                             0:0, 1:1, 2:2, 3:4, 4:8, 5:16, 6:32, 7:64, 8:128, 9:256, 10:512, 11:40, 12:80, 13:160, 14:320, 15:640
  /// Bit 3: DECR Setting the DECR bit, will decrement instead of increment by the value set by the 'Address Increment' field.
  /// Bit 0: VRAM Address (16)
  .label VERA_ADDRX_H = $9f22
  /// $9F23	DATA0	VRAM Data port 0
  .label VERA_DATA0 = $9f23
  /// $9F25	CTRL Control
  /// Bit 7: Reset
  /// Bit 1: DCSEL
  /// Bit 2: ADDRSEL
  .label VERA_CTRL = $9f25
  /// VRAM Address of the default screen
  .label DEFAULT_SCREEN = 0
.segment Code
main: {
    .label vaddr = 4
    lda #<DEFAULT_SCREEN
    sta.z vaddr
    lda #>DEFAULT_SCREEN
    sta.z vaddr+1
    ldy #0
  __b1:
    // for(char i=0;MSG[i];i++)
    lda MSG,y
    cmp #0
    bne __b2
    // memcpy_to_vram(0, DEFAULT_SCREEN+0x100, MSG2, sizeof(MSG2))
    // Space is 0x20, red background black foreground
    jsr memcpy_to_vram
    // }
    rts
  __b2:
    // vpoke(0, vaddr++, MSG[i])
    ldx MSG,y
    jsr vpoke
    // vpoke(0, vaddr++, MSG[i]);
    inc.z vaddr
    bne !+
    inc.z vaddr+1
  !:
    // vpoke(0, vaddr++, 0x21)
  // Message
    ldx #$21
    jsr vpoke
    // vpoke(0, vaddr++, 0x21);
    inc.z vaddr
    bne !+
    inc.z vaddr+1
  !:
    // for(char i=0;MSG[i];i++)
    iny
    jmp __b1
  .segment Data
    // Copy message to screen one char at a time
    MSG: .text "hello world!"
    .byte 0
    // Copy message (and colors) to screen using memcpy_to_vram
    MSG2: .text "h e l l o   w o r l d ! "
    .byte 0
}
.segment Code
// Copy block of memory (from RAM to VRAM)
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination in VRAM.
// - vbank: Which 64K VRAM bank to put data into (0/1)
// - vdest: The destination address in VRAM
// - src: The source address in RAM
// - num: The number of bytes to copy
// void memcpy_to_vram(char vbank, void *vdest, void *src, unsigned int num)
memcpy_to_vram: {
    .const num = $19*SIZEOF_CHAR
    .label vdest = DEFAULT_SCREEN+$100
    .label src = main.MSG2
    // Transfer the data
    .label end = src+num
    .label s = 2
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_ADDRX_L = BYTE0(vdest)
    // Set address
    lda #0
    sta VERA_ADDRX_L
    // *VERA_ADDRX_M = BYTE1(vdest)
    lda #>vdest
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_1 | vbank
    lda #VERA_INC_1
    sta VERA_ADDRX_H
    lda #<src
    sta.z s
    lda #>src
    sta.z s+1
  __b1:
    // for(char *s = src; s!=end; s++)
    lda.z s+1
    cmp #>end
    bne __b2
    lda.z s
    cmp #<end
    bne __b2
    // }
    rts
  __b2:
    // *VERA_DATA0 = *s
    ldy #0
    lda (s),y
    sta VERA_DATA0
    // for(char *s = src; s!=end; s++)
    inc.z s
    bne !+
    inc.z s+1
  !:
    jmp __b1
}
// Put a single byte into VRAM.
// Uses VERA DATA0
// - bank: Which 64K VRAM bank to put data into (0/1)
// - addr: The address in VRAM
// - data: The data to put into VRAM
// void vpoke(char vbank, __zp(4) char *vaddr, __register(X) char data)
vpoke: {
    .label vaddr = 4
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(vaddr)
    lda.z vaddr
    // *VERA_ADDRX_L = BYTE0(vaddr)
    // Set address
    sta VERA_ADDRX_L
    // BYTE1(vaddr)
    lda.z vaddr+1
    // *VERA_ADDRX_M = BYTE1(vaddr)
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_0 | vbank
    lda #0
    sta VERA_ADDRX_H
    // *VERA_DATA0 = data
    // Set data
    stx VERA_DATA0
    // }
    rts
}

// Example program for the Commander X16
// Displays text on the screen by transfering data to VERA
.cpu _65c02
  // Commodore 64 PRG executable file
.file [name="text.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code


  .const VERA_ADDRSEL = 1
  // $9F20 VRAM Address (7:0)
  .label VERA_ADDRX_L = $9f20
  // $9F21 VRAM Address (15:8)
  .label VERA_ADDRX_M = $9f21
  // $9F22 VRAM Address (7:0)
  // Bit 4-7: Address Increment  The following is the amount incremented per value value:increment
  //                             0:0, 1:1, 2:2, 3:4, 4:8, 5:16, 6:32, 7:64, 8:128, 9:256, 10:512, 11:40, 12:80, 13:160, 14:320, 15:640
  // Bit 3: DECR Setting the DECR bit, will decrement instead of increment by the value set by the 'Address Increment' field.
  // Bit 0: VRAM Address (16)
  .label VERA_ADDRX_H = $9f22
  // $9F23	DATA0	VRAM Data port 0
  .label VERA_DATA0 = $9f23
  // $9F25	CTRL Control
  // Bit 7: Reset
  // Bit 1: DCSEL
  // Bit 2: ADDRSEL
  .label VERA_CTRL = $9f25
.segment Code
main: {
    // Address of the default screen
    .label vaddr = 2
    lda #<0
    sta.z vaddr
    sta.z vaddr+1
    tay
  __b1:
    // for(char i=0;MSG[i];i++)
    lda MSG,y
    cmp #0
    bne __b2
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
    MSG: .text "hello world!"
    .byte 0
}
.segment Code
// Put a single byte into VRAM.
// Uses VERA DATA0
// - bank: Which 64K VRAM bank to put data into (0/1)
// - addr: The address in VRAM
// - data: The data to put into VRAM
// vpoke(byte* zp(2) addr, byte register(X) data)
vpoke: {
    .label addr = 2
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // <addr
    lda.z addr
    // *VERA_ADDRX_L = <addr
    // Set address
    sta VERA_ADDRX_L
    // >addr
    lda.z addr+1
    // *VERA_ADDRX_M = >addr
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_0 | bank
    lda #0
    sta VERA_ADDRX_H
    // *VERA_DATA0 = data
    // Set data
    stx VERA_DATA0
    // }
    rts
}

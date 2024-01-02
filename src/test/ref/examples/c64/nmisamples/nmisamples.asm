// NMI Sample Player using the SID volume register
// Code by Scan of Desire (Richard-William Loerakker)
// Sample from ART OF NOISE: MOMENTS IN LOVE
  // Commodore 64 PRG executable file
.file [name="nmisamples.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  /// Value that disables all CIA interrupts when stored to the CIA Interrupt registers
  .const CIA_INTERRUPT_CLEAR_ALL = $7f
  .const SAMPLE_SIZE = $6100
  .const OFFSET_STRUCT_MOS6526_CIA_INTERRUPT = $d
  .const OFFSET_STRUCT_MOS6526_CIA_TIMER_A = 4
  .const OFFSET_STRUCT_MOS6526_CIA_TIMER_A_CONTROL = $e
  .const OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR = $20
  .const OFFSET_STRUCT_MOS6581_SID_VOLUME_FILTER_MODE = $18
  /// The SID MOS 6581/8580
  .label SID = $d400
  /// The VIC-II MOS 6567/6569
  .label VICII = $d000
  /// The CIA#2: Serial bus, RS-232, VIC memory bank
  .label CIA2 = $dd00
  /// CIA#2 Interrupt for reading in ASM
  .label CIA2_INTERRUPT = $dd0d
  /// The vector used when the KERNAL serves NMI interrupts
  .label KERNEL_NMI = $318
  .label sample = 2
.segment Code
__start: {
    // char* volatile sample = SAMPLE
    lda #<SAMPLE
    sta.z sample
    lda #>SAMPLE
    sta.z sample+1
    jsr main
    rts
}
nmi2: {
    sta rega+1
    sty regy+1
    // (VICII->BORDER_COLOR)++;
    inc VICII+OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR
    // asm
    lda CIA2_INTERRUPT
    // *sample >> 4
    ldy #0
    lda (sample),y
    lsr
    lsr
    lsr
    lsr
    // SID->VOLUME_FILTER_MODE = *sample >> 4
    sta SID+OFFSET_STRUCT_MOS6581_SID_VOLUME_FILTER_MODE
    // sample++;
    inc.z sample
    bne !+
    inc.z sample+1
  !:
    // BYTE1(sample)
    lda.z sample+1
    // if (BYTE1(sample) == BYTE1(SAMPLE+$6100))
    cmp #>SAMPLE+$6100
    bne __b1
    // sample = SAMPLE
    lda #<SAMPLE
    sta.z sample
    lda #>SAMPLE
    sta.z sample+1
  __b1:
    // *KERNEL_NMI = &nmi
    lda #<nmi
    sta KERNEL_NMI
    lda #>nmi
    sta KERNEL_NMI+1
    // (VICII->BORDER_COLOR)--;
    dec VICII+OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR
    // }
  rega:
    lda #0
  regy:
    ldy #0
    rti
}
nmi: {
    sta rega+1
    sty regy+1
    // (VICII->BORDER_COLOR)++;
    inc VICII+OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR
    // asm
    lda CIA2_INTERRUPT
    // *sample & $0f
    lda #$f
    ldy #0
    and (sample),y
    // SID->VOLUME_FILTER_MODE = *sample & $0f
    sta SID+OFFSET_STRUCT_MOS6581_SID_VOLUME_FILTER_MODE
    // *KERNEL_NMI = &nmi2
    lda #<nmi2
    sta KERNEL_NMI
    lda #>nmi2
    sta KERNEL_NMI+1
    // (VICII->BORDER_COLOR)--;
    dec VICII+OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR
    // }
  rega:
    lda #0
  regy:
    ldy #0
    rti
}
main: {
    // asm
    // Boosting 8580 Digis
    // See https://gist.github.com/munshkr/30f35e39905e63876ff7 (line 909)
    lda #$ff
    sta $d406
    sta $d40d
    sta $d414
    lda #$49
    sta $d404
    sta $d40b
    sta $d412
    sei
    // CIA2->INTERRUPT = CIA_INTERRUPT_CLEAR_ALL
    lda #CIA_INTERRUPT_CLEAR_ALL
    sta CIA2+OFFSET_STRUCT_MOS6526_CIA_INTERRUPT
    // *KERNEL_NMI = &nmi
    lda #<nmi
    sta KERNEL_NMI
    lda #>nmi
    sta KERNEL_NMI+1
    // CIA2->TIMER_A = 0x88
    lda #<$88
    sta CIA2+OFFSET_STRUCT_MOS6526_CIA_TIMER_A
    lda #>$88
    sta CIA2+OFFSET_STRUCT_MOS6526_CIA_TIMER_A+1
    // CIA2->INTERRUPT = 0x81
    // speed
    lda #$81
    sta CIA2+OFFSET_STRUCT_MOS6526_CIA_INTERRUPT
    // CIA2->TIMER_A_CONTROL = 0x01
    lda #1
    sta CIA2+OFFSET_STRUCT_MOS6526_CIA_TIMER_A_CONTROL
    // asm
    cli
    // }
    rts
}
.segment Data
SAMPLE:
.import binary "moments_sample.bin" 

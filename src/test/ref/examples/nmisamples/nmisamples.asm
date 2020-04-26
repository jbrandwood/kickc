// NMI Sample Player using the SID volume register
// Code by Scan of Desire (Richard-William Loerakker)
// Sample from ART OF NOISE: MOMENTS IN LOVE
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  .label BORDERCOL = $d020
  // The CIA#2: Serial bus, RS-232, VIC memory bank
  .label CIA2 = $dd00
  // CIA#2 Interrupt for reading in ASM
  .label CIA2_INTERRUPT = $dd0d
  // Value that disables all CIA interrupts when stored to the CIA Interrupt registers
  .const CIA_INTERRUPT_CLEAR = $7f
  // The vector used when the KERNAL serves NMI interrupts
  .label KERNEL_NMI = $318
  // The SID volume
  .label SID_VOLUME = $d418
  .const SAMPLE_SIZE = $6100
  .const OFFSET_STRUCT_MOS6526_CIA_INTERRUPT = $d
  .const OFFSET_STRUCT_MOS6526_CIA_TIMER_A = 4
  .const OFFSET_STRUCT_MOS6526_CIA_TIMER_A_CONTROL = $e
  .label sample = 2
__bbegin:
  // sample = SAMPLE
  lda #<SAMPLE
  sta.z sample
  lda #>SAMPLE
  sta.z sample+1
  jsr main
  rts
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
    // CIA2->INTERRUPT = CIA_INTERRUPT_CLEAR
    lda #CIA_INTERRUPT_CLEAR
    sta CIA2+OFFSET_STRUCT_MOS6526_CIA_INTERRUPT
    // *KERNEL_NMI = &nmi
    lda #<nmi
    sta KERNEL_NMI
    lda #>nmi
    sta KERNEL_NMI+1
    // CIA2->TIMER_A = 0x88
    lda #0
    sta CIA2+OFFSET_STRUCT_MOS6526_CIA_TIMER_A+1
    lda #<$88
    sta CIA2+OFFSET_STRUCT_MOS6526_CIA_TIMER_A
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
nmi2: {
    sta rega+1
    stx regx+1
    sty regy+1
    // (*BORDERCOL)++;
    inc BORDERCOL
    // asm
    lda CIA2_INTERRUPT
    // *sample >> 4
    ldy #0
    lda (sample),y
    lsr
    lsr
    lsr
    lsr
    // *SID_VOLUME = *sample >> 4
    sta SID_VOLUME
    // sample++;
    inc.z sample
    bne !+
    inc.z sample+1
  !:
    // >sample
    lda.z sample+1
    // if (>sample == >(SAMPLE+$6100))
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
    // (*BORDERCOL)--;
    dec BORDERCOL
    // }
  rega:
    lda #00
  regx:
    ldx #00
  regy:
    ldy #00
    rti
}
nmi: {
    sta rega+1
    stx regx+1
    sty regy+1
    // (*BORDERCOL)++;
    inc BORDERCOL
    // asm
    lda CIA2_INTERRUPT
    // *sample & $0f
    lda #$f
    ldy #0
    and (sample),y
    // *SID_VOLUME = *sample & $0f
    sta SID_VOLUME
    // *KERNEL_NMI = &nmi2
    lda #<nmi2
    sta KERNEL_NMI
    lda #>nmi2
    sta KERNEL_NMI+1
    // (*BORDERCOL)--;
    dec BORDERCOL
    // }
  rega:
    lda #00
  regx:
    ldx #00
  regy:
    ldy #00
    rti
}
SAMPLE:
.import binary "moments_sample.bin" 

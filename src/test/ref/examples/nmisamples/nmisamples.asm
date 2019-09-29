// NMI Sample Player using the SID volume register
// Code by Scan of Desire (Richard-William Loerakker)
// Sample from ART OF NOISE: MOMENTS IN LOVE
.pc = $801 "Basic"
:BasicUpstart(__b1)
.pc = $80d "Program"
  .label BORDERCOL = $d020
  // CIA #2 Timer A Value (16-bit)
  .label CIA2_TIMER_A = $dd04
  // CIA #2 Interrupt Status & Control Register
  .label CIA2_INTERRUPT = $dd0d
  // CIA #2 Timer A Control Register
  .label CIA2_TIMER_A_CONTROL = $dd0e
  // Value that disables all CIA interrupts when stored to the CIA Interrupt registers
  .const CIA_INTERRUPT_CLEAR = $7f
  // The vector used when the KERNAL serves NMI interrupts
  .label KERNEL_NMI = $318
  // The SID volume
  .label SID_VOLUME = $d418
  .const SAMPLE_SIZE = $6100
  .label sample = 2
__b1:
  lda #<SAMPLE
  sta.z sample
  lda #>SAMPLE
  sta.z sample+1
  jsr main
  rts
main: {
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
    lda #CIA_INTERRUPT_CLEAR
    sta CIA2_INTERRUPT
    lda #<nmi
    sta KERNEL_NMI
    lda #>nmi
    sta KERNEL_NMI+1
    lda #0
    sta CIA2_TIMER_A+1
    lda #<$88
    sta CIA2_TIMER_A
    // speed
    lda #$81
    sta CIA2_INTERRUPT
    lda #1
    sta CIA2_TIMER_A_CONTROL
    cli
    rts
}
nmi2: {
    sta rega+1
    stx regx+1
    sty regy+1
    inc BORDERCOL
    lda CIA2_INTERRUPT
    ldy #0
    lda (sample),y
    lsr
    lsr
    lsr
    lsr
    sta SID_VOLUME
    inc.z sample
    bne !+
    inc.z sample+1
  !:
    lda.z sample+1
    cmp #>SAMPLE+$6100
    bne __b1
    lda #<SAMPLE
    sta.z sample
    lda #>SAMPLE
    sta.z sample+1
  __b1:
    lda #<nmi
    sta KERNEL_NMI
    lda #>nmi
    sta KERNEL_NMI+1
    dec BORDERCOL
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
    inc BORDERCOL
    lda CIA2_INTERRUPT
    lda #$f
    ldy #0
    and (sample),y
    sta SID_VOLUME
    lda #<nmi2
    sta KERNEL_NMI
    lda #>nmi2
    sta KERNEL_NMI+1
    dec BORDERCOL
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

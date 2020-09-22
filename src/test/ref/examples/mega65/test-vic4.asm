// Test a few VIC 3/4 features
// MEGA65 Registers and Constants
// The MOS 6526 Complex Interface Adapter (CIA)
// http://archive.6502.org/datasheets/mos_6526_cia_recreated.pdf
.cpu _45gs02
  // MEGA65 platform PRG executable starting in MEGA65 mode.
.file [name="test-vic4.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$2001]
.segmentdef Code [start=$2017]
.segmentdef Data [startAfter="Code"]
.segment Basic
.byte $0a, $20, $0a, $00, $fe, $02, $20, $30, $00       // 10 BANK 0
.byte $15, $20, $14, $00, $9e, $20                      // 20 SYS 
.text toIntString(main)                                   //         NNNN
.byte $00, $00, $00                                     // 
  // Map 2nd KB of colour RAM $DC00-$DFFF (hiding CIA's)
  .const CRAM2K = 1
  .const OFFSET_STRUCT_MOS6569_VICII_RASTER = $12
  .const OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR = $20
  // I/O Personality selection
  .label IO_KEY = $d02f
  // C65 Banking Register
  .label IO_BANK = $d030
  // The VIC-II MOS 6567/6569
  .label VICII = $d000
  .label SCREEN = $800
  .label COLORS = $d800
.segment Code
main: {
    .label sc = 2
    .label col = 4
    // asm
    // Map memory to BANK 0 : 0x00XXXX - giving access to I/O
    sei
    lda #0
    tax
    tay
    taz
    map
    eom
    // *IO_KEY = 0x47
    // Enable the VIC 4
    lda #$47
    sta IO_KEY
    // *IO_KEY = 0x53
    lda #$53
    sta IO_KEY
    // *IO_BANK |= CRAM2K
    // Enable 2K Color RAM
    lda #CRAM2K
    ora IO_BANK
    sta IO_BANK
    lda #<SCREEN
    sta.z sc
    lda #>SCREEN
    sta.z sc+1
  // Fill the screen with '*'
  __b1:
    // for( char *sc = SCREEN; sc<SCREEN+2000; sc++)
    lda.z sc+1
    cmp #>SCREEN+$7d0
    bcc __b2
    bne !+
    lda.z sc
    cmp #<SCREEN+$7d0
    bcc __b2
  !:
    lda #<COLORS
    sta.z col
    lda #>COLORS
    sta.z col+1
  // Fill the color memory
  __b3:
    // for( char *col = COLORS; col<COLORS+2000; col++)
    lda.z col+1
    cmp #>COLORS+$7d0
    bcc __b4
    bne !+
    lda.z col
    cmp #<COLORS+$7d0
    bcc __b4
  !:
  __b5:
    // VICII->BORDER_COLOR = VICII->RASTER
    lda VICII+OFFSET_STRUCT_MOS6569_VICII_RASTER
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR
    jmp __b5
  __b4:
    // <col
    lda.z col
    // *col = <col
    ldy #0
    sta (col),y
    // for( char *col = COLORS; col<COLORS+2000; col++)
    inw.z col
    jmp __b3
  __b2:
    // *sc = '*'
    lda #'*'
    ldy #0
    sta (sc),y
    // for( char *sc = SCREEN; sc<SCREEN+2000; sc++)
    inw.z sc
    jmp __b1
}

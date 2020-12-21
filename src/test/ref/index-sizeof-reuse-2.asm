// Test that the multiplication of a idx*sizeof(element) is reused inside loops
  // Commodore 64 PRG executable file
.file [name="index-sizeof-reuse-2.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label VIC_RASTER = $d012
  .label VIC_BG_COLOR = $d020
  .label SCREEN = $400
.segment Code
main: {
    // Move the entities
    .label line = 3
    .label i = 2
    .label __11 = 5
    // asm
    sei
  // Wait for raster refresh
  __b1:
    // while(*VIC_RASTER!=0xff)
    lda #$ff
    cmp VIC_RASTER
    bne __b1
    // *VIC_BG_COLOR = 0
    lda #0
    sta VIC_BG_COLOR
    lda #<SCREEN
    sta.z line
    lda #>SCREEN
    sta.z line+1
    lda #0
    sta.z i
  __b3:
    // for(char i=0;i<NUM_ENTITIES;i++)
    lda.z i
    cmp #$19
    bcc __b4
    // *VIC_BG_COLOR = 15
    lda #$f
    sta VIC_BG_COLOR
    jmp __b1
  __b4:
    // line[(char)entities[i]] = ' '
    lda.z i
    asl
    tax
    lda entities,x
    // Delete old symbol
    tay
    lda #' '
    sta (line),y
    // entities[i] += 1
    // Move by velocity
    inc entities,x
    bne !+
    inc entities+1,x
  !:
    // if(entities[i]>39)
    lda entities+1,x
    bne !+
    lda entities,x
    cmp #$27+1
    bcc __b6
  !:
    // entities[i] =0
    lda #0
    sta entities,x
    sta entities+1,x
  __b6:
    // line[entities[i]] = '*'
    clc
    lda.z line
    adc entities,x
    sta.z __11
    lda.z line+1
    adc entities+1,x
    sta.z __11+1
    // Draw symbol
    lda #'*'
    ldy #0
    sta (__11),y
    // line +=40
    // Next line
    lda #$28
    clc
    adc.z line
    sta.z line
    bcc !+
    inc.z line+1
  !:
    // for(char i=0;i<NUM_ENTITIES;i++)
    inc.z i
    jmp __b3
}
.segment Data
  entities: .fill 2*$19, 0

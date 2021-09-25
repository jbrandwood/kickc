// Test that the multiplication of a idx*sizeof(element) is reused inside loops
  // Commodore 64 PRG executable file
.file [name="index-sizeof-reuse.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const OFFSET_STRUCT_ENTITY_X_VEL = 1
  .const OFFSET_STRUCT_ENTITY_SYMBOL = 2
  .label VICII_RASTER = $d012
  .label VICII_BG_COLOR = $d020
  .label SCREEN = $400
.segment Code
main: {
    // Initialize velocities
    .label v = 5
    // Move the entities
    .label line = 3
    .label i1 = 2
    // asm
    sei
    lda #-1
    sta.z v
    ldx #0
  __b1:
    // for(char i=0;i<NUM_ENTITIES;i++)
    cpx #$19
    bcc __b2
  // Wait for raster refresh
  __b3:
    // while(*VICII_RASTER!=0xff)
    lda #$ff
    cmp VICII_RASTER
    bne __b3
    // *VICII_BG_COLOR = 0
    lda #0
    sta VICII_BG_COLOR
    lda #<SCREEN
    sta.z line
    lda #>SCREEN
    sta.z line+1
    lda #0
    sta.z i1
  __b5:
    // for(char i=0;i<NUM_ENTITIES;i++)
    lda.z i1
    cmp #$19
    bcc __b6
    // *VICII_BG_COLOR = 15
    lda #$f
    sta VICII_BG_COLOR
    jmp __b3
  __b6:
    // line[entities[i].x_pos] = ' '
    lda.z i1
    asl
    clc
    adc.z i1
    tax
    // Delete old symbol
    lda #' '
    ldy entities,x
    sta (line),y
    // entities[i].x_pos += entities[i].x_vel
    // Move by velocity
    lda entities,x
    clc
    adc entities+OFFSET_STRUCT_ENTITY_X_VEL,x
    sta entities,x
    // if(entities[i].x_pos<0 || entities[i].x_pos>39)
    lda entities,x
    cmp #0
    bmi __b9
    lda entities,x
    sec
    sbc #$27+1
    bvc !+
    eor #$80
  !:
    bmi __b8
  __b9:
    // -entities[i].x_vel
    lda entities+OFFSET_STRUCT_ENTITY_X_VEL,x
    eor #$ff
    clc
    adc #1
    // entities[i].x_vel = -entities[i].x_vel
    sta entities+OFFSET_STRUCT_ENTITY_X_VEL,x
    // entities[i].x_pos += entities[i].x_vel
    lda entities,x
    clc
    adc entities+OFFSET_STRUCT_ENTITY_X_VEL,x
    sta entities,x
  __b8:
    // line[entities[i].x_pos] = entities[i].symbol
    // Draw symbol
    lda entities+OFFSET_STRUCT_ENTITY_SYMBOL,x
    ldy entities,x
    sta (line),y
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
    inc.z i1
    jmp __b5
  __b2:
    // entities[i].x_pos = (signed char)i
    txa
    asl
    stx.z $ff
    clc
    adc.z $ff
    tay
    txa
    sta entities,y
    // entities[i].x_vel = v
    lda.z v
    sta entities+OFFSET_STRUCT_ENTITY_X_VEL,y
    // entities[i].symbol = i
    txa
    sta entities+OFFSET_STRUCT_ENTITY_SYMBOL,y
    // v = -v
    lda.z v
    eor #$ff
    clc
    adc #1
    sta.z v
    // for(char i=0;i<NUM_ENTITIES;i++)
    inx
    jmp __b1
}
.segment Data
  entities: .fill 3*$19, 0

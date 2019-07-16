// Show a few simple splines using the splines library
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const MOVE_TO = 0
  .const SPLINE_TO = 1
  .const LINE_TO = 2
  .const SIZEOF_STRUCT_SEGMENT = 9
  .const SIZEOF_STRUCT_SPLINEVECTOR16 = 4
  .const OFFSET_STRUCT_SPLINEVECTOR16_Y = 2
  .const OFFSET_STRUCT_SEGMENT_TO = 1
  .const OFFSET_STRUCT_SEGMENT_VIA = 5
  .label D011 = $d011
  .const VIC_BMM = $20
  .const VIC_DEN = $10
  .const VIC_RSEL = 8
  .label D018 = $d018
  // CIA#2 Port A: Serial bus, RS-232, VIC memory bank
  .label CIA2_PORT_A = $dd00
  // CIA #2 Port A data direction register.
  .label CIA2_PORT_A_DDR = $dd02
  .const WHITE = 1
  .label PRINT_SCREEN = $400
  .label BITMAP_SCREEN = $5c00
  .label BITMAP_GRAPHICS = $6000
main: {
    .const vicSelectGfxBank1_toDd001_return = 3^(>BITMAP_SCREEN)/$40
    .const toD0181_return = (>(BITMAP_SCREEN&$3fff)*4)|(>BITMAP_GRAPHICS)/4&$f
    .label segment_via_x = $16
    .label segment_via_y = $18
    .label i = 2
    .label current_x = 3
    .label current_y = 5
    .label current_x_8 = $20
    .label current_y_8 = $22
    lda #MOVE_TO
    sta letter_c
    lda #<$6c
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO
    lda #>$6c
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+1
    lda #<$92
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+OFFSET_STRUCT_SPLINEVECTOR16_Y
    lda #>$92
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+OFFSET_STRUCT_SPLINEVECTOR16_Y+1
    lda #<0
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+1
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+OFFSET_STRUCT_SPLINEVECTOR16_Y
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+OFFSET_STRUCT_SPLINEVECTOR16_Y+1
    lda #SPLINE_TO
    sta letter_c+1*SIZEOF_STRUCT_SEGMENT
    lda #<$59
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+1*SIZEOF_STRUCT_SEGMENT
    lda #>$59
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+1*SIZEOF_STRUCT_SEGMENT+1
    lda #<$b6
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+OFFSET_STRUCT_SPLINEVECTOR16_Y+1*SIZEOF_STRUCT_SEGMENT
    lda #>$b6
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+OFFSET_STRUCT_SPLINEVECTOR16_Y+1*SIZEOF_STRUCT_SEGMENT+1
    lda #<$67
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+1*SIZEOF_STRUCT_SEGMENT
    lda #>$67
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+1*SIZEOF_STRUCT_SEGMENT+1
    lda #<$a9
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+OFFSET_STRUCT_SPLINEVECTOR16_Y+1*SIZEOF_STRUCT_SEGMENT
    lda #>$a9
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+OFFSET_STRUCT_SPLINEVECTOR16_Y+1*SIZEOF_STRUCT_SEGMENT+1
    lda #SPLINE_TO
    sta letter_c+2*SIZEOF_STRUCT_SEGMENT
    lda #<$3b
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+2*SIZEOF_STRUCT_SEGMENT
    lda #>$3b
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+2*SIZEOF_STRUCT_SEGMENT+1
    lda #<$c3
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+OFFSET_STRUCT_SPLINEVECTOR16_Y+2*SIZEOF_STRUCT_SEGMENT
    lda #>$c3
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+OFFSET_STRUCT_SPLINEVECTOR16_Y+2*SIZEOF_STRUCT_SEGMENT+1
    lda #<$4b
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+2*SIZEOF_STRUCT_SEGMENT
    lda #>$4b
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+2*SIZEOF_STRUCT_SEGMENT+1
    lda #<$c3
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+OFFSET_STRUCT_SPLINEVECTOR16_Y+2*SIZEOF_STRUCT_SEGMENT
    lda #>$c3
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+OFFSET_STRUCT_SPLINEVECTOR16_Y+2*SIZEOF_STRUCT_SEGMENT+1
    lda #SPLINE_TO
    sta letter_c+3*SIZEOF_STRUCT_SEGMENT
    lda #<$17
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+3*SIZEOF_STRUCT_SEGMENT
    lda #>$17
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+3*SIZEOF_STRUCT_SEGMENT+1
    lda #<$b2
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+OFFSET_STRUCT_SPLINEVECTOR16_Y+3*SIZEOF_STRUCT_SEGMENT
    lda #>$b2
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+OFFSET_STRUCT_SPLINEVECTOR16_Y+3*SIZEOF_STRUCT_SEGMENT+1
    lda #<$26
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+3*SIZEOF_STRUCT_SEGMENT
    lda #>$26
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+3*SIZEOF_STRUCT_SEGMENT+1
    lda #<$c3
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+OFFSET_STRUCT_SPLINEVECTOR16_Y+3*SIZEOF_STRUCT_SEGMENT
    lda #>$c3
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+OFFSET_STRUCT_SPLINEVECTOR16_Y+3*SIZEOF_STRUCT_SEGMENT+1
    lda #SPLINE_TO
    sta letter_c+4*SIZEOF_STRUCT_SEGMENT
    lda #<9
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+4*SIZEOF_STRUCT_SEGMENT
    lda #>9
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+4*SIZEOF_STRUCT_SEGMENT+1
    lda #<$84
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+OFFSET_STRUCT_SPLINEVECTOR16_Y+4*SIZEOF_STRUCT_SEGMENT
    lda #>$84
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+OFFSET_STRUCT_SPLINEVECTOR16_Y+4*SIZEOF_STRUCT_SEGMENT+1
    lda #<9
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+4*SIZEOF_STRUCT_SEGMENT
    lda #>9
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+4*SIZEOF_STRUCT_SEGMENT+1
    lda #<$a1
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+OFFSET_STRUCT_SPLINEVECTOR16_Y+4*SIZEOF_STRUCT_SEGMENT
    lda #>$a1
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+OFFSET_STRUCT_SPLINEVECTOR16_Y+4*SIZEOF_STRUCT_SEGMENT+1
    lda #SPLINE_TO
    sta letter_c+5*SIZEOF_STRUCT_SEGMENT
    lda #<$19
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+5*SIZEOF_STRUCT_SEGMENT
    lda #>$19
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+5*SIZEOF_STRUCT_SEGMENT+1
    lda #<$57
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+OFFSET_STRUCT_SPLINEVECTOR16_Y+5*SIZEOF_STRUCT_SEGMENT
    lda #>$57
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+OFFSET_STRUCT_SPLINEVECTOR16_Y+5*SIZEOF_STRUCT_SEGMENT+1
    lda #<9
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+5*SIZEOF_STRUCT_SEGMENT
    lda #>9
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+5*SIZEOF_STRUCT_SEGMENT+1
    lda #<$68
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+OFFSET_STRUCT_SPLINEVECTOR16_Y+5*SIZEOF_STRUCT_SEGMENT
    lda #>$68
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+OFFSET_STRUCT_SPLINEVECTOR16_Y+5*SIZEOF_STRUCT_SEGMENT+1
    lda #SPLINE_TO
    sta letter_c+6*SIZEOF_STRUCT_SEGMENT
    lda #<$41
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+6*SIZEOF_STRUCT_SEGMENT
    lda #>$41
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+6*SIZEOF_STRUCT_SEGMENT+1
    lda #<$45
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+OFFSET_STRUCT_SPLINEVECTOR16_Y+6*SIZEOF_STRUCT_SEGMENT
    lda #>$45
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+OFFSET_STRUCT_SPLINEVECTOR16_Y+6*SIZEOF_STRUCT_SEGMENT+1
    lda #<$2a
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+6*SIZEOF_STRUCT_SEGMENT
    lda #>$2a
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+6*SIZEOF_STRUCT_SEGMENT+1
    lda #<$45
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+OFFSET_STRUCT_SPLINEVECTOR16_Y+6*SIZEOF_STRUCT_SEGMENT
    lda #>$45
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+OFFSET_STRUCT_SPLINEVECTOR16_Y+6*SIZEOF_STRUCT_SEGMENT+1
    lda #SPLINE_TO
    sta letter_c+7*SIZEOF_STRUCT_SEGMENT
    lda #<$5d
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+7*SIZEOF_STRUCT_SEGMENT
    lda #>$5d
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+7*SIZEOF_STRUCT_SEGMENT+1
    lda #<$4f
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+OFFSET_STRUCT_SPLINEVECTOR16_Y+7*SIZEOF_STRUCT_SEGMENT
    lda #>$4f
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+OFFSET_STRUCT_SPLINEVECTOR16_Y+7*SIZEOF_STRUCT_SEGMENT+1
    lda #<$52
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+7*SIZEOF_STRUCT_SEGMENT
    lda #>$52
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+7*SIZEOF_STRUCT_SEGMENT+1
    lda #<$45
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+OFFSET_STRUCT_SPLINEVECTOR16_Y+7*SIZEOF_STRUCT_SEGMENT
    lda #>$45
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+OFFSET_STRUCT_SPLINEVECTOR16_Y+7*SIZEOF_STRUCT_SEGMENT+1
    lda #SPLINE_TO
    sta letter_c+8*SIZEOF_STRUCT_SEGMENT
    lda #<$69
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+8*SIZEOF_STRUCT_SEGMENT
    lda #>$69
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+8*SIZEOF_STRUCT_SEGMENT+1
    lda #<$62
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+OFFSET_STRUCT_SPLINEVECTOR16_Y+8*SIZEOF_STRUCT_SEGMENT
    lda #>$62
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+OFFSET_STRUCT_SPLINEVECTOR16_Y+8*SIZEOF_STRUCT_SEGMENT+1
    lda #<$69
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+8*SIZEOF_STRUCT_SEGMENT
    lda #>$69
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+8*SIZEOF_STRUCT_SEGMENT+1
    lda #<$58
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+OFFSET_STRUCT_SPLINEVECTOR16_Y+8*SIZEOF_STRUCT_SEGMENT
    lda #>$58
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+OFFSET_STRUCT_SPLINEVECTOR16_Y+8*SIZEOF_STRUCT_SEGMENT+1
    lda #SPLINE_TO
    sta letter_c+9*SIZEOF_STRUCT_SEGMENT
    lda #<$66
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+9*SIZEOF_STRUCT_SEGMENT
    lda #>$66
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+9*SIZEOF_STRUCT_SEGMENT+1
    lda #<$6a
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+OFFSET_STRUCT_SPLINEVECTOR16_Y+9*SIZEOF_STRUCT_SEGMENT
    lda #>$6a
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+OFFSET_STRUCT_SPLINEVECTOR16_Y+9*SIZEOF_STRUCT_SEGMENT+1
    lda #<$69
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+9*SIZEOF_STRUCT_SEGMENT
    lda #>$69
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+9*SIZEOF_STRUCT_SEGMENT+1
    lda #<$67
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+OFFSET_STRUCT_SPLINEVECTOR16_Y+9*SIZEOF_STRUCT_SEGMENT
    lda #>$67
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+OFFSET_STRUCT_SPLINEVECTOR16_Y+9*SIZEOF_STRUCT_SEGMENT+1
    lda #SPLINE_TO
    sta letter_c+$a*SIZEOF_STRUCT_SEGMENT
    lda #<$5d
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+$a*SIZEOF_STRUCT_SEGMENT
    lda #>$5d
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+$a*SIZEOF_STRUCT_SEGMENT+1
    lda #<$6d
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+OFFSET_STRUCT_SPLINEVECTOR16_Y+$a*SIZEOF_STRUCT_SEGMENT
    lda #>$6d
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+OFFSET_STRUCT_SPLINEVECTOR16_Y+$a*SIZEOF_STRUCT_SEGMENT+1
    lda #<$62
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+$a*SIZEOF_STRUCT_SEGMENT
    lda #>$62
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+$a*SIZEOF_STRUCT_SEGMENT+1
    lda #<$6d
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+OFFSET_STRUCT_SPLINEVECTOR16_Y+$a*SIZEOF_STRUCT_SEGMENT
    lda #>$6d
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+OFFSET_STRUCT_SPLINEVECTOR16_Y+$a*SIZEOF_STRUCT_SEGMENT+1
    lda #SPLINE_TO
    sta letter_c+$b*SIZEOF_STRUCT_SEGMENT
    lda #<$51
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+$b*SIZEOF_STRUCT_SEGMENT
    lda #>$51
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+$b*SIZEOF_STRUCT_SEGMENT+1
    lda #<$68
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+OFFSET_STRUCT_SPLINEVECTOR16_Y+$b*SIZEOF_STRUCT_SEGMENT
    lda #>$68
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+OFFSET_STRUCT_SPLINEVECTOR16_Y+$b*SIZEOF_STRUCT_SEGMENT+1
    lda #<$55
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+$b*SIZEOF_STRUCT_SEGMENT
    lda #>$55
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+$b*SIZEOF_STRUCT_SEGMENT+1
    lda #<$6d
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+OFFSET_STRUCT_SPLINEVECTOR16_Y+$b*SIZEOF_STRUCT_SEGMENT
    lda #>$6d
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+OFFSET_STRUCT_SPLINEVECTOR16_Y+$b*SIZEOF_STRUCT_SEGMENT+1
    lda #SPLINE_TO
    sta letter_c+$c*SIZEOF_STRUCT_SEGMENT
    lda #<$4e
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+$c*SIZEOF_STRUCT_SEGMENT
    lda #>$4e
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+$c*SIZEOF_STRUCT_SEGMENT+1
    lda #<$5d
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+OFFSET_STRUCT_SPLINEVECTOR16_Y+$c*SIZEOF_STRUCT_SEGMENT
    lda #>$5d
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+OFFSET_STRUCT_SPLINEVECTOR16_Y+$c*SIZEOF_STRUCT_SEGMENT+1
    lda #<$4f
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+$c*SIZEOF_STRUCT_SEGMENT
    lda #>$4f
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+$c*SIZEOF_STRUCT_SEGMENT+1
    lda #<$65
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+OFFSET_STRUCT_SPLINEVECTOR16_Y+$c*SIZEOF_STRUCT_SEGMENT
    lda #>$65
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+OFFSET_STRUCT_SPLINEVECTOR16_Y+$c*SIZEOF_STRUCT_SEGMENT+1
    lda #SPLINE_TO
    sta letter_c+$d*SIZEOF_STRUCT_SEGMENT
    lda #<$49
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+$d*SIZEOF_STRUCT_SEGMENT
    lda #>$49
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+$d*SIZEOF_STRUCT_SEGMENT+1
    lda #<$52
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+OFFSET_STRUCT_SPLINEVECTOR16_Y+$d*SIZEOF_STRUCT_SEGMENT
    lda #>$52
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+OFFSET_STRUCT_SPLINEVECTOR16_Y+$d*SIZEOF_STRUCT_SEGMENT+1
    lda #<$4e
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+$d*SIZEOF_STRUCT_SEGMENT
    lda #>$4e
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+$d*SIZEOF_STRUCT_SEGMENT+1
    lda #<$56
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+OFFSET_STRUCT_SPLINEVECTOR16_Y+$d*SIZEOF_STRUCT_SEGMENT
    lda #>$56
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+OFFSET_STRUCT_SPLINEVECTOR16_Y+$d*SIZEOF_STRUCT_SEGMENT+1
    lda #SPLINE_TO
    sta letter_c+$e*SIZEOF_STRUCT_SEGMENT
    lda #<$3d
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+$e*SIZEOF_STRUCT_SEGMENT
    lda #>$3d
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+$e*SIZEOF_STRUCT_SEGMENT+1
    lda #<$4e
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+OFFSET_STRUCT_SPLINEVECTOR16_Y+$e*SIZEOF_STRUCT_SEGMENT
    lda #>$4e
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+OFFSET_STRUCT_SPLINEVECTOR16_Y+$e*SIZEOF_STRUCT_SEGMENT+1
    lda #<$45
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+$e*SIZEOF_STRUCT_SEGMENT
    lda #>$45
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+$e*SIZEOF_STRUCT_SEGMENT+1
    lda #<$4e
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+OFFSET_STRUCT_SPLINEVECTOR16_Y+$e*SIZEOF_STRUCT_SEGMENT
    lda #>$4e
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+OFFSET_STRUCT_SPLINEVECTOR16_Y+$e*SIZEOF_STRUCT_SEGMENT+1
    lda #SPLINE_TO
    sta letter_c+$f*SIZEOF_STRUCT_SEGMENT
    lda #<$28
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+$f*SIZEOF_STRUCT_SEGMENT
    lda #>$28
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+$f*SIZEOF_STRUCT_SEGMENT+1
    lda #<$58
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+OFFSET_STRUCT_SPLINEVECTOR16_Y+$f*SIZEOF_STRUCT_SEGMENT
    lda #>$58
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+OFFSET_STRUCT_SPLINEVECTOR16_Y+$f*SIZEOF_STRUCT_SEGMENT+1
    lda #<$30
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+$f*SIZEOF_STRUCT_SEGMENT
    lda #>$30
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+$f*SIZEOF_STRUCT_SEGMENT+1
    lda #<$4e
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+OFFSET_STRUCT_SPLINEVECTOR16_Y+$f*SIZEOF_STRUCT_SEGMENT
    lda #>$4e
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+OFFSET_STRUCT_SPLINEVECTOR16_Y+$f*SIZEOF_STRUCT_SEGMENT+1
    lda #SPLINE_TO
    sta letter_c+$10*SIZEOF_STRUCT_SEGMENT
    lda #<$1d
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+$10*SIZEOF_STRUCT_SEGMENT
    lda #>$1d
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+$10*SIZEOF_STRUCT_SEGMENT+1
    lda #<$79
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+OFFSET_STRUCT_SPLINEVECTOR16_Y+$10*SIZEOF_STRUCT_SEGMENT
    lda #>$79
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+OFFSET_STRUCT_SPLINEVECTOR16_Y+$10*SIZEOF_STRUCT_SEGMENT+1
    lda #<$1d
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+$10*SIZEOF_STRUCT_SEGMENT
    lda #>$1d
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+$10*SIZEOF_STRUCT_SEGMENT+1
    lda #<$64
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+OFFSET_STRUCT_SPLINEVECTOR16_Y+$10*SIZEOF_STRUCT_SEGMENT
    lda #>$64
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+OFFSET_STRUCT_SPLINEVECTOR16_Y+$10*SIZEOF_STRUCT_SEGMENT+1
    lda #SPLINE_TO
    sta letter_c+$11*SIZEOF_STRUCT_SEGMENT
    lda #<$28
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+$11*SIZEOF_STRUCT_SEGMENT
    lda #>$28
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+$11*SIZEOF_STRUCT_SEGMENT+1
    lda #<$9e
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+OFFSET_STRUCT_SPLINEVECTOR16_Y+$11*SIZEOF_STRUCT_SEGMENT
    lda #>$9e
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+OFFSET_STRUCT_SPLINEVECTOR16_Y+$11*SIZEOF_STRUCT_SEGMENT+1
    lda #<$1d
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+$11*SIZEOF_STRUCT_SEGMENT
    lda #>$1d
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+$11*SIZEOF_STRUCT_SEGMENT+1
    lda #<$8e
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+OFFSET_STRUCT_SPLINEVECTOR16_Y+$11*SIZEOF_STRUCT_SEGMENT
    lda #>$8e
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+OFFSET_STRUCT_SPLINEVECTOR16_Y+$11*SIZEOF_STRUCT_SEGMENT+1
    lda #SPLINE_TO
    sta letter_c+$12*SIZEOF_STRUCT_SEGMENT
    lda #<$44
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+$12*SIZEOF_STRUCT_SEGMENT
    lda #>$44
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+$12*SIZEOF_STRUCT_SEGMENT+1
    lda #<$ae
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+OFFSET_STRUCT_SPLINEVECTOR16_Y+$12*SIZEOF_STRUCT_SEGMENT
    lda #>$ae
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+OFFSET_STRUCT_SPLINEVECTOR16_Y+$12*SIZEOF_STRUCT_SEGMENT+1
    lda #<$32
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+$12*SIZEOF_STRUCT_SEGMENT
    lda #>$32
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+$12*SIZEOF_STRUCT_SEGMENT+1
    lda #<$ae
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+OFFSET_STRUCT_SPLINEVECTOR16_Y+$12*SIZEOF_STRUCT_SEGMENT
    lda #>$ae
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+OFFSET_STRUCT_SPLINEVECTOR16_Y+$12*SIZEOF_STRUCT_SEGMENT+1
    lda #SPLINE_TO
    sta letter_c+$13*SIZEOF_STRUCT_SEGMENT
    lda #<$5b
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+$13*SIZEOF_STRUCT_SEGMENT
    lda #>$5b
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+$13*SIZEOF_STRUCT_SEGMENT+1
    lda #<$a6
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+OFFSET_STRUCT_SPLINEVECTOR16_Y+$13*SIZEOF_STRUCT_SEGMENT
    lda #>$a6
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+OFFSET_STRUCT_SPLINEVECTOR16_Y+$13*SIZEOF_STRUCT_SEGMENT+1
    lda #<$50
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+$13*SIZEOF_STRUCT_SEGMENT
    lda #>$50
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+$13*SIZEOF_STRUCT_SEGMENT+1
    lda #<$ae
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+OFFSET_STRUCT_SPLINEVECTOR16_Y+$13*SIZEOF_STRUCT_SEGMENT
    lda #>$ae
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+OFFSET_STRUCT_SPLINEVECTOR16_Y+$13*SIZEOF_STRUCT_SEGMENT+1
    lda #SPLINE_TO
    sta letter_c+$14*SIZEOF_STRUCT_SEGMENT
    lda #<$68
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+$14*SIZEOF_STRUCT_SEGMENT
    lda #>$68
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+$14*SIZEOF_STRUCT_SEGMENT+1
    lda #<$90
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+OFFSET_STRUCT_SPLINEVECTOR16_Y+$14*SIZEOF_STRUCT_SEGMENT
    lda #>$90
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+OFFSET_STRUCT_SPLINEVECTOR16_Y+$14*SIZEOF_STRUCT_SEGMENT+1
    lda #<$62
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+$14*SIZEOF_STRUCT_SEGMENT
    lda #>$62
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+$14*SIZEOF_STRUCT_SEGMENT+1
    lda #<$a0
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+OFFSET_STRUCT_SPLINEVECTOR16_Y+$14*SIZEOF_STRUCT_SEGMENT
    lda #>$a0
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+OFFSET_STRUCT_SPLINEVECTOR16_Y+$14*SIZEOF_STRUCT_SEGMENT+1
    lda #LINE_TO
    sta letter_c+$15*SIZEOF_STRUCT_SEGMENT
    lda #<$6c
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+$15*SIZEOF_STRUCT_SEGMENT
    lda #>$6c
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+$15*SIZEOF_STRUCT_SEGMENT+1
    lda #<$92
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+OFFSET_STRUCT_SPLINEVECTOR16_Y+$15*SIZEOF_STRUCT_SEGMENT
    lda #>$92
    sta letter_c+OFFSET_STRUCT_SEGMENT_TO+OFFSET_STRUCT_SPLINEVECTOR16_Y+$15*SIZEOF_STRUCT_SEGMENT+1
    lda #<0
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+$15*SIZEOF_STRUCT_SEGMENT
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+$15*SIZEOF_STRUCT_SEGMENT+1
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+OFFSET_STRUCT_SPLINEVECTOR16_Y+$15*SIZEOF_STRUCT_SEGMENT
    sta letter_c+OFFSET_STRUCT_SEGMENT_VIA+OFFSET_STRUCT_SPLINEVECTOR16_Y+$15*SIZEOF_STRUCT_SEGMENT+1
    jsr bitmap_init
    jsr bitmap_clear
    lda #3
    sta CIA2_PORT_A_DDR
    lda #vicSelectGfxBank1_toDd001_return
    sta CIA2_PORT_A
    lda #toD0181_return
    sta D018
    lda #VIC_BMM|VIC_DEN|VIC_RSEL|3
    sta D011
    lda #<0
    sta current_y
    sta current_y+1
    sta current_x
    sta current_x+1
    sta i
  b1:
    lda i
    asl
    asl
    asl
    clc
    adc i
    tay
    ldx letter_c,y
    lda letter_c+OFFSET_STRUCT_SEGMENT_TO,y
    sta current_x_8
    lda letter_c+OFFSET_STRUCT_SEGMENT_TO+1,y
    sta current_x_8+1
    lda letter_c+OFFSET_STRUCT_SEGMENT_TO+OFFSET_STRUCT_SPLINEVECTOR16_Y,y
    sta current_y_8
    lda letter_c+OFFSET_STRUCT_SEGMENT_TO+OFFSET_STRUCT_SPLINEVECTOR16_Y+1,y
    sta current_y_8+1
    lda letter_c+OFFSET_STRUCT_SEGMENT_VIA,y
    sta segment_via_x
    lda letter_c+OFFSET_STRUCT_SEGMENT_VIA+1,y
    sta segment_via_x+1
    lda letter_c+OFFSET_STRUCT_SEGMENT_VIA+OFFSET_STRUCT_SPLINEVECTOR16_Y,y
    sta segment_via_y
    lda letter_c+OFFSET_STRUCT_SEGMENT_VIA+OFFSET_STRUCT_SPLINEVECTOR16_Y+1,y
    sta segment_via_y+1
    cpx #MOVE_TO
    beq b3
    cpx #SPLINE_TO
    beq b2
    lda current_x_8
    sta bitmap_line.x2
    lda current_x_8+1
    sta bitmap_line.x2+1
    lda current_y_8
    sta bitmap_line.y2
    lda current_y_8+1
    sta bitmap_line.y2+1
    jsr bitmap_line
  b3:
    inc i
    lda #$15*SIZEOF_STRUCT_SEGMENT/SIZEOF_STRUCT_SEGMENT+1
    cmp i
    bne b10
  b6:
    inc PRINT_SCREEN+$3e7
    jmp b6
  b10:
    lda current_x_8
    sta current_x
    lda current_x_8+1
    sta current_x+1
    lda current_y_8
    sta current_y
    lda current_y_8+1
    sta current_y+1
    jmp b1
  b2:
    jsr spline_8segB
    jsr bitmap_plot_spline_8seg
    jmp b3
}
// Plot the spline in the SPLINE_8SEG array
bitmap_plot_spline_8seg: {
    .label current_x = 3
    .label current_y = 5
    .label n = 7
    lda SPLINE_8SEG
    sta current_x
    lda SPLINE_8SEG+1
    sta current_x+1
    lda SPLINE_8SEG+OFFSET_STRUCT_SPLINEVECTOR16_Y
    sta current_y
    lda SPLINE_8SEG+OFFSET_STRUCT_SPLINEVECTOR16_Y+1
    sta current_y+1
    lda #1
    sta n
  b1:
    lda n
    asl
    asl
    tax
    lda SPLINE_8SEG,x
    sta bitmap_line.x2
    lda SPLINE_8SEG+1,x
    sta bitmap_line.x2+1
    lda SPLINE_8SEG+OFFSET_STRUCT_SPLINEVECTOR16_Y,x
    sta bitmap_line.y2
    lda SPLINE_8SEG+OFFSET_STRUCT_SPLINEVECTOR16_Y+1,x
    sta bitmap_line.y2+1
    jsr bitmap_line
    lda n
    asl
    asl
    tax
    lda SPLINE_8SEG,x
    sta current_x
    lda SPLINE_8SEG+1,x
    sta current_x+1
    lda SPLINE_8SEG+OFFSET_STRUCT_SPLINEVECTOR16_Y,x
    sta current_y
    lda SPLINE_8SEG+OFFSET_STRUCT_SPLINEVECTOR16_Y+1,x
    sta current_y+1
    inc n
    lda #9
    cmp n
    bne b1
    rts
}
// Draw a line on the bitmap using bresenhams algorithm
// bitmap_line(word zeropage(3) x1, word zeropage(5) y1, word zeropage(8) x2, word zeropage($a) y2)
bitmap_line: {
    .label x = 3
    .label y = 5
    .label dx = $24
    .label dy = $14
    .label sx = $26
    .label sy = $12
    .label e1 = $e
    .label e = $c
    .label x1 = 3
    .label y1 = 5
    .label x2 = 8
    .label y2 = $a
    lda x2
    sec
    sbc x
    sta abs_u16.w
    lda x2+1
    sbc x+1
    sta abs_u16.w+1
    jsr abs_u16
    lda abs_u16.return
    sta dx
    lda abs_u16.return+1
    sta dx+1
    lda y2
    sec
    sbc y
    sta abs_u16.w
    lda y2+1
    sbc y+1
    sta abs_u16.w+1
    jsr abs_u16
    lda dx
    bne b1
    lda dx+1
    bne b1
    lda dy
    bne !+
    lda dy+1
    bne !b4+
    jmp b4
  !b4:
  !:
  b1:
    lda x2
    sec
    sbc x
    sta sgn_u16.w
    lda x2+1
    sbc x+1
    sta sgn_u16.w+1
    jsr sgn_u16
    lda sgn_u16.return
    sta sx
    lda sgn_u16.return+1
    sta sx+1
    lda y2
    sec
    sbc y
    sta sgn_u16.w
    lda y2+1
    sbc y+1
    sta sgn_u16.w+1
    jsr sgn_u16
    lda dy+1
    cmp dx+1
    bcc b2
    bne !+
    lda dy
    cmp dx
    bcc b2
  !:
    lda dx+1
    lsr
    sta e+1
    lda dx
    ror
    sta e
  b6:
    lda y
    tax
    jsr bitmap_plot
    lda y
    clc
    adc sy
    sta y
    lda y+1
    adc sy+1
    sta y+1
    lda e
    clc
    adc dx
    sta e
    lda e+1
    adc dx+1
    sta e+1
    cmp dy+1
    bne !+
    lda e
    cmp dy
    beq b7
  !:
    bcc b7
    lda x
    clc
    adc sx
    sta x
    lda x+1
    adc sx+1
    sta x+1
    lda e
    sec
    sbc dy
    sta e
    lda e+1
    sbc dy+1
    sta e+1
  b7:
    lda y+1
    cmp y2+1
    bne b6
    lda y
    cmp y2
    bne b6
  b3:
    lda y
    tax
    jsr bitmap_plot
    rts
  b2:
    lda dy+1
    lsr
    sta e1+1
    lda dy
    ror
    sta e1
  b9:
    lda y
    tax
    jsr bitmap_plot
    lda x
    clc
    adc sx
    sta x
    lda x+1
    adc sx+1
    sta x+1
    lda e1
    clc
    adc dy
    sta e1
    lda e1+1
    adc dy+1
    sta e1+1
    cmp dx+1
    bne !+
    lda e1
    cmp dx
    beq b10
  !:
    bcc b10
    lda y
    clc
    adc sy
    sta y
    lda y+1
    adc sy+1
    sta y+1
    lda e1
    sec
    sbc dx
    sta e1
    lda e1+1
    sbc dx+1
    sta e1+1
  b10:
    lda x+1
    cmp x2+1
    bne b9
    lda x
    cmp x2
    bne b9
    jmp b3
  b4:
    lda y
    tax
    jsr bitmap_plot
    rts
}
// Plot a single dot in the bitmap
// bitmap_plot(word zeropage(3) x, byte register(X) y)
bitmap_plot: {
    .label _1 = $2a
    .label plotter = $28
    .label x = 3
    lda bitmap_plot_yhi,x
    sta plotter+1
    lda bitmap_plot_ylo,x
    sta plotter
    lda x
    and #<$fff8
    sta _1
    lda x+1
    and #>$fff8
    sta _1+1
    lda plotter
    clc
    adc _1
    sta plotter
    lda plotter+1
    adc _1+1
    sta plotter+1
    lda x
    tay
    lda bitmap_plot_bit,y
    ldy #0
    ora (plotter),y
    sta (plotter),y
    rts
}
// Get the sign of a 16-bit unsigned number treated as a signed number.
// Returns unsigned -1 if the number is
// sgn_u16(word zeropage($10) w)
sgn_u16: {
    .label w = $10
    .label return = $12
    lda w+1
    and #$80
    cmp #0
    bne b1
    lda #<1
    sta return
    lda #>1
    sta return+1
    rts
  b1:
    lda #<-1
    sta return
    lda #>-1
    sta return+1
    rts
}
// Get the absolute value of a 16-bit unsigned number treated as a signed number.
// abs_u16(word zeropage($14) w)
abs_u16: {
    .label w = $14
    .label return = $14
    lda w+1
    and #$80
    cmp #0
    bne b1
    rts
  b1:
    sec
    lda #0
    sbc return
    sta return
    lda #0
    sbc return+1
    sta return+1
    rts
}
// Generate a 8-segment quadratic spline using 16-bit fixed point 1/64-format math (6 decimal bits).
// The resulting spline segment points are returned in SPLINE_8SEG[]
// Point values must be within [-200 ; 1ff] for the calculation to not overflow.
// A quadratic spline is a curve defined by 3 points: P0, P1 and P2.
// The curve connects P0 to P2 through a smooth curve that moves towards P1, but does usually not touch it.
// spline_8segB(signed word zeropage(3) p0_x, signed word zeropage(5) p0_y, signed word zeropage($16) p1_x, signed word zeropage($18) p1_y, signed word zeropage($20) p2_x, signed word zeropage($22) p2_y)
spline_8segB: {
    .label _0 = $2c
    .label _1 = $2c
    .label _3 = $2e
    .label _4 = $2e
    .label _6 = $16
    .label _8 = $18
    .label _10 = $16
    .label _12 = $18
    .label _18 = 3
    .label _19 = 3
    .label _20 = 5
    .label _21 = 5
    .label _22 = $30
    .label _23 = $30
    .label _24 = $32
    .label _25 = $32
    .label a_x = $2c
    .label a_y = $2e
    .label b_x = $16
    .label b_y = $18
    .label i_x = $16
    .label i_y = $18
    .label j_x = $2c
    .label j_y = $2e
    .label p_x = 3
    .label p_y = 5
    .label p0_x = 3
    .label p0_y = 5
    .label p1_x = $16
    .label p1_y = $18
    .label p2_x = $20
    .label p2_y = $22
    lda p1_x
    asl
    sta _0
    lda p1_x+1
    rol
    sta _0+1
    lda p2_x
    sec
    sbc _1
    sta _1
    lda p2_x+1
    sbc _1+1
    sta _1+1
    lda a_x
    clc
    adc p0_x
    sta a_x
    lda a_x+1
    adc p0_x+1
    sta a_x+1
    lda p1_y
    asl
    sta _3
    lda p1_y+1
    rol
    sta _3+1
    lda p2_y
    sec
    sbc _4
    sta _4
    lda p2_y+1
    sbc _4+1
    sta _4+1
    lda a_y
    clc
    adc p0_y
    sta a_y
    lda a_y+1
    adc p0_y+1
    sta a_y+1
    lda _6
    sec
    sbc p0_x
    sta _6
    lda _6+1
    sbc p0_x+1
    sta _6+1
    asl b_x
    rol b_x+1
    lda _8
    sec
    sbc p0_y
    sta _8
    lda _8+1
    sbc p0_y+1
    sta _8+1
    asl b_y
    rol b_y+1
    asl _10
    rol _10+1
    asl _10
    rol _10+1
    asl _10
    rol _10+1
    lda i_x
    clc
    adc a_x
    sta i_x
    lda i_x+1
    adc a_x+1
    sta i_x+1
    asl _12
    rol _12+1
    asl _12
    rol _12+1
    asl _12
    rol _12+1
    lda i_y
    clc
    adc a_y
    sta i_y
    lda i_y+1
    adc a_y+1
    sta i_y+1
    asl j_x
    rol j_x+1
    asl j_y
    rol j_y+1
    lda p_x+1
    sta $ff
    lda p_x
    sta p_x+1
    lda #0
    sta p_x
    lsr $ff
    ror p_x+1
    ror p_x
    lsr $ff
    ror p_x+1
    ror p_x
    lda p_y+1
    sta $ff
    lda p_y
    sta p_y+1
    lda #0
    sta p_y
    lsr $ff
    ror p_y+1
    ror p_y
    lsr $ff
    ror p_y+1
    ror p_y
    tay
  b1:
    lda p_x
    clc
    adc #<$20
    sta _22
    lda p_x+1
    adc #>$20
    sta _22+1
    lda _23
    sta $ff
    lda _23+1
    sta _23
    lda #0
    bit _23+1
    bpl !+
    lda #$ff
  !:
    sta _23+1
    rol $ff
    rol _23
    rol _23+1
    rol $ff
    rol _23
    rol _23+1
    lda p_y
    clc
    adc #<$20
    sta _24
    lda p_y+1
    adc #>$20
    sta _24+1
    lda _25
    sta $ff
    lda _25+1
    sta _25
    lda #0
    bit _25+1
    bpl !+
    lda #$ff
  !:
    sta _25+1
    rol $ff
    rol _25
    rol _25+1
    rol $ff
    rol _25
    rol _25+1
    tya
    asl
    asl
    tax
    lda _23
    sta SPLINE_8SEG,x
    lda _23+1
    sta SPLINE_8SEG+1,x
    lda _25
    sta SPLINE_8SEG+OFFSET_STRUCT_SPLINEVECTOR16_Y,x
    lda _25+1
    sta SPLINE_8SEG+OFFSET_STRUCT_SPLINEVECTOR16_Y+1,x
    lda p_x
    clc
    adc i_x
    sta p_x
    lda p_x+1
    adc i_x+1
    sta p_x+1
    lda p_y
    clc
    adc i_y
    sta p_y
    lda p_y+1
    adc i_y+1
    sta p_y+1
    lda i_x
    clc
    adc j_x
    sta i_x
    lda i_x+1
    adc j_x+1
    sta i_x+1
    lda i_y
    clc
    adc j_y
    sta i_y
    lda i_y+1
    adc j_y+1
    sta i_y+1
    iny
    cpy #8
    beq !b1+
    jmp b1
  !b1:
    lda _18
    clc
    adc #<$20
    sta _18
    lda _18+1
    adc #>$20
    sta _18+1
    lda _19
    sta $ff
    lda _19+1
    sta _19
    lda #0
    bit _19+1
    bpl !+
    lda #$ff
  !:
    sta _19+1
    rol $ff
    rol _19
    rol _19+1
    rol $ff
    rol _19
    rol _19+1
    lda _20
    clc
    adc #<$20
    sta _20
    lda _20+1
    adc #>$20
    sta _20+1
    lda _21
    sta $ff
    lda _21+1
    sta _21
    lda #0
    bit _21+1
    bpl !+
    lda #$ff
  !:
    sta _21+1
    rol $ff
    rol _21
    rol _21+1
    rol $ff
    rol _21
    rol _21+1
    lda _19
    sta SPLINE_8SEG+8*SIZEOF_STRUCT_SPLINEVECTOR16
    lda _19+1
    sta SPLINE_8SEG+8*SIZEOF_STRUCT_SPLINEVECTOR16+1
    lda _21
    sta SPLINE_8SEG+OFFSET_STRUCT_SPLINEVECTOR16_Y+8*SIZEOF_STRUCT_SPLINEVECTOR16
    lda _21+1
    sta SPLINE_8SEG+OFFSET_STRUCT_SPLINEVECTOR16_Y+8*SIZEOF_STRUCT_SPLINEVECTOR16+1
    rts
}
// Clear all graphics on the bitmap
// bgcol - the background color to fill the screen with
// fgcol - the foreground color to fill the screen with
bitmap_clear: {
    .const col = WHITE*$10
    ldx #col
    lda #<BITMAP_SCREEN
    sta memset.str
    lda #>BITMAP_SCREEN
    sta memset.str+1
    lda #<$3e8
    sta memset.num
    lda #>$3e8
    sta memset.num+1
    jsr memset
    ldx #0
    lda #<BITMAP_GRAPHICS
    sta memset.str
    lda #>BITMAP_GRAPHICS
    sta memset.str+1
    lda #<$1f40
    sta memset.num
    lda #>$1f40
    sta memset.num+1
    jsr memset
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// memset(void* zeropage($1c) str, byte register(X) c, word zeropage($1a) num)
memset: {
    .label end = $1a
    .label dst = $1c
    .label num = $1a
    .label str = $1c
    lda num
    beq breturn
    lda num+1
    beq breturn
    lda end
    clc
    adc str
    sta end
    lda end+1
    adc str+1
    sta end+1
  b2:
    txa
    ldy #0
    sta (dst),y
    inc dst
    bne !+
    inc dst+1
  !:
    lda dst+1
    cmp end+1
    bne b2
    lda dst
    cmp end
    bne b2
  breturn:
    rts
}
// Initialize bitmap plotting tables
bitmap_init: {
    .label _7 = $34
    .label yoffs = $1e
    ldx #0
    lda #$80
  b1:
    sta bitmap_plot_bit,x
    lsr
    cmp #0
    bne b2
    lda #$80
  b2:
    inx
    cpx #0
    bne b1
    lda #<BITMAP_GRAPHICS
    sta yoffs
    lda #>BITMAP_GRAPHICS
    sta yoffs+1
    ldx #0
  b3:
    lda #7
    sax _7
    lda yoffs
    ora _7
    sta bitmap_plot_ylo,x
    lda yoffs+1
    sta bitmap_plot_yhi,x
    lda #7
    cmp _7
    bne b4
    clc
    lda yoffs
    adc #<$28*8
    sta yoffs
    lda yoffs+1
    adc #>$28*8
    sta yoffs+1
  b4:
    inx
    cpx #0
    bne b3
    rts
}
  // Array filled with spline segment points by splinePlot_8()
  SPLINE_8SEG: .fill 4*9, 0
  // Tables for the plotter - initialized by calling bitmap_init();
  bitmap_plot_ylo: .fill $100, 0
  bitmap_plot_yhi: .fill $100, 0
  bitmap_plot_bit: .fill $100, 0
  // True type letter a
  letter_c: .fill 9*$15, 0

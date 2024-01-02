/// @file
/// Functions for performing input and output.
  // Commodore 64 PRG executable file
.file [name="ducks-total.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  .const LIGHT_BLUE = $e
  .const down = $11
  .const right = $1d
  .const lock = 8
  .const lower = $e
  .const home = $13
  .const reverse_on = $12
  .const brick = $e6
  .const green = $1e
  .const yellow = $9e
  .const red = $1c
  .const c = $7800
  /// Color Ram
  .label COLORRAM = $d800
  /// Default address of screen character matrix
  .label DEFAULT_SCREEN = $400
  // The number of bytes on the screen
  // The current cursor x-position
  .label conio_cursor_x = $27
  // The current cursor y-position
  .label conio_cursor_y = $1d
  // The current text cursor line start
  .label conio_line_text = $20
  // The current color cursor line start
  .label conio_line_color = $1e
  // The current text color
  .label conio_textcolor = $22
  .label l = $6b
  .label m = 4
  .label z = $25
  .label z_1 = $14
  .label n = $33
  .label k = $63
  .label j = $32
  .label j_1 = $55
  .label j_2 = $56
  .label duck = $16
  // [0..255] 8-bit
  .label tu = $6e
  // Volume to max
  .label score = $2a
  .label y = $28
  .label time = $30
  .label j_3 = $68
  // Remainder after signed 8 bit division
  .label rem8u = $f
  .label peephole = $34
  .label y_1 = $34
  .label hiscore = $2a
  .label hiscore_1 = $6c
.segment Code
__start: {
    // __ma char conio_cursor_x = 0
    lda #0
    sta.z conio_cursor_x
    // __ma char conio_cursor_y = 0
    sta.z conio_cursor_y
    // __ma char *conio_line_text = CONIO_SCREEN_TEXT
    lda #<DEFAULT_SCREEN
    sta.z conio_line_text
    lda #>DEFAULT_SCREEN
    sta.z conio_line_text+1
    // __ma char *conio_line_color = CONIO_SCREEN_COLORS
    lda #<COLORRAM
    sta.z conio_line_color
    lda #>COLORRAM
    sta.z conio_line_color+1
    // __ma char conio_textcolor = CONIO_TEXTCOLOR_DEFAULT
    lda #LIGHT_BLUE
    sta.z conio_textcolor
    // j,k,l,m
    lda #0
    sta.z l
    // j,k,l,m,n=0
    sta.z m
    // #pragma constructor_for(conio_c64_init, cputc, clrscr, cscroll)
    jsr conio_c64_init
    jsr main
    rts
}
// Set initial cursor position
conio_c64_init: {
    // Position cursor at current line
    .label BASIC_CURSOR_LINE = $d6
    .label line = $4c
    // char line = *BASIC_CURSOR_LINE
    lda.z BASIC_CURSOR_LINE
    sta.z line
    // if(line>=CONIO_HEIGHT)
    cmp #$19
    bcc __b1
    lda #$19-1
    sta.z line
  __b1:
    // gotoxy(0, line)
    jsr gotoxy
    // }
    rts
}
main: {
    .label __3 = $70
    .label __26 = 8
    .label __29 = 5
    .label __35 = $66
    .label __57 = $64
    .label __61 = $d
    .label __66 = $b
    .label __69 = $19
    .label __72 = $1b
    .label __78 = $10
    .label __81 = 7
    .label __84 = 3
    .label __88 = $36
    .label __92 = $37
    .label __96 = $2e
    .label __97 = $2e
    .label __104 = $5d
    .label __107 = $5f
    .label __110 = $61
    .label __119 = $4a
    .label __120 = $51
    .label __122 = $53
    .label __124 = $4a
    .label __125 = $4d
    .label __127 = $3a
    .label __128 = $3a
    .label __130 = $3c
    .label __131 = $3c
    .label __133 = $3e
    .label __134 = $3e
    .label __136 = $4f
    .label __138 = $40
    .label __139 = $40
    .label __141 = $42
    .label __142 = $42
    .label __144 = $44
    .label __145 = $44
    .label __150 = $69
    .label __151 = $57
    .label __152 = $57
    .label __153 = $59
    .label __154 = $59
    .label __155 = $5b
    .label __156 = $5b
    .label __177 = 8
    .label __179 = $38
    .label __180 = $2e
    // POKE
    lda #8
    sta $900f
    // chrout(lock)
    lda #lock
    sta.z chrout.petscii
    // border and black paper
    jsr chrout
    // chrout(lower)
    lda #lower
    sta.z chrout.petscii
    //Lock UpperCase to Lowercase key
    jsr chrout
    // m=0
    lda #0
    sta.z m
  //Put text in Lowercase set
  __b1:
    // for (m=0; m<40; m++)
    lda.z m
    cmp #$28
    bcs !__b2+
    jmp __b2
  !__b2:
    lda #0
    sta.z n
    sta.z hiscore_1
    sta.z hiscore_1+1
    sta.z y
    sta.z y+1
    sta.z rem8u
  // Load udgs. From 0-->39;
  __b3:
    // clear_screen(32,0)
    lda #$20
    sta.z clear_screen.n
    jsr clear_screen
    // textcolor(7)
  // Clear Screen with spaces & black ink
    lda #7
    sta.z textcolor.color
    jsr textcolor
    // cputs(intro)
    lda #<intro
    sta.z cputs.s
    lda #>intro
    sta.z cputs.s+1
    jsr cputs
    // textcolor(1)
  // Yellow ink
    lda #1
    sta.z textcolor.color
    jsr textcolor
    // cputs(levels)
    lda #<levels
    sta.z cputs.s
    lda #>levels
    sta.z cputs.s+1
    jsr cputs
    // textcolor(2)
  // White
    lda #2
    sta.z textcolor.color
    jsr textcolor
    // cputs(foot)
    lda #<foot
    sta.z cputs.s
    lda #>foot
    sta.z cputs.s+1
    jsr cputs
  // Red
  __b4:
    // l=PEEK
    lda.z $c5
    sta.z l
    // ++l;
    inc.z l
    // while (l>5)
    lda.z l
    cmp #5+1
    bcs __b4
    // clear_screen(4,0)
  // wait for 1-3-5-7-9 keys only
    lda #4
    sta.z clear_screen.n
    jsr clear_screen
    // POKE
    lda #$ff
    sta $9005
    // chrout(reverse_on)
    lda #reverse_on
    sta.z chrout.petscii
    // Graphic mode
    jsr chrout
    // chrout(red)
    lda #red
    sta.z chrout.petscii
    jsr chrout
    // chrout(down)
    lda #down
    sta.z chrout.petscii
    jsr chrout
    lda #1
    sta.z k
  //for (z=1;z<23;z++) { POKE(7680+z*22,230);POKE(c+7680+z*22,2); POKE(7679+z*22,230); POKE(c+7679+z*22,2); }   // 23 rows * 22 columns (7680 to 8185). 506 positions.
  //k=1; do { chrout(brick); POKE(211,20); chrout(brick);  ++k; } while (k<23);
  //for (k=1;k<22;k++) { chrout(brick); POKE(211,22); chrout(brick); }; // 23 rows * 22 columns (7680 to 8185). 506 positions.
  __b6:
    // for (k=1;k<22;k++)
    lda.z k
    cmp #$16
    bcs !__b7+
    jmp __b7
  !__b7:
    // chrout(brick)
    lda #brick
    sta.z chrout.petscii
    // 23 rows * 22 columns (7680 to 8185). 506 positions.
    jsr chrout
    // POKE
    lda #brick
    sta $1ff9
    lda #2
    sta $1ff9+c
    // chrout(home)
    lda #home
    sta.z chrout.petscii
    //last brick from last line (#23) to avoid scrolling
    jsr chrout
    // if (l>1)
    lda.z l
    cmp #1+1
    bcc __b8
    lda #<1
    sta.z z_1
    lda #>1
    sta.z z_1+1
  __b13:
    // random((7-l),26-(3*l))
    lda #7
    sec
    sbc.z l
    sta.z random.k
    // 3*l
    lda.z l
    asl
    sta.z __177
    lda.z __26
    clc
    adc.z l
    sta.z __26
    // random((7-l),26-(3*l))
    lda #$1a
    sec
    sbc.z random.n
    sta.z random.n
  // Write differential random bricks depending on 'l' level choosen
    jsr random
    // z+m
    lda.z m
    clc
    adc.z z_1
    sta.z __29
    lda #0
    adc.z z_1+1
    sta.z __29+1
    // if (z+m>505)
    cmp #>$1f9
    bne !+
    lda.z __29
    cmp #<$1f9
  !:
    bcs !__b24+
    jmp __b24
  !__b24:
    bne !__b24+
    jmp __b24
  !__b24:
    jmp __b12
  __b8:
    lda #<1
    sta.z z_1
    lda #>1
    sta.z z_1+1
  __b12:
    // POKE
    lda #$f
    sta $900e
    // chrout(home)
    lda #home
    sta.z chrout.petscii
    // Duck #1
    jsr chrout
    // chrout(yellow)
    lda #yellow
    sta.z chrout.petscii
    jsr chrout
    // chrout(80)
    lda #$50
    sta.z chrout.petscii
    jsr chrout
    // chrout(84)
    lda #$54
    sta.z chrout.petscii
    jsr chrout
    // chrout(83)
    lda #$53
    sta.z chrout.petscii
    jsr chrout
    // chrout(58)
    lda #$3a
    sta.z chrout.petscii
    jsr chrout
    // POKE
    lda #$12
    sta.z $d3
    lda #0
    sta.z j_1
  // jump to Column 18
  __b17:
    // for (j=0; j<4; ++j)
    lda.z j_1
    cmp #4
    bcs !__b18+
    jmp __b18
  !__b18:
    // write_score()
  // Write 'TM:9', yellow
    lda #<0
    sta.z score
    sta.z score+1
    jsr write_score
    // chrout(home)
    lda #home
    sta.z chrout.petscii
    // Write Score (yellow)
    jsr chrout
    // chrout(green)
    lda #green
    sta.z chrout.petscii
    jsr chrout
    // POKE
    lda #$a
    sta.z $d3
    lda #0
    sta.z j_2
  // Jump to column 10
  __b20:
    // for (j=0; j<5; j++)
    lda.z j_2
    cmp #5
    bcs !__b21+
    jmp __b21
  !__b21:
    lda #<$1f1f
    sta.z peephole
    lda #>$1f1f
    sta.z peephole+1
    lda #<1
    sta.z tu
    lda #>1
    sta.z tu+1
  // Write 'DUCK', green
  __b22:
    // chrout(home)
    lda #home
    sta.z chrout.petscii
    jsr chrout
    // chrout(green)
    lda #green
    sta.z chrout.petscii
    jsr chrout
    // chrout(reverse_on)
    lda #reverse_on
    sta.z chrout.petscii
    jsr chrout
    // POKE
    lda #$f
    sta.z $d3
    // if (tu<10)
    // Jump to column 15
    lda.z tu+1
    bne !+
    lda.z tu
    cmp #$a
    bcs !__b23+
    jmp __b23
  !__b23:
  !:
    // chrout(49)
    lda #$31
    sta.z chrout.petscii
    jsr chrout
    // chrout(48)
    lda #$30
    sta.z chrout.petscii
    jsr chrout
  __b11:
  // Write duck number
    // random(0,255)
    lda #$ff
    sta.z random.n
    lda #0
    sta.z random.k
    jsr random
    // duck=m
    lda.z m
    sta.z duck
    lda #0
    sta.z duck+1
    // random(0,255)
    lda #$ff
    sta.z random.n
    lda #0
    sta.z random.k
    jsr random
    // m+7701
    lda.z m
    clc
    adc #<$1e15
    sta.z __61
    lda #>$1e15
    adc #0
    sta.z __61+1
    // duck=m+7701+duck
    clc
    lda.z duck
    adc.z __61
    sta.z duck
    lda.z duck+1
    adc.z __61+1
    sta.z duck+1
    // PEEK
    clc
    lda.z duck
    adc #1
    sta.z __66
    lda.z duck+1
    adc #0
    sta.z __66+1
    lda #$16
    clc
    adc.z duck
    sta.z __69
    lda #0
    adc.z duck+1
    sta.z __69+1
    lda #$17
    clc
    adc.z duck
    sta.z __72
    lda #0
    adc.z duck+1
    sta.z __72+1
    // while ((duck>8163) || PEEK(duck)==brick || PEEK(duck+1)==brick || PEEK(duck+22)==brick || PEEK(duck+23)==brick)
    lda #>$1fe3
    cmp.z duck+1
    bcc __b11
    bne !+
    lda #<$1fe3
    cmp.z duck
    bcc __b11
  !:
    lda #brick
    ldy #0
    cmp (duck),y
    beq __b11
    cmp (__66),y
    beq __b11
    cmp (__69),y
    beq __b11
    cmp (__72),y
    bne !__b11+
    jmp __b11
  !__b11:
    // chrono_restart()
    jsr chrono_restart
    lda #<0
    sta.z time
    sta.z time+1
  __b26:
    // while (time<10)
    lda.z time+1
    bne !+
    lda.z time
    cmp #$a
    bcs !__b27+
    jmp __b27
  !__b27:
  !:
    // tu++;
    inc.z tu
    bne !+
    inc.z tu+1
  !:
    // score=score-10
    sec
    lda.z score
    sbc #$a
    sta.z score
    lda.z score+1
    sbc #0
    sta.z score+1
    // write_score()
    jsr write_score
    // POKE
    lda #$82
    sta $900d
    // wait(20)
    lda #$14
    sta.z wait.n
    jsr wait
    // POKE
    lda #0
    sta $900d
    lda.z duck
    clc
    adc #<c
    sta.z __150
    lda.z duck+1
    adc #>c
    sta.z __150+1
    lda #0
    tay
    sta (__150),y
    lda.z duck
    sta.z __151
    lda.z duck+1
    sta.z __151+1
    lda.z __152
    clc
    adc #<1+c
    sta.z __152
    lda.z __152+1
    adc #>1+c
    sta.z __152+1
    tya
    sta (__152),y
    lda.z duck
    sta.z __153
    lda.z duck+1
    sta.z __153+1
    lda.z __154
    clc
    adc #<$16+c
    sta.z __154
    lda.z __154+1
    adc #>$16+c
    sta.z __154+1
    tya
    sta (__154),y
    lda.z duck
    sta.z __155
    lda.z duck+1
    sta.z __155+1
    lda.z __156
    clc
    adc #<$17+c
    sta.z __156
    lda.z __156+1
    adc #>$17+c
    sta.z __156+1
    tya
    sta (__156),y
    // while (tu<11)
    lda.z tu+1
    bne !+
    lda.z tu
    cmp #$b
    bcs !__b22+
    jmp __b22
  !__b22:
  !:
    // clear_screen(4,0)
  // 10 ducks
    lda #4
    sta.z clear_screen.n
    jsr clear_screen
    // POKE
    lda #$f0
    sta $9005
    // chrout(lower)
    lda #lower
    sta.z chrout.petscii
    jsr chrout
    // textcolor(7)
  // Return to text mode, lowcase
    lda #7
    sta.z textcolor.color
    jsr textcolor
    // cputs(game_over)
    lda #<game_over
    sta.z cputs.s
    lda #>game_over
    sta.z cputs.s+1
    jsr cputs
    // textcolor(2)
  // Yellow
    lda #2
    sta.z textcolor.color
    jsr textcolor
    // cputs(your_score)
    lda #<your_score
    sta.z cputs.s
    lda #>your_score
    sta.z cputs.s+1
    jsr cputs
    // cputs(buffer)
    lda #<buffer
    sta.z cputs.s
    lda #>buffer
    sta.z cputs.s+1
    jsr cputs
    // textcolor(3)
  // Red
    lda #3
    sta.z textcolor.color
    jsr textcolor
    // cputs(high_score)
    lda #<high_score
    sta.z cputs.s
    lda #>high_score
    sta.z cputs.s+1
    jsr cputs
    // if (score>hiscore)
    lda.z score+1
    cmp.z hiscore_1+1
    bne !+
    lda.z score
    cmp.z hiscore_1
    beq __b114
  !:
    bcc __b114
    jmp __b46
  __b114:
    lda.z hiscore_1
    sta.z hiscore
    lda.z hiscore_1+1
    sta.z hiscore+1
  __b46:
    // utoa(hiscore,buffer,10)
    lda.z hiscore
    sta.z utoa.value
    lda.z hiscore+1
    sta.z utoa.value+1
    jsr utoa
    // cputs(buffer)
    lda #<buffer
    sta.z cputs.s
    lda #>buffer
    sta.z cputs.s+1
    jsr cputs
    // textcolor(1)
  // Cyan
    lda #1
    sta.z textcolor.color
    jsr textcolor
    // cputs(play_again)
    lda #<play_again
    sta.z cputs.s
    lda #>play_again
    sta.z cputs.s+1
    jsr cputs
  // white
  __b47:
    // j=PEEK
    lda.z $c5
    sta.z j_3
    // while (j!= 11 && j!=28 )
    lda #$b
    cmp.z j_3
    beq __b48
    lda #$1c
    cmp.z j_3
    bne __b47
  __b48:
    // while (j==11)
    lda #$b
    cmp.z j_3
    beq __b113
    // asm
    // N pressed. Exit game
    jsr $fd22
    // }
    rts
  __b113:
    lda.z hiscore
    sta.z hiscore_1
    lda.z hiscore+1
    sta.z hiscore_1+1
    jmp __b3
  __b27:
    // read_chrono()
    jsr read_chrono
    // m=PEEK
    // Joystick routine
    lda $911f
    sta.z m
    // POKE
    lda #$7f
    sta $9122
    // n=PEEK
    lda $9120
    sta.z n
    // POKE
    lda #$ff
    sta $9122
    // 16&m
    lda #$10
    and.z m
    sta.z __78
    // if ((16&m)==0)
    bne __b29
    // y--;
    lda.z y
    bne !+
    dec.z y+1
  !:
    dec.z y
  __b29:
    // 128&n
    lda #$80
    and.z n
    sta.z __81
    // if ((128&n)==0)
    bne __b30
    // y++;
    inc.z y
    bne !+
    inc.z y+1
  !:
  __b30:
    // 4&m
    lda #4
    and.z m
    sta.z __84
    // if ((4&m)==0)
    bne __b31
    // y=y-22
    sec
    lda.z y
    sbc #$16
    sta.z y
    lda.z y+1
    sbc #0
    sta.z y+1
  __b31:
    // 8&m
    lda #8
    and.z m
    sta.z __88
    // if ((8&m)==0)
    bne __b32
    // y=y+22
    lda #$16
    clc
    adc.z y
    sta.z y
    bcc !+
    inc.z y+1
  !:
  __b32:
    // 32&m
    lda #$20
    and.z m
    sta.z __92
    // if ((32&m)==0)
    bne __b33
    // POKE
    lda #$82
    sta $900d
    // if (peephole!=duck)
    lda.z peephole+1
    cmp.z duck+1
    beq !__b34+
    jmp __b34
  !__b34:
    lda.z peephole
    cmp.z duck
    beq !__b34+
    jmp __b34
  !__b34:
    // 12-time
    sec
    lda #<$c
    sbc.z div16u8u.return_1
    sta.z __96
    lda #>$c
    sbc.z div16u8u.return_1+1
    sta.z __96+1
    // (12-time)*10
    lda.z __96
    asl
    sta.z __179
    lda.z __96+1
    rol
    sta.z __179+1
    asl.z __179
    rol.z __179+1
    clc
    lda.z __180
    adc.z __179
    sta.z __180
    lda.z __180+1
    adc.z __179+1
    sta.z __180+1
    asl.z __97
    rol.z __97+1
    // score=score+(12-time)*10
    clc
    lda.z score
    adc.z __97
    sta.z score
    lda.z score+1
    adc.z __97+1
    sta.z score+1
    // wait(10)
    lda #$a
    sta.z wait.n
    jsr wait
    lda #<$a
    sta.z time
    lda #>$a
    sta.z time+1
  __b35:
    // POKE
    lda #0
    sta $900d
  __b33:
    // PEEK
    clc
    lda.z y
    adc #1
    sta.z __104
    lda.z y+1
    adc #0
    sta.z __104+1
    lda #$16
    clc
    adc.z y
    sta.z __107
    lda #0
    adc.z y+1
    sta.z __107+1
    lda #$17
    clc
    adc.z y
    sta.z __110
    lda #0
    adc.z y+1
    sta.z __110+1
    // if (PEEK(y)!=brick && PEEK(y+1)!=brick && PEEK(y+22)!=brick && PEEK(y+23)!=brick && y>7702 && y<8163)
    lda #brick
    ldy #0
    cmp (y),y
    beq __b36
    cmp (__104),y
    beq __b36
    lda (__107),y
    cmp #brick
    beq !__b109+
    jmp __b109
  !__b109:
  __b36:
    // POKE
    lda #$fd
    ldy #0
    sta (y_1),y
    lda.z y_1
    clc
    adc #<c
    sta.z __125
    lda.z y_1+1
    adc #>c
    sta.z __125+1
    lda #1
    sta (__125),y
    clc
    lda.z y_1
    adc #1
    sta.z __127
    lda.z y_1+1
    adc #0
    sta.z __127+1
    lda #$ed
    sta (__127),y
    lda.z __128
    clc
    adc #<c
    sta.z __128
    lda.z __128+1
    adc #>c
    sta.z __128+1
    lda #1
    sta (__128),y
    lda #$16
    clc
    adc.z y_1
    sta.z __130
    tya
    adc.z y_1+1
    sta.z __130+1
    lda #$ee
    sta (__130),y
    lda.z __131
    clc
    adc #<c
    sta.z __131
    lda.z __131+1
    adc #>c
    sta.z __131+1
    lda #1
    sta (__131),y
    lda #$17
    clc
    adc.z y_1
    sta.z __133
    tya
    adc.z y_1+1
    sta.z __133+1
    lda #$f0
    sta (__133),y
    lda.z __134
    clc
    adc #<c
    sta.z __134
    lda.z __134+1
    adc #>c
    sta.z __134+1
    lda #1
    sta (__134),y
    // wait(5)
  // Clear peephole if there is not bricks contact
    lda #5
    sta.z wait.n
    jsr wait
    // POKE
    lda #0
    tay
    sta (duck),y
    lda.z duck
    clc
    adc #<c
    sta.z __136
    lda.z duck+1
    adc #>c
    sta.z __136+1
    lda #7
    sta (__136),y
    clc
    lda.z duck
    adc #1
    sta.z __138
    lda.z duck+1
    adc #0
    sta.z __138+1
    lda #1
    sta (__138),y
    lda.z __139
    clc
    adc #<c
    sta.z __139
    lda.z __139+1
    adc #>c
    sta.z __139+1
    lda #7
    sta (__139),y
    lda #$16
    clc
    adc.z duck
    sta.z __141
    tya
    adc.z duck+1
    sta.z __141+1
    lda #2
    sta (__141),y
    lda.z __142
    clc
    adc #<c
    sta.z __142
    lda.z __142+1
    adc #>c
    sta.z __142+1
    lda #7
    sta (__142),y
    lda #$17
    clc
    adc.z duck
    sta.z __144
    tya
    adc.z duck+1
    sta.z __144+1
    lda #3
    sta (__144),y
    lda.z __145
    clc
    adc #<c
    sta.z __145
    lda.z __145+1
    adc #>c
    sta.z __145+1
    lda #7
    sta (__145),y
    // wait(5)
    lda #5
    sta.z wait.n
    jsr wait
    lda.z y_1
    sta.z y
    lda.z y_1+1
    sta.z y+1
    jmp __b26
  __b109:
    // if (PEEK(y)!=brick && PEEK(y+1)!=brick && PEEK(y+22)!=brick && PEEK(y+23)!=brick && y>7702 && y<8163)
    lda #brick
    ldy #0
    cmp (__110),y
    bne !__b36+
    jmp __b36
  !__b36:
    lda #>$1e16
    cmp.z y+1
    bcc __b107
    bne !+
    lda #<$1e16
    cmp.z y
    bcc __b107
  !:
    jmp __b36
  __b107:
    lda.z y+1
    cmp #>$1fe3
    bcc !+
    beq !__b36+
    jmp __b36
  !__b36:
    lda.z y
    cmp #<$1fe3
    bcc !__b36+
    jmp __b36
  !__b36:
  !:
    // POKE
    lda.z peephole
    clc
    adc #<c
    sta.z __119
    lda.z peephole+1
    adc #>c
    sta.z __119+1
    lda #0
    tay
    sta (__119),y
    clc
    lda.z __119
    adc #1
    sta.z __120
    lda.z __119+1
    adc #0
    sta.z __120+1
    tya
    sta (__120),y
    lda #$16
    clc
    adc.z __119
    sta.z __122
    tya
    adc.z __119+1
    sta.z __122+1
    tya
    sta (__122),y
    lda #$17
    clc
    adc.z __124
    sta.z __124
    bcc !+
    inc.z __124+1
  !:
    lda #0
    tay
    sta (__124),y
    lda.z y
    sta.z y_1
    lda.z y+1
    sta.z y_1+1
    jmp __b36
  __b34:
    // score=score-10
    sec
    lda.z score
    sbc #$a
    sta.z score
    lda.z score+1
    sbc #0
    sta.z score+1
    // write_score()
    jsr write_score
    // wait(10)
    lda #$a
    sta.z wait.n
    jsr wait
    jmp __b35
  __b23:
    // 48+tu
    lda #$30
    clc
    adc.z tu
    sta.z __57
    lda #0
    adc.z tu+1
    sta.z __57+1
    // chrout(48+tu)
    lda.z __57
    sta.z chrout.petscii
    jsr chrout
    jmp __b11
  __b21:
    // chrout(ducknumber[j])
    ldy.z j_2
    lda ducknumber,y
    sta.z chrout.petscii
    jsr chrout
    // for (j=0; j<5; j++)
    inc.z j_2
    jmp __b20
  __b18:
    // chrout(chrono[j])
    ldy.z j_1
    lda chrono,y
    sta.z chrout.petscii
    jsr chrout
    // for (j=0; j<4; ++j)
    inc.z j_1
    jmp __b17
  __b24:
    lda #1
    sta.z j
  __b14:
    // for (j=1; j<=m; ++j)
    lda.z m
    cmp.z j
    bcs __b15
    // chrout(brick)
    lda #brick
    sta.z chrout.petscii
    jsr chrout
    // z+m
    lda.z m
    clc
    adc.z z_1
    sta.z __35
    lda #0
    adc.z z_1+1
    sta.z __35+1
    // z=z+m+1
    clc
    lda.z __35
    adc #1
    sta.z z_1
    lda.z __35+1
    adc #0
    sta.z z_1+1
    // while (z<506)
    cmp #>$1fa
    bcs !__b13+
    jmp __b13
  !__b13:
    bne !+
    lda.z z_1
    cmp #<$1fa
    bcs !__b13+
    jmp __b13
  !__b13:
  !:
    jmp __b12
  __b15:
    // chrout(right)
    lda #right
    sta.z chrout.petscii
    jsr chrout
    // for (j=1; j<=m; ++j)
    inc.z j
    jmp __b14
  __b7:
    // chrout(brick)
    lda #brick
    sta.z chrout.petscii
    jsr chrout
    lda #2
    sta.z n
  __b9:
    // for(n=2;n<22;++n)
    lda.z n
    cmp #$16
    bcc __b10
    // chrout(brick)
    lda #brick
    sta.z chrout.petscii
    jsr chrout
    // for (k=1;k<22;k++)
    inc.z k
    jmp __b6
  __b10:
    // chrout(right)
    lda #right
    sta.z chrout.petscii
    jsr chrout
    // for(n=2;n<22;++n)
    inc.z n
    jmp __b9
  __b2:
    // POKE
    lda.z m
    clc
    adc #<$1c00
    sta.z __3
    lda #>$1c00
    adc #0
    sta.z __3+1
    ldy.z m
    lda duck_udg,y
    ldy #0
    sta (__3),y
    // for (m=0; m<40; m++)
    inc.z m
    jmp __b1
}
// Set the cursor to the specified position
// void gotoxy(char x, __zp($4c) char y)
gotoxy: {
    .label __5 = $48
    .label __6 = $2c
    .label __7 = $2c
    .label line_offset = $2c
    .label y = $4c
    .label __8 = $46
    .label __9 = $2c
    // if(y>CONIO_HEIGHT)
    lda.z y
    cmp #$19+1
    bcc __b2
    lda #0
    sta.z y
  __b2:
    // conio_cursor_x = x
    lda #0
    sta.z conio_cursor_x
    // conio_cursor_y = y
    lda.z y
    sta.z conio_cursor_y
    // unsigned int line_offset = (unsigned int)y*CONIO_WIDTH
    lda.z y
    sta.z __7
    lda #0
    sta.z __7+1
    lda.z __7
    asl
    sta.z __8
    lda.z __7+1
    rol
    sta.z __8+1
    asl.z __8
    rol.z __8+1
    clc
    lda.z __9
    adc.z __8
    sta.z __9
    lda.z __9+1
    adc.z __8+1
    sta.z __9+1
    asl.z line_offset
    rol.z line_offset+1
    asl.z line_offset
    rol.z line_offset+1
    asl.z line_offset
    rol.z line_offset+1
    // CONIO_SCREEN_TEXT + line_offset
    lda.z line_offset
    clc
    adc #<DEFAULT_SCREEN
    sta.z __5
    lda.z line_offset+1
    adc #>DEFAULT_SCREEN
    sta.z __5+1
    // conio_line_text = CONIO_SCREEN_TEXT + line_offset
    lda.z __5
    sta.z conio_line_text
    lda.z __5+1
    sta.z conio_line_text+1
    // CONIO_SCREEN_COLORS + line_offset
    lda.z __6
    clc
    adc #<COLORRAM
    sta.z __6
    lda.z __6+1
    adc #>COLORRAM
    sta.z __6+1
    // conio_line_color = CONIO_SCREEN_COLORS + line_offset
    lda.z __6
    sta.z conio_line_color
    lda.z __6+1
    sta.z conio_line_color+1
    // }
    rts
}
// void chrout(__zp($18) volatile char petscii)
chrout: {
    .label petscii = $18
    // asm
    lda petscii
    jsr $ffd2
    // }
    rts
}
// void clear_screen(__zp(8) char n, char m)
clear_screen: {
    .label __4 = $23
    .label __5 = 9
    .label n = 8
    lda #<0
    sta.z z
    sta.z z+1
  __b1:
    // for (z=0; z<506; ++z)
    lda.z z+1
    cmp #>$1fa
    bcc __b2
    bne !+
    lda.z z
    cmp #<$1fa
    bcc __b2
  !:
    // gotoxy(0,0)
  // From 0-->505 (506 bytes). ClearScreen with byte 'n' with color 'm'
    lda #0
    sta.z gotoxy.y
    jsr gotoxy
    // chrout(home)
    lda #home
    sta.z chrout.petscii
    jsr chrout
    // }
    rts
  __b2:
    // POKE
    lda.z z
    clc
    adc #<$1e00
    sta.z __5
    lda.z z+1
    adc #>$1e00
    sta.z __5+1
    lda.z __5
    clc
    adc #<c
    sta.z __4
    lda.z __5+1
    adc #>c
    sta.z __4+1
    lda #0
    tay
    sta (__4),y
    lda.z n
    sta (__5),y
    // for (z=0; z<506; ++z)
    inc.z z
    bne !+
    inc.z z+1
  !:
    jmp __b1
}
// Set the color for text output. The old color setting is returned.
// char textcolor(__zp(8) char color)
textcolor: {
    .label color = 8
    // conio_textcolor = color
    lda.z color
    sta.z conio_textcolor
    // }
    rts
}
// Output a NUL-terminated string at the current cursor position
// void cputs(__zp(5) const char *s)
cputs: {
    .label c = 2
    .label s = 5
  __b1:
    // while(c=*s++)
    ldy #0
    lda (s),y
    sta.z c
    inc.z s
    bne !+
    inc.z s+1
  !:
    lda.z c
    bne __b2
    // }
    rts
  __b2:
    // cputc(c)
    jsr cputc
    jmp __b1
}
// Return to home position
// void random(__zp(3) char k, __zp(8) char n)
random: {
    .label k = 3
    .label n = 8
    .label __3 = 2
  __b1:
    // m=PEEK
    lda $9114
    sta.z m
    // m>n
    sta.z __3
    // while (m<k || m>n)
    lda.z m
    cmp.z k
    bcc __b1
    lda.z n
    cmp.z __3
    bcc __b1
    // }
    rts
}
write_score: {
    // if (score>65000)
    lda.z score+1
    cmp #>$fde8
    bne !+
    lda.z score
    cmp #<$fde8
  !:
    bcc __b1
    beq __b1
    lda #<0
    sta.z score
    sta.z score+1
  __b1:
    // m=0
    lda #0
    sta.z m
  __b5:
    // for (m=0;m<4;m++)
    lda.z m
    cmp #4
    bcc __b6
    // utoa(score,buffer,10)
    lda.z score
    sta.z utoa.value
    lda.z score+1
    sta.z utoa.value+1
  // (!!) Needed. Possibly a bug
    jsr utoa
    // if (score>9)
    lda.z score+1
    bne !+
    lda.z score
    cmp #9+1
    bcc __b2
  !:
    // points[2]=buffer[0]
    lda buffer
    sta points+2
    // points[3]=buffer[1]
    lda buffer+1
    sta points+3
  __b2:
    // if (score>99)
    lda.z score+1
    bne !+
    lda.z score
    cmp #$63+1
    bcc __b3
  !:
    // points[1]=buffer[0]
    lda buffer
    sta points+1
    // points[2]=buffer[1]
    lda buffer+1
    sta points+2
    // points[3]=buffer[2]
    lda buffer+2
    sta points+3
  __b3:
    // chrout(yellow)
    lda #yellow
    sta.z chrout.petscii
    jsr chrout
    // chrout(home)
    lda #home
    sta.z chrout.petscii
    jsr chrout
    // POKE
    lda #4
    sta.z $d3
    // m=0
    lda #0
    sta.z m
  __b9:
    // for (m=0;m<4;m++)
    lda.z m
    cmp #4
    bcc __b10
    // }
    rts
  __b10:
    // chrout(points[m])
    ldy.z m
    lda points,y
    sta.z chrout.petscii
    jsr chrout
    // for (m=0;m<4;m++)
    inc.z m
    jmp __b9
  __b6:
    // points[m]='0'
    lda #'0'
    ldy.z m
    sta points,y
    // for (m=0;m<4;m++)
    inc.z m
    jmp __b5
}
chrono_restart: {
    // asm
    lda #0
    tay
    tax
    jsr $ffdb
    // }
    rts
}
// void wait(__zp(3) char n)
wait: {
    .label n = 3
    // m=0
    lda #0
    sta.z m
  __b1:
    // for (m=0;m<n;++m)
    lda.z m
    cmp.z n
    bcc __b4
    // }
    rts
  __b4:
    lda #<0
    sta.z z_1
    sta.z z_1+1
  __b2:
    // for (z=0;z<540;++z)
    lda.z z_1+1
    cmp #>$21c
    bcc __b3
    bne !+
    lda.z z_1
    cmp #<$21c
    bcc __b3
  !:
    // for (m=0;m<n;++m)
    inc.z m
    jmp __b1
  __b3:
    // for (z=0;z<540;++z)
    inc.z z_1
    bne !+
    inc.z z_1+1
  !:
    jmp __b2
}
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// void utoa(__zp(5) unsigned int value, __zp($d) char *buffer, char radix)
utoa: {
    .label __10 = $11
    .label __11 = 2
    .label digit_value = 9
    .label buffer = $d
    .label digit = 3
    .label value = 5
    .label started = $10
    lda #<@buffer
    sta.z buffer
    lda #>@buffer
    sta.z buffer+1
    lda #0
    sta.z started
    sta.z digit
  __b1:
    // for( char digit=0; digit<max_digits-1; digit++ )
    lda.z digit
    cmp #5-1
    bcc __b2
    // *buffer++ = DIGITS[(char)value]
    lda.z value
    sta.z __11
    tay
    lda DIGITS,y
    ldy #0
    sta (buffer),y
    // *buffer++ = DIGITS[(char)value];
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // *buffer = 0
    lda #0
    tay
    sta (buffer),y
    // }
    rts
  __b2:
    // unsigned int digit_value = digit_values[digit]
    lda.z digit
    asl
    sta.z __10
    tay
    lda RADIX_DECIMAL_VALUES,y
    sta.z digit_value
    lda RADIX_DECIMAL_VALUES+1,y
    sta.z digit_value+1
    // if (started || value >= digit_value)
    lda.z started
    bne __b5
    lda.z digit_value+1
    cmp.z value+1
    bne !+
    lda.z digit_value
    cmp.z value
    beq __b5
  !:
    bcc __b5
  __b4:
    // for( char digit=0; digit<max_digits-1; digit++ )
    inc.z digit
    jmp __b1
  __b5:
    // utoa_append(buffer++, value, digit_value)
    jsr utoa_append
    // utoa_append(buffer++, value, digit_value)
    // value = utoa_append(buffer++, value, digit_value)
    // value = utoa_append(buffer++, value, digit_value);
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    lda #1
    sta.z started
    jmp __b4
}
read_chrono: {
    .label __0 = $23
    .label __5 = 9
    // asm
    jsr $ffde
    sta l
    stx m
    // m*256
    txa
    sta.z __0+1
    lda #0
    sta.z __0
    // div16u8u((m*256)+l,60)
    lda.z l
    clc
    adc.z div16u8u.dividend
    sta.z div16u8u.dividend
    bcc !+
    inc.z div16u8u.dividend+1
  !:
    jsr div16u8u
    lda.z div16u8u.return
    sta.z div16u8u.return_1
    lda.z div16u8u.return+1
    sta.z div16u8u.return_1+1
    // POKE
    lda #7
    sta $1e15+c
    lda #$b9
    sta $1e15
    // if (time<10)
    lda.z div16u8u.return_1+1
    bne __breturn
    lda.z div16u8u.return_1
    cmp #$a
    bcs __breturn
  !:
    // POKE
    sec
    lda #<$b9
    sbc.z div16u8u.return_1
    sta.z __5
    lda #>$b9
    sbc.z div16u8u.return_1+1
    sta.z __5+1
    lda.z __5
    sta $1e15
  __breturn:
    // }
    rts
}
// Output one character at the current cursor position
// Moves the cursor forward. Scrolls the entire screen if needed
// void cputc(__zp(2) char c)
cputc: {
    .label c = 2
    // if(c=='\n')
    lda #'\n'
    cmp.z c
    beq __b1
    // conio_line_text[conio_cursor_x] = c
    lda.z c
    ldy.z conio_cursor_x
    sta (conio_line_text),y
    // conio_line_color[conio_cursor_x] = conio_textcolor
    lda.z conio_textcolor
    sta (conio_line_color),y
    // if(++conio_cursor_x==CONIO_WIDTH)
    inc.z conio_cursor_x
    lda #$28
    cmp.z conio_cursor_x
    bne __breturn
    // cputln()
    jsr cputln
  __breturn:
    // }
    rts
  __b1:
    // cputln()
    jsr cputln
    rts
}
// Used to convert a single digit of an unsigned number value to a string representation
// Counts a single digit up from '0' as long as the value is larger than sub.
// Each time the digit is increased sub is subtracted from value.
// - buffer : pointer to the char that receives the digit
// - value : The value where the digit will be derived from
// - sub : the value of a '1' in the digit. Subtracted continually while the digit is increased.
//        (For decimal the subs used are 10000, 1000, 100, 10, 1)
// returns : the value reduced by sub * digit so that it is less than sub.
// __zp(5) unsigned int utoa_append(__zp($d) char *buffer, __zp(5) unsigned int value, __zp(9) unsigned int sub)
utoa_append: {
    .label buffer = $d
    .label value = 5
    .label sub = 9
    .label return = 5
    .label digit = 7
    lda #0
    sta.z digit
  __b1:
    // while (value >= sub)
    lda.z sub+1
    cmp.z value+1
    bne !+
    lda.z sub
    cmp.z value
    beq __b2
  !:
    bcc __b2
    // *buffer = DIGITS[digit]
    ldy.z digit
    lda DIGITS,y
    ldy #0
    sta (buffer),y
    // }
    rts
  __b2:
    // digit++;
    inc.z digit
    // value -= sub
    lda.z value
    sec
    sbc.z sub
    sta.z value
    lda.z value+1
    sbc.z sub+1
    sta.z value+1
    jmp __b1
}
// Divide unsigned 16-bit unsigned long dividend with a 8-bit unsigned char divisor
// The 8-bit unsigned char remainder can be found in rem8u after the division
// __zp($30) unsigned int div16u8u(__zp($23) unsigned int dividend, char divisor)
div16u8u: {
    .label divisor = $3c
    .label quotient_hi = 2
    .label quotient_lo = $10
    .label return = $12
    .label dividend = $23
    .label return_1 = $30
    // unsigned char quotient_hi = divr8u(BYTE1(dividend), divisor, 0)
    lda.z dividend+1
    sta.z divr8u.dividend
    lda #0
    sta.z divr8u.rem
    jsr divr8u
    // unsigned char quotient_hi = divr8u(BYTE1(dividend), divisor, 0)
    lda.z divr8u.return
    sta.z quotient_hi
    // unsigned char quotient_lo = divr8u(BYTE0(dividend), divisor, rem8u)
    lda.z dividend
    sta.z divr8u.dividend
    jsr divr8u
    // unsigned char quotient_lo = divr8u(BYTE0(dividend), divisor, rem8u)
    // unsigned int quotient = MAKEWORD( quotient_hi, quotient_lo )
    lda.z quotient_hi
    sta.z return+1
    lda.z quotient_lo
    sta.z return
    // }
    rts
}
// Print a newline
cputln: {
    // conio_line_text +=  CONIO_WIDTH
    lda #$28
    clc
    adc.z conio_line_text
    sta.z conio_line_text
    bcc !+
    inc.z conio_line_text+1
  !:
    // conio_line_color += CONIO_WIDTH
    lda #$28
    clc
    adc.z conio_line_color
    sta.z conio_line_color
    bcc !+
    inc.z conio_line_color+1
  !:
    // conio_cursor_x = 0
    lda #0
    sta.z conio_cursor_x
    // conio_cursor_y++;
    inc.z conio_cursor_y
    // cscroll()
    jsr cscroll
    // }
    rts
}
// Performs division on two 8 bit unsigned chars and an initial remainder
// Returns dividend/divisor.
// The final remainder will be set into the global variable rem8u
// Implemented using simple binary division
// __zp($10) char divr8u(__zp(3) char dividend, char divisor, __zp($f) char rem)
divr8u: {
    .label __1 = $11
    .label rem = $f
    .label dividend = 3
    .label quotient = $10
    .label i = 7
    .label return = $10
    lda #0
    sta.z i
    sta.z quotient
  __b1:
    // rem = rem << 1
    asl.z rem
    // dividend & 0x80
    lda #$80
    and.z dividend
    sta.z __1
    // if( (dividend & 0x80) != 0 )
    beq __b2
    // rem = rem | 1
    lda #1
    ora.z rem
    sta.z rem
  __b2:
    // dividend = dividend << 1
    asl.z dividend
    // quotient = quotient << 1
    asl.z quotient
    // if(rem>=divisor)
    lda.z rem
    cmp #div16u8u.divisor
    bcc __b3
    // quotient++;
    inc.z quotient
    // rem = rem - divisor
    lax.z rem
    axs #div16u8u.divisor
    stx.z rem
  __b3:
    // for( char i : 0..7)
    inc.z i
    lda #8
    cmp.z i
    bne __b1
    // }
    rts
}
// Scroll the entire screen if the cursor is beyond the last line
cscroll: {
    // if(conio_cursor_y==CONIO_HEIGHT)
    lda #$19
    cmp.z conio_cursor_y
    bne __breturn
    // memcpy(CONIO_SCREEN_TEXT, CONIO_SCREEN_TEXT+CONIO_WIDTH, CONIO_BYTES-CONIO_WIDTH)
    lda #<DEFAULT_SCREEN
    sta.z memcpy.destination
    lda #>DEFAULT_SCREEN
    sta.z memcpy.destination+1
    lda #<DEFAULT_SCREEN+$28
    sta.z memcpy.source
    lda #>DEFAULT_SCREEN+$28
    sta.z memcpy.source+1
    jsr memcpy
    // memcpy(CONIO_SCREEN_COLORS, CONIO_SCREEN_COLORS+CONIO_WIDTH, CONIO_BYTES-CONIO_WIDTH)
    lda #<COLORRAM
    sta.z memcpy.destination
    lda #>COLORRAM
    sta.z memcpy.destination+1
    lda #<COLORRAM+$28
    sta.z memcpy.source
    lda #>COLORRAM+$28
    sta.z memcpy.source+1
    jsr memcpy
    // memset(CONIO_SCREEN_TEXT+CONIO_BYTES-CONIO_WIDTH, ' ', CONIO_WIDTH)
    lda #' '
    sta.z memset.c
    lda #<DEFAULT_SCREEN+$19*$28-$28
    sta.z memset.str
    lda #>DEFAULT_SCREEN+$19*$28-$28
    sta.z memset.str+1
    jsr memset
    // memset(CONIO_SCREEN_COLORS+CONIO_BYTES-CONIO_WIDTH, conio_textcolor, CONIO_WIDTH)
    lda.z conio_textcolor
    sta.z memset.c
    lda #<COLORRAM+$19*$28-$28
    sta.z memset.str
    lda #>COLORRAM+$19*$28-$28
    sta.z memset.str+1
    jsr memset
    // conio_line_text -= CONIO_WIDTH
    sec
    lda.z conio_line_text
    sbc #$28
    sta.z conio_line_text
    lda.z conio_line_text+1
    sbc #0
    sta.z conio_line_text+1
    // conio_line_color -= CONIO_WIDTH
    sec
    lda.z conio_line_color
    sbc #$28
    sta.z conio_line_color
    lda.z conio_line_color+1
    sbc #0
    sta.z conio_line_color+1
    // conio_cursor_y--;
    dec.z conio_cursor_y
  __breturn:
    // }
    rts
}
// Copy block of memory (forwards)
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination.
// void * memcpy(__zp($b) void *destination, __zp($d) void *source, unsigned int num)
memcpy: {
    .label src_end = 9
    .label dst = $b
    .label src = $d
    .label source = $d
    .label destination = $b
    // char* src_end = (char*)source+num
    lda.z source
    clc
    adc #<$19*$28-$28
    sta.z src_end
    lda.z source+1
    adc #>$19*$28-$28
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
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// void * memset(__zp($b) void *str, __zp($10) char c, unsigned int num)
memset: {
    .label end = $12
    .label dst = $b
    .label c = $10
    .label str = $b
    // char* end = (char*)str + num
    lda #$28
    clc
    adc.z str
    sta.z end
    lda #0
    adc.z str+1
    sta.z end+1
  __b2:
    // for(char* dst = str; dst!=end; dst++)
    lda.z dst+1
    cmp.z end+1
    bne __b3
    lda.z dst
    cmp.z end
    bne __b3
    // }
    rts
  __b3:
    // *dst = c
    lda.z c
    ldy #0
    sta (dst),y
    // for(char* dst = str; dst!=end; dst++)
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp __b2
}
.segment Data
  // The digits used for numbers
  DIGITS: .text "0123456789abcdef"
  // Values of decimal digits
  RADIX_DECIMAL_VALUES: .word $2710, $3e8, $64, $a
  // [0..65536]    16-bit
  points: .byte 0, 0, 0, 0
  buffer: .byte 0, 0, 0, 0
  // for unexpanded. 37888-4096 color for expanded
  ducknumber: .byte $44, $55, $43, $4b, $3a
  // DUCK:
  chrono: .byte $54, $4d, $3a, $39
  // TM:9
  duck_udg: .byte $e, $1b, $3f, $1f, $f, 7, $f, $1f, 0, 0, 0, 0, 0, $c0, $70, $bc, $1f, $1d, $1e, $f, 3, 1, 1, 3, $ce, $1e, $7c, $f8, $e0, $40, $40, $e0, 0, 0, 0, 0, 0, 0, 0, 0
  // POKE CODES = 0,1,2,3,4; CHROUT CODES = 64, 65, 66, 67, 68 (with previous reverse_off "chrout(146)")
  intro: .text @"\n\n\nDIFFICULTY\n----------\n\n\n"
  .byte 0
  levels: .text @"1.EASIEST\n\n3.EASY\n\n5.MEDIUM\n\n7.HARD\n\n9.EXPERT\n\n\n\n\n"
  .byte 0
  foot: .text @"PRESS: 1,3,5,7 or 9\n\n"
  .byte 0
  game_over: .text @"\n\n\n\nGAME OVER"
  .byte 0
  play_again: .text @"\n\n\nPlay Again (Y/N)?"
  .byte 0
  your_score: .text @"\n\n\nYour Score: "
  .byte 0
  high_score: .text @"\n\nHi-Score: "
  .byte 0

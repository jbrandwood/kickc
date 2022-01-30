#include <stdio.h>
#include <peekpoke.h>
#include <stdlib.h>
#include <division.h>

unsigned byte j,k,l,m,n=0;  // [0..255] 8-bit
unsigned short tu,duck,peephole,y,z,time,score,hiscore=0; // [0..65536]    16-bit
unsigned byte points[]={0,0,0,0};
unsigned byte buffer[]={0,0,0,0};

const unsigned byte down=17,right=29,lock=8,lower=14;
const unsigned byte home=19,reverse_on=18,brick=230;
const unsigned byte green=30,yellow=158,red=28;
const unsigned short c=30720;  // for unexpanded. 37888-4096 color for expanded
const unsigned byte ducknumber[]={68,85,67,75,58}; // DUCK:
const unsigned byte chrono[]={84,77,58,57}; // TM:9
const unsigned byte duck_udg[]={14,27,63,31,15,7,15,31,0,0,0,0,0,192,112,188,31,29,30,15,3,1,1,3,206,30,124,248,224,64,64,224,0,0,0,0,0,0,0,0};
// POKE CODES = 0,1,2,3,4; CHROUT CODES = 64, 65, 66, 67, 68 (with previous reverse_off "chrout(146)")
const unsigned byte intro[]="\n\n\nDIFFICULTY\n----------\n\n\n";
const unsigned byte levels[]="1.EASIEST\n\n3.EASY\n\n5.MEDIUM\n\n7.HARD\n\n9.EXPERT\n\n\n\n\n";
const unsigned byte foot[]="PRESS: 1,3,5,7 or 9\n\n";
const unsigned byte game_over[]="\n\n\n\nGAME OVER";
const unsigned byte play_again[]="\n\n\nPlay Again (Y/N)?";
const unsigned byte your_score[]="\n\n\nYour Score: ";
const unsigned byte high_score[]="\n\nHi-Score: ";

void clear_screen(byte n, byte m)
{ for (z=0; z<506; ++z) { POKE(7680+z+c,m); POKE(7680+z,n); } // From 0-->505 (506 bytes). ClearScreen with byte 'n' with color 'm'
 gotoxy(0,0); chrout(home); }  // Return to home position

void random(byte k, byte n) // Random { k..n }
{ do { m=PEEK(37140); }
  while (m<k || m>n); }

void chrout(volatile char petscii)
    { asm { lda petscii jsr $ffd2 }}

void write_score(void) {
  if (score>65000) score=0;
  for (m=0;m<4;m++) { points[m]='0'; } // (!!) Needed. Possibly a bug
  utoa(score,buffer,10);
  if (score>9) { points[2]=buffer[0];points[3]=buffer[1]; }
  if (score>99) { points[1]=buffer[0];points[2]=buffer[1];points[3]=buffer[2]; }
  chrout(yellow);chrout(home);POKE(211,4);
  for (m=0;m<4;m++) { chrout(points[m]); }
}

void wait(byte n)
{ for (m=0;m<n;++m) { for (z=0;z<540;++z) {}; } }

void chrono_restart(void)
{ asm {
	lda #0
	ldy #0
	ldx #0
	jsr $ffdb }; }

void read_chrono(void) // time (in seconds)
{ asm {
	jsr $ffde
	sta l
	stx m
	};
time=div16u8u((m*256)+l,60);
POKE (7701+c,7); POKE(7701,185);
if (time<10) POKE(7701,185-time); // if chrono<10 write time, otherwise write '9'. it avoids '/' symbol. Yellow
}

void main()
{
 POKE(36879,8); // border and black paper
 chrout(lock); //Lock UpperCase to Lowercase key
 chrout(lower); //Put text in Lowercase set
 for (m=0; m<40; m++) POKE(7168+m,duck_udg[m]);  // Load udgs. From 0-->39;
 do {
	 clear_screen(32,0); // Clear Screen with spaces & black ink
	 textcolor(7); cputs(intro); // Yellow ink
     textcolor(1); cputs(levels); // White
     textcolor(2); cputs(foot); // Red
     do { l=PEEK(197); ++l; } while (l>5);  // wait for 1-3-5-7-9 keys only
     clear_screen(4,0); // with (4=duser defined). Black ink
     POKE(36869,255); // Graphic mode
     chrout(reverse_on);chrout(red);chrout(down);
     //for (z=1;z<23;z++) { POKE(7680+z*22,230);POKE(c+7680+z*22,2); POKE(7679+z*22,230); POKE(c+7679+z*22,2); }   // 23 rows * 22 columns (7680 to 8185). 506 positions.
     //k=1; do { chrout(brick); POKE(211,20); chrout(brick);  ++k; } while (k<23);
     //for (k=1;k<22;k++) { chrout(brick); POKE(211,22); chrout(brick); }; // 23 rows * 22 columns (7680 to 8185). 506 positions.
     for (k=1;k<22;k++) { chrout(brick); for(n=2;n<22;++n) { chrout(right); }; chrout(brick); }; // 23 rows * 22 columns (7680 to 8185). 506 positions.
     chrout(brick); // first brick from last line (#23)
     POKE(8185,brick);POKE(8185+c,2); //last brick from last line (#23) to avoid scrolling
     chrout(home); z=1;  // First position
     if (l>1) {
	           do {  // Write differential random bricks depending on 'l' level choosen
	 	 	       random((7-l),26-(3*l));  // Random number is 'm' (interleaves are level-dependent)
	  	 	       if (z+m>505) break;
	  		       for (j=1; j<=m; ++j) chrout(right);
	  		       chrout(brick); z=z+m+1; }
			   while (z<506);
			  }
   	 peephole=7967; // Initial peephole position
   	 POKE(36878,15); // Volume to max
   	 score=0;
   	 tu=1; // Duck #1
   	 chrout(home);chrout(yellow);chrout(80);chrout(84);chrout(83);chrout(58);  // Write 'PTS:', yellow
   	 POKE(211,18); // jump to Column 18
   	 for (j=0; j<4; ++j) { chrout(chrono[j]); }; // Write 'TM:9', yellow
   	 write_score(); // Write Score (yellow)
   	 chrout(home);chrout(green);POKE(211,10); // Jump to column 10
   	 for (j=0; j<5; j++) { chrout(ducknumber[j]); }; // Write 'DUCK', green
   	 do {
   	      chrout(home);chrout(green);chrout(reverse_on);
   	      POKE(211,15); // Jump to column 15
   	      if (tu<10) { chrout(48+tu) }; else { chrout(49);chrout(48); } // Write duck number
   	      do { random(0,255); duck=m; random(0,255); duck=m+7701+duck; } // Choose randon Duck position (in 2 parts random+random)
   	      while ((duck>8163) || PEEK(duck)==brick || PEEK(duck+1)==brick || PEEK(duck+22)==brick || PEEK(duck+23)==brick);
          time=0;chrono_restart();
   	      while (time<10) // ...until 10 seconds
            { read_chrono();
	          // Joystick routine
	          m=PEEK(37151); POKE(37154,127);
    		  n=PEEK(37152); POKE(37154,255);
			  if ((16&m)==0) y--; // Left
       		  if ((128&n)==0) y++; // Right
    		  if ((4&m)==0) y=y-22; // Up
    		  if ((8&m)==0) y=y+22; // Down
    	      if ((32&m)==0)        // FIRE!!
    	         { POKE(36877,130);
	    	 	   if (peephole!=duck) { score=score-10; write_score(); wait(10); }	 // We hit the duck!
	    	 	   else			   { score=score+(12-time)*10; wait(10);time=10; }  // We fail!
		    	   POKE(36877,0); // Stop sounds
		    	 }
    		  if (PEEK(y)!=brick && PEEK(y+1)!=brick && PEEK(y+22)!=brick && PEEK(y+23)!=brick && y>7702 && y<8163)
        	  	 { POKE(peephole+c,0); POKE(peephole+c+1,0); POKE(peephole+c+22,0); POKE(peephole+c+23,0); peephole=y; } // Check if peephole touches some bricks
			  y=peephole;
    		  POKE(peephole,253);POKE(peephole+c,1);POKE(peephole+1,237);POKE(peephole+1+c,1);
   			  POKE(peephole+22,238);POKE(peephole+22+c,1);POKE(peephole+23,240);POKE(peephole+23+c,1); // Clear peephole if there is not bricks contact
   		      wait(5);
   		      POKE(duck,0);POKE(duck+c,7);POKE(duck+1,1);POKE(duck+1+c,7); // Draw duck (udg)
   	          POKE(duck+22,2);POKE(duck+22+c,7);POKE(duck+23,3);POKE(duck+23+c,7);
   		      wait(5);
   		    }
   		 tu++; // Next duck
   		 score=score-10;write_score(); // Substract 10 points if time finishes
 		 POKE(36877,130);wait(20);POKE(36877,0);  // Make some noise
   		 POKE(duck+c,0); POKE(duck+1+c,0); POKE(duck+22+c,0); POKE(duck+23+c,0); // Clear previous duck draw
        }
     while (tu<11); // 10 ducks
     clear_screen(4,0); // Clear screen with user-defined spaces & black ink
     POKE(36869,240);chrout(lower); // Return to text mode, lowcase
     textcolor(7); cputs(game_over); // Yellow
     textcolor(2); cputs(your_score); cputs(buffer); // Red
     textcolor(3); cputs(high_score); if (score>hiscore) hiscore=score; utoa(hiscore,buffer,10); cputs(buffer); // Cyan
     textcolor(1); cputs(play_again); // white
     do { j=PEEK(197); } while (j!= 11 && j!=28 ); // Wait for Y or N
    } // Y pressed --> start again
while (j==11); // N pressed. Exit game
asm {jsr $FD22};  // Reset the VIC.
}
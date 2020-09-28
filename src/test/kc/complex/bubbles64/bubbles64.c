// bubbles64 - Q&D C64 port of the bubbles demo from vbcc6502's NES exmaples
// Coded by Lazycow
// Source https://www.lemon64.com/forum/viewtopic.php?t=75283&start=15

#include "lazyply.h"

#define scrPtr (( ubyte*)0xE000)
#define colPtr (( ubyte*)0xD800)
#define vicPtr (( ubyte*)0xD000)
#define chrPtr (( ubyte*)0xF800)
#define onePtr (( ubyte*)0x0001)
#define scr 0xE000

enum {
	maxSprites=32,
	maxSprImages=8,
	maxC64Images=256,
	sprOff=64
};

ubyte
	lcSprMapTab[maxSprImages],
	lcSprColTab[maxC64Images];

enum {
	maxDrawObjects=24,
	F=3
};
ubyte cmIT[maxSprites+1],
	cmSI[maxSprites], cmRX[maxSprites], cmRY[maxSprites], cmRF[maxSprites];


typedef struct {
	ubyte
		s; // sprite image offset into bubbles[] table
	sword
		x, y; // coordinates (shifted)
	sbyte
		vx, vy,  // velocity
		ax, ay; // accelleration
} DrawObject;

DrawObject dTab[maxDrawObjects];

void Print00(char* p, ubyte v0) {
	char c;  ubyte v=v0;
	c='0';  while (v>=10) { ++c;  v-=10; }
	*p++=c;
	c='0';  while (v>=1) { ++c;  v-=1; }
	*p++=c;
}

 // sprite support functions
//
ubyte GetSprite() { // get unused or dropped sprite
	ubyte t0;  for (t0=0;t0<maxSprites;++t0) if (cmRF[t0]>=rfDrop)
		{ cmRF[t0]=0;  return t0; }
	return 255;
}
void AddSprite(ubyte sn) { // activate prepared sprite into the (i)ndex (t)able
	ubyte t0;  if (rfDrop==cmRF[sn]) cmRF[sn]=0; else for
		(t0=0;t0<maxSprites;t0+=1) if (cmIT[t0]>=128)
		{ cmRF[sn]=0;  cmIT[t0]=sn;  return; }
}
void DelSprite(ubyte sn) { // drop sprite, will be removed from IT in IRQ
	cmRY[sn]=255;  cmRF[sn]=rfDrop;
}

 //
//
int main() {

	register DrawObject* d;

	ubyte
		i,
		type=0,
		stopIt=0,
		objects=0,
		preset=0; // 1 == preallocate 20 sprites (only for better benchmarking)
		         //  0 == allocate sprites on the fly (prefered)
	uword
		oCount=0,
		c=0;

	// setup sprite images
	lcSprMapTab[0]=sprOff+0;  lcSprMapTab[1]=sprOff+1;
	lcSprMapTab[2]=sprOff+2;  lcSprMapTab[3]=sprOff+3;
	lcSprMapTab[4]=sprOff+4;  lcSprMapTab[5]=sprOff+5;
	// setup sprite colors + flags
	lcSprColTab[sprOff+0]=lcSprColTab[sprOff+1]=10|lfMC;
	lcSprColTab[sprOff+2]=lcSprColTab[sprOff+3]=5|lfMC;
	lcSprColTab[sprOff+4]=lcSprColTab[sprOff+5]=14|lfMC;

	// setup C64 / lazyply
	lcVIC17=vicPtr[17];  lcVIC22=vicPtr[22];  lcVIC24=vicPtr[24];
	lcVIC33=6;  lcVIC37=1;  lcVIC38=11;
	for (i=0;i<maxSprites+1;i+=1) cmIT[i]=255; // clear (i)ndex (t)able
	for (i=0;i<maxSprites  ;i+=1) cmRF[i]=255;
	for (c=0;c<1000;c+=1) { scrPtr[c]=32;  colPtr[c]=14; }
	i=lcSync(0); // install IRQ
	*onePtr=0x33; // now it's save to change "01"
	for (c=0;c<2040;c+=1) chrPtr[c]=vicPtr[c];
	*onePtr=0x35;
	vicPtr[0xd02]|=3;  vicPtr[0xd00]&=~3ub;  lcVIC24=128+14;

	// PAL or NTSC?
	if (i&128) {
		scrPtr[996]='N'-'A'+1;  scrPtr[997]='T'-'A'+1;  scrPtr[998]='S'-'A'+1;
		scrPtr[999]='C'-'A'+1;
	} else {
		scrPtr[997]='P'-'A'+1;  scrPtr[998]='A'-'A'+1;  scrPtr[999]='L'-'A'+1;
	}
	scrPtr[975+0]='B'-'A'+1;
	scrPtr[975+1]='U'-'A'+1;
	scrPtr[975+2]='B'-'A'+1;
	scrPtr[975+3]='B'-'A'+1;
	scrPtr[975+4]='L'-'A'+1;
	scrPtr[975+5]='E'-'A'+1;
	scrPtr[975+6]='S'-'A'+1;
	scrPtr[975+7]=':';

	// setup bubbles
	type=0;
	for (i=0;i<maxDrawObjects;i+=1) {
		DrawObject* d=&dTab[i];
		d->s=type;
		type+=1;  if (type>=6) type=0;
		d->x=112<<F;  d->vx=(sbyte)i;  d->ax=1;
		d->y=24<<F;  d->vy=1<<F;  d->ay=1;

		if (preset && i<20) {
			if ((c=GetSprite())<128) {
				AddSprite((ubyte)c);
				cmSI[i]=cmRX[i]=cmRF[i]=0;
				cmRY[i]=i<<4;
			}
		}
	}

	// main loop
	c=0;  for (;;) {

		// move objects
		for (i=0,d=dTab; i<objects ;i+=1,++d) {
			d->vx+=d->ax;
			if (d->vx<-32) d->ax=1; else if (d->vx>32) d->ax=-1;
			if (d->y>248<<F) d->vy=-1<<F; else if (d->y<24<<F) d->vy=1<<F;
			d->x+=d->vx;  d->y+=d->vy;
			if (cmRF[i]<128) { cmSI[i]=d->s;  cmRX[i]=(ubyte)(d->x>>F);  cmRY[i]=(ubyte)(d->y>>F); }
		}

		// activate new bubble?
		c+=1;  if (c>=14) {
			c=0;
			if (0==stopIt && objects<maxDrawObjects) {
				objects+=1;
				if (0==preset && (i=GetSprite())<128) {
					AddSprite(i);
					cmSI[i]=cmRX[i]=cmRF[i]=cmRY[i]=0;
				}
			}
		}

		i=lcSync(0)&31;
		if (i>1) oCount+=2; else if (oCount>0) oCount-=1;
		if (oCount>2 && objects>0) // stop adding objects?
			{ objects-=1;  DelSprite(objects);  stopIt=1;  oCount=0; }
		Print00(scr+(char*)983,objects);
	}
	return 0;
}

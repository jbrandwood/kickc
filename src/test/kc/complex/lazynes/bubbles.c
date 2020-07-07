// lazyNES bubbles demo
  // lazyNES - As lazy as possible NES hardware support library for vbcc6502
 // (happily cooperates with Shiru's famitone2 replay code)
// V1.0, 'Lazycow 2020

// Ported to KickC 2020 by Jesper Gravgaard 
// Original Source VBCC alpha 2 http://www.ibaug.de/vbcc/vbcc6502_2.zip

#pragma target(nes)
#include "lazynes.h"

enum {
	F=3, // pseudo floating point shift value
	maxDrawObjects=40,
	dfAlive=1
};


typedef struct {
	ubyte
		f,  // flags
		s; // sprite image offset into bubbles[] table
	sword
		x, y; // coordinates (shifted)
	sbyte
		vx, vy,  // velocity
		ax, ay; // accelleration
} DrawObject;


DrawObject dTab[maxDrawObjects];


 // print some text in the static area
//
void Print(uword offset, ubyte value) {
	static ubyte b[]={0,0,10,'B','U','B','B','L','E','S',':',0,0,lfEnd};
	b[0]=(offset>>8)|lfHor;  b[1]=offset&255;  b[11]=b[12]='0';
	while (value>=10) { ++b[11];  value-=10; }
	while (value>=1)  { ++b[12];  value-=1; }
	lnList(b);
}


 //
//
int lnMain() {

	static const ubyte bgColors[]={45,33,2};
	static const ubyte bubblesPal[]={ 0, 37,22,5, 0, 42,26,10, 0, 33,18,3 };
	static const ubyte bubbles[]={ // x-offset, y-offset, tile, palette+flags
		0,0,7,0,  8,0,9,0,  128, // 16x16, red,   offset 0
		0,0,7,1,  8,0,9,1,  128, // 16x16, green, offset 9
		0,0,7,2,  8,0,9,2,  128, // 16x16, blue,  offest 18
		0,4,11,0,128, // 8x8, red,   offset 27 
		0,4,11,1,128, // 8x8, green, offset 32
		0,4,11,2,128, // 8x8, blue,  offset 37
	},
	bubbleTab[]={0,27,9,32,18,37}; // start offsets in bubbles[]

	ubyte
		i,
		type=0,
		stopIt=0,
		objects=0;
	uword
		hScroll=0,
		tics=0;
	sbyte
		hVel=0, hDir=1;

	lnSync(lfBlank); // blank screen to enable lnPush() usage
	lnPush(lnBackCol,3,bgColors); // set background colors
	lnPush(lnSprPal0,3,&bubblesPal[1]); // set sprite colors
	lnPush(lnSprPal1,3,&bubblesPal[5]);
	lnPush(lnSprPal2,3,&bubblesPal[9]);
	lnPPUCTRL|=32; // Select 8x16 sprites; has to be set after calling lnSync()!
	
	   // draw some backgrounds
	{ //
		static const ubyte g1[]={1}, g2[]={2,3,4,5}, g3[]={6,7,8,9};
		ubyte x;
		// draw a line: Sprite #0 will be placed ontop later to trigger the split
		i=2;  for (x=0;x<32;x+=1) lnPush(lnNameTab0+(i<<5)+x,1,g1);
		// draw some diamond shapes
		for (i=8;i<=24;i+=4) for (x=0;x<4;x+=1) {
			lnPush(lnNameTab0+(i<<5)+12+x*4,4,g2);
			lnPush(lnNameTab0+32+(i<<5)+12+x*4,4,g3);
		}
	}

	// setup bubbles
	type=0;
	for (i=0;i<maxDrawObjects;i+=1) {
		DrawObject* d=&dTab[i];
		d->f=dfAlive;
		d->s=bubbleTab[type];
		type+=1;  if (type>=6) type=0;
		d->x=80<<F;  d->vx=i;  d->ax=1;
		d->y=24<<F;  d->vy=1<<F;  d->ay=1;
	}

	while(1) {
		DrawObject* d;

		lnScroll(0,0); // reset scrolling offsets of area above split
		lnScroll(hScroll>>6,32); // set scrolling offsets of area below split
		hVel+=hDir;  if (hVel>64 || hVel<-64) hDir=-hDir;
		hScroll+=hVel;
		
		 // add 1st sprite (SPR0) at a fixed position on top of background blocks
		// mandatory for the SPR0HIT check later with lnSync(lfSplit)
		lnAddSpr(&bubbles[bubbleTab[5]],16,16);
		lnSpr0Wait=55; // delay the set of scrolling registers a bit

		// move bubbles
		for (i=0,d=dTab; i<objects ;i+=1,++d) if (d->f&dfAlive) {			
			d->vx+=d->ax;
			if (d->vx<-32) d->ax=1; else if (d->vx>32) d->ax=-1;
			if (d->y>216<<F) d->vy=-1<<F; else if (d->y<24<<F) d->vy=1<<F;					
			d->x+=d->vx;
			d->y+=d->vy;
			lnAddSpr(&bubbles[d->s],d->x>>F,d->y>>F);
		}
		
		// activate new bubble?
		tics+=1;  if (tics>8) {
			tics=0;
			if (0==stopIt && objects<maxDrawObjects) objects+=1;
		}

		// display the amount of moving bubbles + spr0-bubble
		Print(lnNameTab0+32,objects+1);
		
		i=lnSync(lfSplit)&31; // sync with vblank, activate SPR0HIT splitscreen
		
		   // lnSync() returns the number of vblank NMI's that have been triggered
		  // since the last call of lnSync(). If the program code is too slow to
		 // move all objects in one frame (i>1), then we reduce the amount of
		// objects (objects-=1) and everything moves with 60 fps again.
		if (i>1 && objects>0) { objects-=1;  stopIt=1; } // stop adding objects?
	}

	return 0;
}

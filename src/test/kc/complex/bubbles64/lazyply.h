// lazyply - experimental C64 sprite multiplying code, 'Lazycow 2015 (prealpha)

typedef signed char sbyte;
typedef unsigned char ubyte;
typedef signed short sword;
typedef unsigned short uword;

  //
 // sprites
//

enum {
	lfMC=16, // sprite is multicolor
	lfOL=32 // sprite is build out of 2 overlayed sprites (hires over multicolor)
};

extern ubyte lcSprMapTab[];
extern ubyte lcSprColTab[];

enum { rfXMSB=16, rfDrop=254, rfNull=255 };

//enum {
	//scNull=255, // unallocated (63)
	//scDrop=254, // will be removed (62)
	//scHide=253, // invisible (61)
	//scVoid=128, // no collision detection
	//scHold=64, // sprite holds on sprite cmSC[]&scMask, offset cmSU[]/cmSV[]
	//scMask=63
//};

extern ubyte
	cmIT[],   // sprite index table (dim must be maxSprites+1!)
	cmSI[],  // sprite image
	//cmSC[], // sprite control
	cmRX[],   // raw sprite x coordinates (bits 0..7)
	cmRY[],  // raw sprite y coordinates (bits 0..7)
	cmRF[]; // raw sprite flags: 1 == bit 8 of raw x coordinate

  //
 // raster interrupt
//

ubyte lcVIC17, lcVIC22, lcVIC24, lcVIC33, lcVIC37, lcVIC38;

#if defined(__CC65__)

ubyte fastcall lcSync(ubyte flags);
ubyte fastcall lcGetPad(ubyte port);
	enum { lfU=1, lfD=2, lfL=4, lfR=8, lfA=16, lfB=32 };

#elif defined(__VBCC__)

  // flags: 0
 // result: amount of frames since the last call [0..31], +128 on NTSC
//
ubyte lcSync(__reg("a") ubyte flags);

  // port: 0==query both ports (other values not supported, yet)
 // result: set of joypad flags
//
ubyte lcGetPad(__reg("a") ubyte port);
	enum { lfU=1, lfD=2, lfL=4, lfR=8, lfA=16, lfB=32 };

#elif defined(__KICKC__)

  // flags: 0
 // result: amount of frames since the last call [0..31], +128 on NTSC
//
ubyte lcSync(ubyte flags) { return 0; }

  // port: 0==query both ports (other values not supported, yet)
 // result: set of joypad flags
//
ubyte lcGetPad(ubyte port) { return 0; }

enum { lfU=1, lfD=2, lfL=4, lfR=8, lfA=16, lfB=32 };

#endif

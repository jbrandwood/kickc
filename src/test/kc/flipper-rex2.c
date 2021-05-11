byte buffer1[16*16];
byte buffer2[16*16];
byte *RASTER = (byte*)$d012;
byte* SCREEN = (byte*)$0400;

void main() {
  prepare();
  do {
    for( byte c : 25..1) {
      do { } while(*RASTER!=254);
      do { } while(*RASTER!=255);
    }
    flip();
    plot();
  } while(true);
}

// Prepare buffer
void prepare() {
   for( byte i : 0..255) {
      buffer1[i] = i;
   }
}

// Flip buffer
void flip() {
   byte srcIdx = 0;
   byte dstIdx = 15;
   for( byte r : 16..1) {
      for( byte c : 16..1) {
         buffer2[dstIdx] = buffer1[srcIdx++];
         dstIdx = dstIdx+16;
      }
      dstIdx--;
     }
   for(byte i : 0..255) {
      buffer1[i] = buffer2[i];
   }
}

// Plot buffer on screen
void plot() {
   byte* line = SCREEN+5*40+12;
   byte i=0;
   for(byte y : 16..1) {
     for(byte x=0; x<16; x++ ) {
       line[x] = buffer1[i++];
     }
     line = line+40;
   }
}
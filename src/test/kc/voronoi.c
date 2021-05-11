// The screen
byte *SCREEN = (byte*)$400;
byte *COLORS = (byte*)$D800;

byte FILL = 230;

// The total number of voronoi points
byte numpoints = 6;

// Points to create the Voronoi from
byte XPOS[] = {5, 15, 6, 34, 21 ,31};
byte YPOS[] = {5, 8, 14, 2, 17, 22};
byte COLS[] = {1, 2, 3, 4, 5, 7};

void main() {
  initscreen();
  do {
    render();
    animate();
  } while(true);
}

void animate() {
    XPOS[0] = XPOS[0]+1;
    if(XPOS[0]==40) {
      XPOS[0] = 0;
    }
    YPOS[0] = YPOS[0]+1;
    if(YPOS[0]==25) {
      YPOS[0] = 0;
    }
    XPOS[1] = XPOS[1]-1;
    if(XPOS[1]==255) {
      XPOS[1] = 40;
    }
    YPOS[2] = YPOS[2]+1;
    if(YPOS[2]==25) {
      YPOS[2] = 0;
    }
    YPOS[3] = YPOS[3]-1;
    if(YPOS[3]==255) {
      YPOS[3] = 25;
      XPOS[3] = XPOS[3]+7;
      if(XPOS[3]>=40) {
        XPOS[3] = XPOS[3]-40;
      }
    }
}

void initscreen() {
  for( byte* screen = SCREEN; screen<SCREEN+$03e8; ++screen) {
    *screen = FILL;
  }
}

void render() {
  byte* colline = COLORS;
  for( byte y : 0.. 24) {
    for( byte x : 0..39) {
      byte col = findcol(x, y);
      colline[x] = col;
    }
    colline = colline+40;
  }
}

byte findcol(byte x, byte y) {
  byte mindiff = 255;
  byte mincol = 0;
  for( byte i=0; i<numpoints; ++i) {
     byte xp = XPOS[i];
     byte yp = YPOS[i];
     if(x==xp) {
       if(y==yp) {
         return 0;
       }
     }
     byte diff;
     if(x<xp) {
       diff = xp-x;
     } else {
       diff = x-xp;
     }
     if(y<yp) {
       diff = diff + (yp-y);
     } else {
       diff = diff + (y-yp);
     }
     if(diff<mindiff) {
       mindiff=diff;
       mincol = COLS[i];
     }
  }
  return mincol;
}



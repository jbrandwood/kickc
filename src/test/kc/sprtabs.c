byte sprX[12] = $1100;
byte sprY[21] = $1110;

byte i=0;
do {
  sprX[i] = i/4;
  i = i+1;
} while (i<12)

i=0;
byte v=0;
do {
  sprY[i] = v;
  v = v+3;
  i = i+1;
} while (i<21)


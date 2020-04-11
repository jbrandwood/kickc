// Example of structs that can be optimized by going planar
// https://cc65.github.io/mailarchive/2010-09/8593.html?fbclid=IwAR1IF_cTdyWcFeKU93VfL2Un1EuLjkGh7O7dQ4EVj4kpJzJAj01dbmEFQt8

unsigned char OFFSET = 10;
unsigned char XSPACE = 20;
unsigned char YSPACE = 20;

struct pos {
  unsigned char x;
  unsigned char y;
};

struct pos p[64];

unsigned char idx,line,row,x,y;

void main(void)
{
  for (line=0;line<8;++line)
  {
    ++x;
    for (row=0;row<8;++row)
    {
      p[idx].y=y;
      p[idx].x=x;
      ++idx;
      x+=XSPACE;
    }
    y+=YSPACE;
  }
}
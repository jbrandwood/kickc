### Line Buffer

Used for rendering lines into. Organized with linear addressed columns of 8 bits, allowing the line routine to addess the y-coordinate using X/Y-addressing.

### Screen Buffer

Used for filling & showing to the user. There are 2 screen buffers allowing for double buffering. 
Memory organization is  be adapted to the specific display. This means the same line routines can be used for charsets, bitmaps, sprites etc. 

### Algorithm

1. Move points
2. Clear line buffer 
3. Render lines into line buffer
4. Wait for screen buffer being available for rendering (mostly instant)
5. EOR-fill from line buffer into screen buffer
6. Mark screen buffer for showing, swap screen buffer

### Line Drawing

Optimized line drawing routines for the 8 different cases. (xd positive/negative, yd , xd-yd positive/negative)

- Lines are organized in a clockwise fashion ensuring that xd positive means the fill starts and xd negative means the fill ends.
- xd positive (start fill): steep slope lines render the top-most pixel, flat slope lines render the actual pixel.
- xd negative (stop fill): steep slope lines render the pixel below bottom-most pixel, flat slope lines render below the actual pixel.
- unrolled line routines with code for each individual x-pixel position can plot lines quite fast
- unrolled line routines can be called by writing an RTS at code of the stop x-position and JSR'ing into the code for the start X-position. 
- The RTS must be fixed again after return.

### EOR filling

Unrolled EOR-filler from the line buffer. The screen buffer does not need to be cleared because the filler always fills all bytes.

### Effective Canvas Shape

Both the line canvas and screen canvas can benefit from identifying the effective canvas shape where an object can be rendered.
For instance a freely 3D-rotated object may only occupy a circular shaped canvas.
By only clearing & filling this effective canvas these time consuming routines arebecome faster.

It might also be worth dynamically detecting the canvas shape for each rendered frame - to allow even faster clear/fill. 
This will require an efficient way of identifying min/max y-value in for each column that consumes less time than the time saved by not clearing/filling.  

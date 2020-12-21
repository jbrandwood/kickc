
byte* BORDER_COLOR = $d020;
byte* RASTER = $d012;
byte DARK_GREY = $b;
byte BLACK = 0;
void()** const  KERNEL_IRQ = $0314;


void main() {
    *KERNEL_IRQ = &irq;
}

volatile byte irq_raster_next = 0;

__interrupt(hardware_clobber) void irq() {
    *BORDER_COLOR = DARK_GREY;
 	irq_raster_next += 21;
    // Setup next interrupt
    byte raster_next = irq_raster_next;
    if((raster_next&7)==0) {
    	raster_next -=1;
    }
    *RASTER = raster_next;
    *BORDER_COLOR = BLACK;
}
// Pointer to pointer to procedure without typedef (uses a very complex cast)

// Define const pointer to pointer to no-arg-noreturn procedure
void (** const IRQ)(void) = (void(**)(void))0x314;

char * const SCREEN = (char*)0x0400;

__interrupt void irq() {
    SCREEN[0]++;
}

void main() {
    *IRQ = &irq;
}

// Pointer to pointer to procedure - using typedef

// Typedef a pointer to a procedure returning void, taking no parameters
typedef void (*IRQ_TYPE)(void);

// Use typedef to define const pointer to pointer to no-arg-noreturn procedure
IRQ_TYPE * const IRQ = (IRQ_TYPE*)0x314;

char * const SCREEN = (char*)0x0400;

__interrupt void irq() {
    SCREEN[0]++;
}

void main() {
    *IRQ = &irq;
}

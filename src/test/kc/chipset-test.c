// Test ATARI chipset variations
// Pointer to struct versus MAcro pointer to struct

// CC65 macro pointer to struct

struct __pia {
    unsigned char   porta;  /* port A data r/w */
    unsigned char   portb;  /* port B data r/w */
    unsigned char   pactl;  /* port A control */
    unsigned char   pbctl;  /* port B control */
};

struct ATARI_PIA {
    unsigned char PORTA;  /* port A data r/w */
    unsigned char PORTB;  /* port B data r/w */
    unsigned char PACTL;  /* port A control */
    unsigned char PBCTL;  /* port B control */
};

#define PIA1 (*(struct __pia*)0xD300)

struct ATARI_PIA * const PIA2 = (struct ATARI_PIA *)0xD300;


void main() {
    PIA1.porta = 7;
    PIA2->PORTA = 7;    
}
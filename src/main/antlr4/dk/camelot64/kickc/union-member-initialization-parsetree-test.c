struct M {
     unsigned int flight;
     signed char turn;
     unsigned char speed;
};

struct T {
     signed char turn;
     unsigned char radius;
     unsigned char speed;
};

struct E {
     unsigned char explode;
};

union A {
    struct M move;
    struct T turn;
    struct E end;
};

struct F {
    union A action;
    unsigned char type;
    unsigned char next;
};


struct F action_flightpath_001[] = {
    { .move={ action_move_00 },    STAGE_ACTION_MOVE,        1 },
    { { action_end } ,        STAGE_ACTION_END,         0 }
};


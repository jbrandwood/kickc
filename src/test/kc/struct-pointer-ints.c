// Demonstrates missing fragment _deref_pwuc1=_deref_pwuc1_plus_vwuc2
// https://gitlab.com/camelot/kickc/-/issues/435 reported by G.B.

typedef struct myStruct
{
    unsigned int a, b;
} myStruct;

void update(myStruct *s, unsigned int size)
{
    s->a += size;
}

int main(void)
{
    myStruct s;
    update(&s, 1000);
    return 0;
}

// Range-loop without loop variable declaration causes NPE
// https://gitlab.com/camelot/kickc/-/issues/333

char * line = 0x0400;

void main() {
    clear_line(line);
    clear_line(line+40);
}

void clear_line(byte *line) {
    for (i: 0..39)
        line[i] = 0;
}

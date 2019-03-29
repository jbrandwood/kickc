void main()
{
    byte* screen = $400;
    word line;
    for (line = 0; line < 40*24; line += 40) {
        for (byte c=0; c<40; ++c)
            screen[line+c] = screen[line+c+40];
    }

    // Cleare the bottom line
    for (byte c=0; c<40; ++c)
        screen[line+c] = ' ';
}

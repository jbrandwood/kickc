// Re-create problem where removing empty method can cause NPE (because a local variable in the method is still used)
struct line_t {
  char buf[10];
  char pos;
};

struct line_t lines[10];

char *lined_line(struct line_t *l) {
  return (l->buf);
}

void main() {
    struct line_t* line = lines;
    for(char i=0;i<10;i++) {
        char* buf = lined_line(line);
        *buf = 'a';
        line++;
    }
}

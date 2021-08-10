// Failing number type resolving in ternary operator
// Currently fails in the ternary operator with number-issues if integer literal is not specified!
  // Commodore 64 PRG executable file
.file [name="number-ternary-fail-2.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  // Top of the heap used by malloc()
  .label HEAP_TOP = $a000
.segment Code
main: {
    .label width = $12*2+3
    .label height = 6*2+3
    .label maze = malloc.return
    // malloc(width * height)
    jsr malloc
    // SolveMaze(maze, width, height)
    jsr SolveMaze
    // asm
  loop:
    jmp loop
    // }
}
// Allocates a block of size chars of memory, returning a pointer to the beginning of the block.
// The content of the newly allocated block of memory is not initialized, remaining with indeterminate values.
// void * malloc(unsigned int size)
malloc: {
    .const size = main.width*main.height
    .label mem = HEAP_TOP-size
    .label return = mem
    rts
}
// void SolveMaze(char *maze, unsigned int width, unsigned int height)
SolveMaze: {
    .const x = 3
    .const y = 2
    .label forward = 2
    lda #<0
    sta.z forward
    sta.z forward+1
  __b2:
    // forward ? 2 : 3
    lda.z forward
    ora.z forward+1
    bne __b3
    lda #3
    jmp __b4
  __b3:
    // forward ? 2 : 3
    lda #2
  __b4:
    // maze[y * width + x] = forward ? 2 : 3
    sta main.maze+y*main.width+x
    lda #<1
    sta.z forward
    lda #>1
    sta.z forward+1
    jmp __b2
}

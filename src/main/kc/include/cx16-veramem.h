// Implements functions for static and dynamic memory management for VERA VRAM memory.

const byte VERA_HEAP_STATIC = 0;
const byte VERA_HEAP_DYNAMIC = 1;

struct vera_heap {
    word address;
    word size;
    struct vera_heap *next;
    struct vera_heap *prev;
};

struct vera_heap_segment {
    dword size;
    dword ceil_address;
    dword next_address;
    dword base_address;
    struct vera_heap *head_block;
    struct vera_heap *tail_block; 
    struct vera_heap *ceil_block;
};

word const VERA_HEAP_EMPTY = 0x0001;
word const VERA_HEAP_ADDRESS_16 = 0x0002;
word const VERA_HEAP_SIZE_16 = 0x0004;

word const VERA_HEAP_SIZE_MASK = 0xFFE0;

// byte vera_block_malloc(dword address, dword size);
// byte vera_block_free(byte block);

dword vera_heap_segment_init( byte segmentid, dword base, dword size );
dword vera_heap_segment_ceiling(byte segmentid);

void vera_heap_base_address_set(struct vera_heap_segment *segment, dword base_address);
void vera_heap_ceil_address_set(struct vera_heap_segment *segment, dword ceil_address);
dword vera_heap_address(struct vera_heap_segment *segment, dword size);
dword vera_heap_block_address_get(struct vera_heap *block);
dword vera_heap_block_size_get(struct vera_heap *block);
word vera_heap_block_is_empty(struct vera_heap *block);
void vera_heap_block_address_set(struct vera_heap *block, dword *address);
void vera_heap_block_size_set(struct vera_heap *block, dword *size);
void vera_heap_block_empty_set(struct vera_heap *block, byte empty);
void vera_heap_ram_bank_set(byte ram_bank);

struct vera_heap *vera_heap_block_find(struct vera_heap_segment *segment, struct vera_heap *block);
struct vera_heap *vera_heap_block_free_find(struct vera_heap_segment *segment, dword size);

dword vera_heap_malloc(byte segmentid, word size);
dword vera_heap_free(byte segmentid, struct vera_heap *block);
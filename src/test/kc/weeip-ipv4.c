
#define uint32_t unsigned long
#define uint16_t unsigned short
#define int16_t signed short
#define byte_t unsigned char

typedef union UINT32_T {
   uint32_t d;
   uint16_t w[2];
   byte_t b[4];
} _uint32_t;


/**
 * Internet protocol address (version 4).
 */
typedef union IPV4 {
   uint32_t d;
   byte_t b[4];
} IPV4;

/**
 * Ethernet MAC address.
 */
typedef struct EUI48 {
   byte_t b[6];
} EUI48;

/**
 * ARP message format.
 */
typedef struct ARP_HDR {
   uint16_t hardware;
   uint16_t protocol;
   byte_t hw_size;
   byte_t pr_size;
   uint16_t opcode;
   EUI48 orig_hw;
   IPV4 orig_ip;
   EUI48 dest_hw;
   IPV4 dest_ip;
} ARP_HDR;

/**
 * IP Header format.
 */
typedef struct IP_HDR {
   byte_t ver_length;            ///< Protocol version (4) and header size (32 bits units).
   byte_t tos;                   ///< Type of Service.
   uint16_t length;              ///< Total packet length.
   uint16_t id;                  ///< Message identifier.
   uint16_t frag;                ///< Fragmentation index (not used).
   byte_t ttl;                   ///< Time-to-live.
   byte_t protocol;              ///< Transport protocol identifier.
   uint16_t checksum;            ///< Header checksum.
   IPV4 source;                  ///< Source host address.
   IPV4 destination;             ///< Destination host address.
} IP_HDR;

/**
 * ICMP header format.
 */
typedef struct ICMP_HDR {
   byte_t type;
   byte_t fcode;
   uint16_t checksum;
   uint16_t id;
   uint16_t seq;
} ICMP_HDR;

/**
 * TCP header format.
 */
typedef struct TCP_HDR {
   uint16_t source;              ///< Source application address.
   uint16_t destination;         ///< Destination application address.
   _uint32_t n_seq;              ///< Output stream sequence number.
   _uint32_t n_ack;              ///< Input stream sequence number.
   byte_t hlen;                  ///< Header size.
   byte_t flags;                 ///< Protocol flags.
   uint16_t window;              ///< Reception window buffer (not used).
   uint16_t checksum;            ///< Packet checksum, with pseudo-header.
   uint16_t urgent;              ///< Urgent data pointer (not used).
} TCP_HDR;

/**
 * UDP header format.
 */
typedef struct UDP_HDR {
   uint16_t source;              ///< Source application address.
   uint16_t destination;         ///< Destination application address.
   uint16_t length;              ///< UDP packet size.
   uint16_t checksum;            ///< Packet checksum, with pseudo-header.
} UDP_HDR;

/**
 * General message header structure.
 */
typedef union HEADER {
   byte_t b[40];                 ///< Raw byte access.
   ARP_HDR arp;                  ///< ARP message access.
   struct IP {
      IP_HDR ip;                 ///< IP header access.
      union T {
         ICMP_HDR icmp;            ///< ICMP header access.
         TCP_HDR tcp;            ///< TCP header access.
         UDP_HDR udp;            ///< UDP header access.
      } t;
   } ip;
} HEADER;

HEADER header;

HEADER * const SCREEN = (HEADER *)0x0400;

void main() {
    header.arp.orig_hw.b[5] = 0xff;
    header.arp.dest_ip.b[3] = 0xff;
    SCREEN[0] = header;
    header.ip.ip.source.d = 0xdddddddd;
    header.ip.t.tcp.checksum = 0xeeee;
    SCREEN[1] = header;
}

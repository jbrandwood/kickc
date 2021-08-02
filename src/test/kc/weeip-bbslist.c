// Test initialization of array of struct with char* elements

#include <c64.h>
#include <stdio.h>

struct bbs {
  char *name;
  char *host_name;
  unsigned int port_number;
};

#define NULL 0

const struct bbs bbs_list[27]=
  {
   {"Boar's Head","byob.hopto.org",64128},
   {"RapidFire","rapidfire.hopto.org",64128},
   {"Antidote by Triad","antidote.hopto.org",64128},
   {"Wizards's Realm", "wizardsrealm.c64bbs.org", 23},
   {"The Hidden", "the-hidden.hopto.org", 64128},
   {"Eaglewing BBS", "eagelbird.ddns.net", 6400},
   {"Scorps Portal", "scorp.us.to", 23},
   {"My C=ult BBS", "maraud.dynalias.com", 6400},
   {"Commodore Image", "cib.dyndns.org", 6400},
   {"64 Vintag Remic", "64vintageremixbbs.dyndns.org", 6400},
   {"Jamming Signal", "bbs.jammingsignal.com", 23},
   {"Centronian BBS", "centronian.servebeer.com", 6400},
   {"Anrchy Undergrnd", "aubbs.dyndns.org", 2300},
   {"The Oasis BBS", "oasisbbs.hopto.org", 6400},
   {"The Disk Box", "bbs.thediskbox.com", 6400},
   {"Cottonwood", "cottonwoodbbs.dyndns.org", 6502},
   {"Wrong Number ][", "cib.dyndns.org", 6404},
   {"RabidFire", "rapidfire.hopto.org", 64128},
   {"Mad World", "madworld.bounceme.net", 6400},
   {"Citadel 64", "bbs.thejlab.com", 6400},
   {"Hotwire BBS", "hotwirebbs.zapto.org", 6502},
   {"Endless Chaos", "endlesschaos.dyndns.org", 6400},
   {"Borderline", "borderlinebbs.dyndns.org", 6400},
   {"RAVELOUTION","raveolution.hopto.org",64128},
   {"The Edge BBS","theedgebbs.dyndns.org",1541},
   {"PGS Test","F96NG92-L.fritz.box",64128},
   {NULL,NULL,0}
  };

void main() {
    VICII->MEMORY = 0x17;
    for(struct bbs * bbs = bbs_list; bbs->name; bbs++)
        printf("%s %s %u\n", bbs->name, bbs->host_name, bbs->port_number);
}

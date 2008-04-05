#include "sha1.h"

#include <stdlib.h>
#include <string.h>

void hmac_md5(unsigned char *inText, int inTextLength, unsigned char* inKey, int inKeyLength, unsigned char *outDigest)
{
const int B = 64;
const int L = 20;

sha1_context theSHA1Context;
unsigned char k_ipad[B + 1]; /* inner padding - key XORd with ipad */
unsigned char k_opad[B + 1]; /* outer padding - key XORd with opad */

/* if key is longer than 64 bytes reset it to key=MD5(key) */
if (inKeyLength > B)
	{
	sha1_starts(&theSHA1Context);
	sha1_update(&theSHA1Context, inKey, inKeyLength);
	sha1_finish(&theSHA1Context, inKey);
	inKeyLength = L;
	}

/* start out by storing key in pads */
memset(k_ipad, 0, sizeof k_ipad);
memset(k_opad, 0, sizeof k_opad);
memcpy(k_ipad, inKey, inKeyLength);
memcpy(k_opad, inKey, inKeyLength);

/* XOR key with ipad and opad values */
int i;
for (i = 0; i < B; i++)
	{
	k_ipad[i] ^= 0x36;
	k_opad[i] ^= 0x5c;
	}
	
/*
* perform inner MD5
*/
sha1_starts(&theSHA1Context);                 /* init context for 1st pass */
sha1_update(&theSHA1Context, k_ipad, B);     /* start with inner pad */
sha1_update(&theSHA1Context, inText, inTextLength); /* then text of datagram */
sha1_finish(&theSHA1Context, outDigest);                /* finish up 1st pass */

/*
* perform outer MD5
*/
sha1_starts(&theSHA1Context);                   /* init context for 2nd
* pass */
sha1_update(&theSHA1Context, k_opad, B);     /* start with outer pad */
sha1_update(&theSHA1Context, outDigest, L);     /* then results of 1st
* hash */
sha1_finish(&theSHA1Context, outDigest);          /* finish up 2nd pass */

}
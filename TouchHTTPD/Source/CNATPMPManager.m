//
//  UNATPMPManager
//  TouchHTTP
//
//  Created by Jonathan Wight on 03/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CNATPMPManager.h"

#include "natpmp.h"
#include "getgateway.h"

@implementation CNATPMPManager

@synthesize publicAddress;

- (id)init
{
if ((self = [super init]) != NULL)
	{
	initnatpmp(&natpmp);
	}
return(self);
}

- (void)dealloc
{
closenatpmp(&natpmp);
//
[super dealloc];
}

- (NSData *)externalAddress:(NSError **)outError;
{
#pragma unused (outError)

int theResult = sendpublicaddressrequest(&natpmp);
natpmpresp_t theResponse;
while (YES)
	{
	theResult = readnatpmpresponseorretry(&natpmp, &theResponse);
	if(theResult < 0 && theResult != NATPMP_TRYAGAIN)
		{
		return(NULL);
		}
	else if (theResult != NATPMP_TRYAGAIN)
		{
		self.publicAddress = [NSData dataWithBytes:&theResponse.publicaddress.addr length:sizeof(theResponse.publicaddress.addr)];
		return (self.publicAddress);
		}
	}
}

- (BOOL)openPortForProtocol:(int)protocol privatePort:(int)privateport publicPort:(int)publicport lifetime:(int)lifetime error:(NSError **)outError
{
natpmpresp_t theResponse;
int theResult;

theResult = sendnewportmappingrequest(&natpmp, protocol, privateport, publicport, lifetime);

while (YES)
	{
	theResult = readnatpmpresponseorretry(&natpmp, &theResponse);
	if (theResult < 0 && theResult != NATPMP_TRYAGAIN)
		return(NO);
	else if(theResult!=NATPMP_TRYAGAIN)
		{
		NSLog(@"mapped public port: %d", theResponse.newportmapping.mappedpublicport);
		NSLog(@" private port: %d", theResponse.newportmapping.privateport);
		NSLog(@"mapped lifetime: %d", theResponse.newportmapping.lifetime);
//				copy(publicport, response.newportmapping.mappedpublicport);
//				copy(privateport, response.newportmapping.privateport);
//				copy(mappinglifetime, response.newportmapping.lifetime);
		return(YES);
		}
	}
}


@end

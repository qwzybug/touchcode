//
//  CValueTransformer.m
//  TouchCode
//
//  Created by Jonathan Wight on Mon May 03 2004.
//  Copyright 2004 toxicsoftware.com. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "CValueTransformer.h"

#if (((MAC_OS_X_VERSION_10_3 <= MAC_OS_X_VERSION_MAX_ALLOWED) && !TARGET_OS_IPHONE) || (__IPHONE_3_0 && __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_3_0))
#else

@implementation CValueTransformer

static NSMutableDictionary *gTransformers = NULL; // TODO - exit manager

+ (void)setValueTransformer:(CValueTransformer *)transformer forName:(NSString *)name
{
if (gTransformers == NULL)
	gTransformers = [[NSMutableDictionary dictionary] retain];
	
[gTransformers setObject:transformer forKey:name];
}

+ (CValueTransformer *)valueTransformerForName:(NSString *)name
{
CValueTransformer *theTransformer = [gTransformers objectForKey:name];
if (theTransformer == NULL)
	{
	fprintf(stderr, (@"Could not find transformer for name '%s' in %s\n", [name UTF8String], [[[gTransformers allKeys] description] UTF8String]);
	}
return(theTransformer);
}

+ (NSArray *)valueTransformerNames
{
return([gTransformers allKeys]);
}

+ (Class)transformedValueClass
{
return(NULL);
}

+ (BOOL)allowsReverseTransformation
{
return(YES);
}

- (id)transformedValue:(id)value
{
return(value);
}

- (id)reverseTransformedValue:(id)value
{
return(value);
}

@end

#endif
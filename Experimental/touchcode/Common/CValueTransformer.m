//
//  CValueTransformer.m
//  CSVTest
//
//  Created by Jonathan Wight on Mon May 03 2004.
//  Copyright (c) 2004 Toxic Software. All rights reserved.
//

#import "CValueTransformer.h"

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
return([gTransformers objectForKey:name]);
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

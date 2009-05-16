//
//  CValueTransformer.h
//  CSVTest
//
//  Created by Jonathan Wight on Mon May 03 2004.
//  Copyright (c) 2004 Toxic Software. All rights reserved.
//

#import <Foundation/Foundation.h>

//#if MAC_OS_X_VERSION_10_3 <= MAC_OS_X_VERSION_MAX_ALLOWED
//
//#define CValueTransformer NSValueTransformer
//
//#else

@interface CValueTransformer : NSObject {
}

+ (void)setValueTransformer:(CValueTransformer *)transformer forName:(NSString *)name;
+ (CValueTransformer *)valueTransformerForName:(NSString *)name;
+ (NSArray *)valueTransformerNames;

+ (Class)transformedValueClass;
+ (BOOL)allowsReverseTransformation;

- (id)transformedValue:(id)value;
- (id)reverseTransformedValue:(id)value;

@end

//#endif

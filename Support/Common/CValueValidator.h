//
//  CValueValidator.h
//  Birdfeed Redux
//
//  Created by Jonathan Wight on 03/30/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CValueValidator : NSValueTransformer {

}

+ (CValueValidator *)valueValidatorForName:(NSString *)name;
+ (void)setValueValidator:(CValueValidator *)validator forName:(NSString *)name;

- (BOOL)isValid:(id)inValue;

// To be overriden by subclasses.
- (BOOL)validateValue:(id)inValue error:(NSError **)outError;

@end

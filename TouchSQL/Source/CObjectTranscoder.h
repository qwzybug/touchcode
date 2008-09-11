//
//  CObjectTranscoder.h
//  ProjectV
//
//  Created by Jonathan Wight on 9/11/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CObjectTranscoder : NSObject {
	Class targetObjectClass;
	NSDictionary *propertyNameMappings;
}

@property (readwrite, assign) Class targetObjectClass;
@property (readwrite, retain) NSDictionary *propertyNameMappings;

- (id)initWithTargetObjectClass:(Class)inTargetObjectClass;

- (BOOL)updateObject:(id)inObject withPropertiesInDictionary:(NSDictionary *)inDictionary error:(NSError **)outError;
- (id)transformObject:(id)inObject toObjectOfClass:(Class)inTargetClass error:(NSError **)outError;

@end

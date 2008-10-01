//
//  CGeoObject.h
//  TouchGeo
//
//  Created by Jonathan Wight on 08/13/08.
//  Copyright (c) 2008 Jonathan Wight
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

#import <Foundation/Foundation.h>

#import "GeoTypes.h"

@interface CGeoObject : NSObject <NSCopying> {
	NSMutableDictionary *additionalMembers;
	SGeoBoundingBox boundingBox;
}

@property (readwrite, retain) NSMutableDictionary *additionalMembers;
@property (readwrite, assign) SGeoBoundingBox boundingBox;

+ (NSString *)geoTypeName;

- (BOOL)isEqual:(id)inObject;

- (BOOL)isValid:(NSError **)outError;

- (SGeoBoundingBox)computeMinimumBoundingBox;

#pragma mark -

+ (NSSet *)dictionaryKeys;
+ (id)objectFromDictionary:(NSDictionary *)inDictionary;
- (NSDictionary *)asDictionary;

@end

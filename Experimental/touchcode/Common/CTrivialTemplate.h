//
//  CTrivialTemplate.h
//  Obama
//
//  Created by Jonathan Wight on 9/19/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTrivialTemplate : NSObject {
	NSString *template;
}

@property (readwrite, nonatomic, retain) NSString *template;

- (id)initWithTemplate:(NSString *)inTemplate; // Designated init.
- (id)initWithPath:(NSString *)inPath;
- (id)initWithTemplateName:(NSString *)inTemplateName;

- (NSString *)transform:(NSDictionary *)inReplacementDictionary error:(NSError **)outError;

@end

#pragma mark -

@interface CTrivialTemplate (CTrivialTemplate_Conveniences)
+ (NSString *)transformTemplateNamed:(NSString *)inName replacementDictionary:(NSDictionary *)inDictionary error:(NSError **)outError;
@end
//
//  CFeedEntry.h
//  <#ProjectName#>
//
//  Created by Jonathan Wight on 09/20/09
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import <CoreData/CoreData.h>

@class CObjectTranscoder;

#pragma mark begin emogenerator forward declarations
@class CFeed;
#pragma mark end emogenerator forward declarations

/** Entry */
@interface CFeedEntry : NSManagedObject {
}

+ (NSArray *)persistentPropertyNames;
+ (CObjectTranscoder *)objectTranscoder;

#pragma mark begin emogenerator accessors

+ (NSString *)entityName;

// Attributes
@property (readwrite, retain) NSDate *updated;
@property (readwrite, retain) NSString *content;
@property (readwrite, retain) NSString *subtitle;
@property (readwrite, retain) NSString *title;
@property (readwrite, retain) NSString *link;
@property (readwrite, retain) NSString *identifier;

// Relationships
@property (readwrite, retain) CFeed *feed;
- (CFeed *)feed;
- (void)setFeed:(CFeed *)inFeed;

#pragma mark end emogenerator accessors

@end

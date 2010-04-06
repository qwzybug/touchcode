//
//  NSError_Extensions.h
//  Logging
//
//  Created by Jonathan Wight on 8/27/07.
//  Copyright 2007 Toxic Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (NSError_Extensions)

+ (id)errorWithDomain:(NSString *)inDomain code:(int)inCode userInfo:(NSDictionary *)inUserInfo localizedDescription:(NSString *)inFormat, ...;

+ (int)errnoForError:(NSError *)inError;

+ (id)errorWithException:(NSException *)inException;

@end

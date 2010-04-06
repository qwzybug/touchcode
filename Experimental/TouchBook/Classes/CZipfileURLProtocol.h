//
//  CZipfileURLProtocol.h
//  TouchBook
//
//  Created by Jonathan Wight on 02/09/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CZipfile;

@interface CZipfileURLProtocol : NSURLProtocol {
	CZipfile *zipfile;
}

@end

//
//  NSString+MD5.h
//  MD5
//
//  Created by Alexander Hedley on 16/08/2015.
//  Copyright (c) 2015 Alex Hedley. All rights reserved.
//

// http://stackoverflow.com/questions/2018550/how-do-i-create-an-md5-hash-of-a-string-in-cocoa
// http://rypress.com/tutorials/objective-c/categories

#import <Foundation/Foundation.h>

@interface NSString (MD5)

- (NSString *)MD5String;

@end

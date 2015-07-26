//
//  Utility.m
//  Utility
//
//  Created by Alexander Hedley on 26/07/2015.
//  Copyright (c) 2015 Alex Hedley. All rights reserved.
//

#import "Utility.h"

@implementation Utility

#pragma mark -
#pragma mark URL Encode/Decode

- (IBAction)decode:(id)sender {
    NSString *unescaped = txtURLDecode.stringValue; //@"http://www";
    NSString *escapedString = [unescaped stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSLog(@"escapedString: %@", escapedString);
    txtURLEncode.stringValue = escapedString;
}

- (IBAction)encode:(id)sender {
    NSString *escaped = txtURLEncode.stringValue; //@"http://www";
    NSString *unescapedString = [escaped stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSLog(@"escapedString: %@", unescapedString);
    txtURLDecode.stringValue = unescapedString;
}

- (IBAction)copyURL:(id)sender {
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    //pasteboard.string = txtURLEncode.stringValue;
    //BOOL OK = [pasteboard writeObjects:txtURLEncode.stringValue];
    [pasteboard clearContents];
    [pasteboard setString:txtURLEncode.stringValue forType:NSPasteboardTypeString]; //NSStringPboardType;
}

@end

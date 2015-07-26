//
//  Utility.h
//  Utility
//
//  Created by Alexander Hedley on 26/07/2015.
//  Copyright (c) 2015 Alex Hedley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface Utility : NSObject {
    IBOutlet NSTextField *txtURLDecode;
    IBOutlet NSTextField *txtURLEncode;
}

- (IBAction)decode:(id)sender;
- (IBAction)encode:(id)sender;
- (IBAction)copyURL:(id)sender;

@end

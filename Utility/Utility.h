//
//  Utility.h
//  Utility
//
//  Created by Alexander Hedley on 26/07/2015.
//  Copyright (c) 2015 Alex Hedley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface Utility : NSObject {
    IBOutlet NSTextField *txtURLDecode;
    IBOutlet NSTextField *txtURLEncode;
    
    IBOutlet NSTextField *txtHTMLEscape;
    IBOutlet NSTextField *txtHTMLUnescape;
    IBOutlet WebView *webView;
    
    IBOutlet NSTextField *txtZeroGuid;
    IBOutlet NSTextField *txtGuid;
}

- (IBAction)decode:(id)sender;
- (IBAction)encode:(id)sender;
- (IBAction)copyURL:(id)sender;

- (IBAction)escape:(id)sender;
- (IBAction)unescape:(id)sender;

+ (NSString *)getUUID;
- (IBAction)generateGuid:(id)sender;
- (IBAction)copyZeroGuid:(id)sender;
- (IBAction)copyGuid:(id)sender;

@end

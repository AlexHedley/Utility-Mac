//
//  Utility.m
//  Utility
//
//  Created by Alexander Hedley on 26/07/2015.
//  Copyright (c) 2015 Alex Hedley. All rights reserved.
//

#import "Utility.h"

@implementation Utility

//#define NSColorFromRGB(rgbValue) [NSColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

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

#pragma mark -
#pragma mark HTML Escape/Unescape

- (IBAction)escape:(id)sender {
    NSString *data = txtHTMLEscape.stringValue;
    CFStringRef dataEsc = CFXMLCreateStringByUnescapingEntities(NULL, (CFStringRef)data, NULL);
    NSString *dataEscaped = (__bridge NSString*)dataEsc;
    NSLog(@"%@", dataEscaped);
    txtHTMLUnescape.stringValue = dataEscaped;
    
    [[webView mainFrame] loadHTMLString:dataEscaped baseURL:[[NSBundle mainBundle] bundleURL]];
    //NSString *html = @"<html><body><h1>Hello</h1></body></html>";
    //[webView loadHTMLString:html baseURL:nil];
//    [webView loadHTMLString:html baseURL:[[NSBundle mainBundle] bundleURL]];
//    [webView loadHTMLString:dataEscaped baseURL:nil];
//    [webView loadHTMLString:dataEscaped baseURL:[[NSBundle mainBundle] bundleURL]];
//    WebFrame
    
//    NSString *resourcesPath = [[NSBundle mainBundle] resourcePath];
//    NSString *htmlPath = [resourcesPath stringByAppendingString:@"/index.html"];
//    [[webView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:htmlPath]]];
    
//    DOMDocument *myDOMDocument = [[webView mainFrame] DOMDocument];
//    DOMElement *html = [myDOMDocument getElementsByTagName:@"html"];
//    //[html setTextContent:dataEscaped];
//    [html setNodeValue:dataEscaped];
}

- (IBAction)unescape:(id)sender {
    NSString *data = txtHTMLUnescape.stringValue;
    CFStringRef dataUnEsc = CFXMLCreateStringByEscapingEntities(NULL, (CFStringRef)data, NULL);
    NSString * dataUnescaped = (__bridge NSString*)dataUnEsc;
    NSLog(@"%@", dataUnescaped);
    txtHTMLEscape.stringValue = dataUnescaped;
}

#pragma mark -
#pragma mark Guid

+ (NSString *)getUUID {
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge NSString *)string;
}

- (IBAction)generateGuid:(id)sender {
    //txtGuid.stringValue = [self getUUID];
    NSString *UUID = [[NSUUID UUID] UUIDString];
    txtGuid.stringValue = UUID;
}

- (IBAction)copyZeroGuid:(id)sender {
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    [pasteboard clearContents];
    [pasteboard setString:txtZeroGuid.stringValue forType:NSPasteboardTypeString];
}

- (IBAction)copyGuid:(id)sender {
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    [pasteboard clearContents];
    [pasteboard setString:txtGuid.stringValue forType:NSPasteboardTypeString];
}

#pragma mark -
#pragma mark HEX to RGB

- (IBAction)convertHex:(id)sender {
    NSString *noHashString = [txtHex.stringValue stringByReplacingOccurrencesOfString:@"#" withString:@""]; // remove the #
    NSScanner *scanner = [NSScanner scannerWithString:noHashString];
    unsigned hex;
    [scanner scanHexInt: &hex];
    [scanner setCharactersToBeSkipped:[NSCharacterSet symbolCharacterSet]]; // remove + and $
    
    txtRed.stringValue = [@(((float)((hex & 0xFF0000) >> 16))/255.0) stringValue];
    txtGreen.stringValue = [@(((float)((hex & 0xFF00) >> 8))/255.0) stringValue];
    txtBlue.stringValue = [@(((float)(hex & 0xFF))/255.0) stringValue];
    
    //txtFill.backgroundColor = NSColorFromRGB(txtHex.stringValue);
}

@end

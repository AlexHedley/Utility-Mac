//
//  Utility.m
//  Utility
//
//  Created by Alexander Hedley on 26/07/2015.
//  Copyright (c) 2015 Alex Hedley. All rights reserved.
//

#import "Utility.h"
#import "JSONSyntaxHighlight.h"
#import <libxml/tree.h>

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

#pragma mark -
#pragma mark JSON Pretty Print

//https://github.com/bahamas10/JSONSyntaxHighlight

- (IBAction)convertJson:(id)sender {
    NSString *jsonString = tvJSON.string;
    id JSONObj = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
    
    // create the JSONSyntaxHighilight Object
    JSONSyntaxHighlight *jsh = [[JSONSyntaxHighlight alloc] initWithJSON:JSONObj];
    
    // place the text into the view
    tvJSON.string = @"\n";
    [tvJSON insertText:[jsh highlightJSON]];
}

#pragma mark -
#pragma mark XML Pretty Print

//http://stackoverflow.com/questions/19857045/pretty-print-xml-from-nsstring-in-objective-c

//Step 2. Add libxml2 to the search path
//In Project -> Build Settings -> Search Paths -> Header Search Paths, add path: /usr/include/libxml2
//In Project -> Build Settings -> Linking -> Other Linker Flags, add flag: -lxml2

+ (NSString *)prettyPrintXML:(NSString *)rawXML {
    const char *utf8Str = [rawXML UTF8String];
    xmlDocPtr doc = xmlReadMemory(utf8Str, (int)strlen(utf8Str), NULL, NULL, XML_PARSE_NOCDATA | XML_PARSE_NOBLANKS);
    xmlNodePtr root = xmlDocGetRootElement(doc);
    xmlNodePtr xmlNode = xmlCopyNode(root, 1);
    xmlFreeDoc(doc);
    
    NSString *str = nil;
    
    xmlBufferPtr buff = xmlBufferCreate();
    doc = NULL;
    int level = 0;
    int format = 1;
    
    int result = xmlNodeDump(buff, doc, xmlNode, level, format);
    
    if (result > -1) {
        str = [[NSString alloc] initWithBytes:(xmlBufferContent(buff))
                                       length:(NSUInteger)(xmlBufferLength(buff))
                                     encoding:NSUTF8StringEncoding];
    }
    xmlBufferFree(buff);
    
    NSCharacterSet *ws = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [str stringByTrimmingCharactersInSet:ws];
    return trimmed;
}

- (IBAction)convertXml:(id)sender {
    tvXML.string = [Utility prettyPrintXML:tvXML.string];
}

#pragma mark -
#pragma IN Clause

- (IBAction)parseItems:(id)sender {
    //yourTextField.text = [yourArray componentsJoinedByString:@"\n"];
    NSArray *arr = [tvInItems.string componentsSeparatedByString:@"\n"];
    NSMutableArray *strings = [arr mutableCopy];
    [strings removeObject:@""];
    NSLog(@"%@", strings);
    //NSMutableString *parsed = [[NSMutableString alloc] init];
    NSMutableString *parsed = [NSMutableString string];
    NSString *wrapper = [[NSString alloc] init];
    wrapper = [cboWraper objectValueOfSelectedItem];
    if (wrapper == (id)[NSNull null] || wrapper.length == 0 )
        wrapper = @"";
    NSLog(@"%@", wrapper);
    
    for (NSString *itm in strings)  {
        [parsed appendFormat:@"%@%@%@, ", wrapper, itm, wrapper];
    }
    
    NSUInteger length = [parsed length];
    NSLog(@"%lu", (unsigned long)length);
    if (length > 0) {
        NSString *parsedStr = [parsed substringToIndex:length-2];
        NSLog(@"parsed %@", parsedStr);
        [parsed setString:parsedStr];
        NSLog(@"parsed %@", parsedStr);
    }
    
    //[parsed stringByAppendingFormat:@"IN (%@)", parsed];
    //[parsed appendFormat:@"IN (%@)", parsed];
    [parsed setString:[NSString stringWithFormat:@"IN (%@)", parsed]];
    
    NSLog(@"%@", parsed);
    tvParsedItems.string = parsed;
}

- (IBAction)copyItems:(id)sender {
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    [pasteboard clearContents];
    [pasteboard setString:tvParsedItems.string forType:NSPasteboardTypeString];
}

#pragma mark -
#pragma Menu Item

- (IBAction)createIssue:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@kNewIssueURL]];
}

- (IBAction)visitWebsite:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@kWebsiteURL]];
}

@end

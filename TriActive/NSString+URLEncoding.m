//
//  radioButton.m
//  shedularTask
//
//  Created by Preeti Malhotra on 25/07/14.
//  Copyright (c) 2014 Preeti Malhotra. All rights reserved.
//

@implementation NSString (URLEncoding)

- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding {
	return (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                        (CFStringRef)self,
                                                                        NULL,
                                                                        (CFStringRef)@"!*'\"();:@&+$,./?%#[]% ",
                                                                        CFStringConvertNSStringEncodingToEncoding(encoding));
}
NSString* encodeToPercentEscapeString(NSString *string) {
    return (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                            (CFStringRef) string,
                                            NULL,
                                            (CFStringRef) @"!*'();:@&+$,/?%#[]",
                                                                    kCFStringEncodingUTF8));
}

// Decode a percent escape encoded string.
NSString* decodeFromPercentEscapeString(NSString *string) {
    return (NSString *)
    CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                            (CFStringRef) string,
                                                            CFSTR(""),
                                                            kCFStringEncodingUTF8));
}

@end

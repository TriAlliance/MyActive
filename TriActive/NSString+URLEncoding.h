//
//  radioButton.h
//  shedularTask
//
//  Created by Preeti Malhotra on 25/07/14.
//  Copyright (c) 2014 Preeti Malhotra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLEncoding)

/**
 * Encode the url string.
 * @param encoding Encoding format for the output string.
 * @return Resulting string.
 */
- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding;
NSString* encodeToPercentEscapeString(NSString *string) ;// Decode a percent escape encoded string.
NSString* decodeFromPercentEscapeString(NSString *string) ;
@end

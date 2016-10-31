//
//  NSString+mnubo.m
//
//  Copyright (c) 2016 mnubo. All rights reserved.
//

#import "NSString+mnubo.h"

@implementation NSString (mnubo)

- (NSString *)urlEncode
{
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (__bridge CFStringRef)self,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                                 CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
}

- (NSString *)base64Encode
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
}

@end

//
//  MNUHTTPClient.h
//  APIv3
//
//  Created by Guillaume on 2015-10-06.
//  Copyright © 2015 mnubo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNUHTTPClient : NSObject

+ (void)POST:(NSString *)path headers:(NSDictionary *)headers parameters:(NSDictionary *)parameters body:(NSData *)body completion:(void (^)(NSData* data, NSDictionary *responsesHeaderFields, NSError *error))completion;

+ (void)PUT:(NSString *)path headers:(NSDictionary *)headers parameters:(NSDictionary *)parameters body:(NSData *)body completion:(void (^)(NSData* data, NSDictionary *responsesHeaderFields, NSError *error))completion;

@end

//
//  MNUHTTPClient.h
//
//  Copyright (c) 2016 mnubo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNUHTTPClient : NSObject

+ (void)POST:(NSString *)path headers:(NSDictionary *)headers parameters:(NSDictionary *)parameters body:(NSData *)body completion:(void (^)(NSData* data, NSDictionary *responsesHeaderFields, NSError *error))completion;

+ (void)PUT:(NSString *)path headers:(NSDictionary *)headers parameters:(NSDictionary *)parameters body:(NSData *)body completion:(void (^)(NSData* data, NSDictionary *responsesHeaderFields, NSError *error))completion;

+ (void)DELETE:(NSString *)path headers:(NSDictionary *)headers parameters:(NSDictionary *)parameters completion:(void (^)(NSData* data, NSDictionary *responsesHeaderFields, NSError *error))completion;

@end

//
//  MNUApiManager.h
//
//  Copyright (c) 2016 mnubo. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "MNUSupportedIsp.h"

@interface MNUApiManager : NSObject

- (instancetype)initWithClientId:(NSString *)clientId andHostname:(NSString *)hostname;
- (void)getUserAccessTokenWithUsername:(NSString *)username password:(NSString *)password completion:(void (^)(NSError *error))completion;
- (void)getUserAccessTokenWithUsername:(NSString *)username andToken:(NSString *)token andISP:(SupportedIsp)isp completion:(void (^)(NSError *error))completion;

- (void)postWithPath:(NSString *)path body:(NSData *)body completion:(void (^)(NSData *data, NSError *error))completion;

- (void)putWithPath:(NSString *)path body:(NSData *)body completion:(void (^)(NSData *data, NSError *error))completion;

- (BOOL)isOwnerAccessTokenPresent;
- (void)removeTokens;
- (NSString *)getUsername;
@end

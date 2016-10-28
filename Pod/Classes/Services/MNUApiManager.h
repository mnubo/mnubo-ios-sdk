//
//  MNUApiManager.h
//  APIv3
//
//  Created by Guillaume on 2015-10-18.
//  Copyright © 2015 mnubo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNUApiManager : NSObject

- (instancetype)initWithClientId:(NSString *)clientId andHostname:(NSString *)hostname;
- (void)getUserAccessTokenWithUsername:(NSString *)username password:(NSString *)password completion:(void (^)(NSError *error))completion;

- (void)postWithPath:(NSString *)path body:(NSData *)body completion:(void (^)(NSData *data, NSError *error))completion;

- (void)putWithPath:(NSString *)path body:(NSData *)body completion:(void (^)(NSData *data, NSError *error))completion;

- (BOOL)isOwnerAccessTokenPresent;
- (void)removeTokens;
@end

//
//  MnuboClient.h
//  APIv3
//
//  Created by Guillaume on 2015-10-10.
//  Copyright © 2015 mnubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNUApiManager.h"
#import "MNUSmartObject.h"
#import "MNUEvent.h"
#import "MNUOwner.h"


@interface MnuboClient : NSObject

// Init
+ (MnuboClient *)sharedInstanceWithClientId:(NSString *)clientId andHostname:(NSString *)hostname;
+ (MnuboClient *)sharedInstance;
- (BOOL)isOwnerConnected;

// Auth
- (void)loginWithUsername:(NSString *)username password:(NSString *)password completion:(void (^)(NSError *error))completion;
- (void)logout;

// Services
- (void)updateSmartObject:(MNUSmartObject *)smartObject withDeviceId:(NSString *)deviceId;
- (void)updateOwner:(MNUOwner *)owner withUsername:(NSString *)username;
- (void)sendEvents:(NSArray *)events withDeviceId:(NSString *)deviceId;

// Async services
- (void)updateSmartObject:(MNUSmartObject *)smartObject withDeviceId:(NSString *)deviceId completion:(void (^)(NSError *error))completion;
- (void)updateOwner:(MNUOwner *)owner withUsername:(NSString *)username completion:(void (^)(NSError *error))completion;
- (void)sendEvents:(NSArray *)events withDeviceId:(NSString *)deviceId completion:(void (^)(NSError *error))completion;



@end

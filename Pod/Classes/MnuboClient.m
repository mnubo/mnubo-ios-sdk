//
//  MnuboClient.m
//  APIv3
//
//  Created by Guillaume on 2015-10-10.
//  Copyright © 2015 mnubo. All rights reserved.
//

#import "MnuboClient.h"
#import "MNUHTTPClient.h"
#import "MNUConstants.h"
#import "MNUApiManager.h"


@implementation MnuboClient {
    MNUApiManager *_apiManager;
}

static MnuboClient *_sharedInstance = nil;


// Initialization

+ (MnuboClient *)sharedInstanceWithClientId:(NSString *)clientId andHostname:(NSString *)hostname {
    NSAssert((clientId != nil), @"Client ID should be present");
    NSAssert((hostname != nil), @"Hostname should be present");
    
    static dispatch_once_t unique = 0;
    dispatch_once(&unique, ^{
        _sharedInstance = [[self alloc] initWithClientId:clientId andHostname:hostname];
    });
    return _sharedInstance;
}

+ (MnuboClient *)sharedInstance {
    return _sharedInstance;
}

- (instancetype)initWithClientId:(NSString *)clientId andHostname:(NSString *)hostname {
    self = [super init];
    if(self) {
        _apiManager = [[MNUApiManager alloc] initWithClientId:clientId andHostname:hostname];
    }
    return self;
}

// Services

- (void)loginWithUsername:(NSString *)username password:(NSString *)password completion:(void (^)(NSError *error))completion {
    [_apiManager getUserAccessTokenWithUsername:username password:password completion:^(NSError *error) {
        NSLog(@"Error : %@", error);
        if (completion) completion(error);
    }];
}

- (void)logout {
    [_apiManager removeTokens];
}

- (BOOL)isOwnerConnected {
    return [_apiManager isOwnerAccessTokenPresent];
}

- (void)updateSmartObject:(MNUSmartObject *)smartObject withDeviceId:(NSString *)deviceId {
    NSString *path = [NSString stringWithFormat:@"/api/v3/objects/%@", deviceId];
    [_apiManager putWithPath:path body:[smartObject toDictionary] completion:nil];
}

- (void)updateOwner:(MNUOwner *)owner withUsername:(NSString *)username {
    NSString *path = [NSString stringWithFormat:@"/api/v3/owners/%@", username];
    [_apiManager putWithPath:path body:[owner toDictionary] completion:nil];
}

- (void)sendEvents:(NSArray *)events withDeviceId:(NSString *)deviceId {
    for (MNUEvent *event in events) {
        NSString *path = [NSString stringWithFormat:@"/api/v3/objects/%@/events", deviceId];
        [_apiManager postWithPath:path body:[event toDictionary] completion:nil];
    }
}

// Services async

- (void)updateSmartObject:(MNUSmartObject *)smartObject withDeviceId:(NSString *)deviceId andCallBack:(void (^)(NSDictionary *data, NSError *error))callback {
    NSString *path = [NSString stringWithFormat:@"/api/v3/objects/%@", deviceId];
    [_apiManager putWithPath:path body:[smartObject toDictionary] completion:callback];
}

- (void)updateOwner:(MNUOwner *)owner withUsername:(NSString *)username andCallBack:(void (^)(NSDictionary *data, NSError *error))callback {
    NSString *path = [NSString stringWithFormat:@"/api/v3/owners/%@", username];
    [_apiManager putWithPath:path body:[owner toDictionary] completion:callback];
}

- (void)sendEvents:(NSArray *)events withDeviceId:(NSString *)deviceId andCallBack:(void (^)(NSDictionary *data, NSError *error))callback {
    for (MNUEvent *event in events) {
        NSString *path = [NSString stringWithFormat:@"/api/v3/objects/%@/events", deviceId];
        [_apiManager postWithPath:path body:[event toDictionary] completion:callback];
    }
}

@end

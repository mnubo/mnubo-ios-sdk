//
//  MnuboClient.m
//
//  Copyright (c) 2016 mnubo. All rights reserved.
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
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[smartObject toDictionary] options:0 error:nil];
    
    [_apiManager putWithPath:path body:jsonData completion:nil];
}

- (void)updateOwner:(MNUOwner *)owner withUsername:(NSString *)username {
    NSString *path = [NSString stringWithFormat:@"/api/v3/owners/%@", username];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[owner toDictionary] options:0 error:nil];
    
    [_apiManager putWithPath:path body:jsonData completion:nil];
}

- (void)sendEvents:(NSArray *)events withDeviceId:(NSString *)deviceId {
    NSString *path = [NSString stringWithFormat:@"/api/v3/objects/%@/events", deviceId];
    NSArray *eventsPayload = [self convertEvents:events];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:eventsPayload options:0 error:nil];
    
    [_apiManager postWithPath:path body:jsonData completion:nil];
}

// Services async
- (void)updateSmartObject:(MNUSmartObject *)smartObject withDeviceId:(NSString *)deviceId completion:(void (^)(NSError *error))completion {
    NSString *path = [NSString stringWithFormat:@"/api/v3/objects/%@", deviceId];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[smartObject toDictionary] options:0 error:nil];
    
    [_apiManager putWithPath:path body:jsonData completion:^(NSData *data, NSError *error) {
        if(completion) completion(error);
    }];
}

- (void)updateOwner:(MNUOwner *)owner withUsername:(NSString *)username completion:(void (^)(NSError *error))completion {
    NSString *path = [NSString stringWithFormat:@"/api/v3/owners/%@", username];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[owner toDictionary] options:0 error:nil];
    
    [_apiManager putWithPath:path body:jsonData completion:^(NSData *data, NSError *error) {
        if(completion) completion(error);
    }];
}

- (void)sendEvents:(NSArray *)events withDeviceId:(NSString *)deviceId completion:(void (^)(NSError *error))completion {
    NSArray *eventsPayload = [self convertEvents:events];
    NSString *path = [NSString stringWithFormat:@"/api/v3/objects/%@/events", deviceId];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:eventsPayload options:0 error:nil];
    
    [_apiManager postWithPath:path body:jsonData completion:^(NSData *data, NSError *error) {
        if(completion) completion(error);
    }];
    
}

- (NSArray *)convertEvents:(NSArray *)events {
    NSMutableArray *eventsPayload = [NSMutableArray arrayWithCapacity:[events count]];
    for (MNUEvent *event in events) {
        [eventsPayload addObject:[event toDictionary]];
    }
    return eventsPayload;
}

@end

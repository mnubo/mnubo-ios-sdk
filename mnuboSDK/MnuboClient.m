//
//  MnuboClient.m
//
//  Copyright (c) 2016 mnubo. All rights reserved.
//

#import "MnuboClient.h"
#import "MNUHTTPClient.h"
#import "MNUConstants.h"
#import "MNUApiManager.h"
#import "MNUSupportedIsp.h"


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

- (void)loginWithUsername:(NSString *)username andToken:(NSString *)token andISP:(SupportedIsp)isp completion:(void (^)(NSError *error))completion {
    [_apiManager getUserAccessTokenWithUsername:username andToken:kTokenPath andISP:isp completion:^(NSError *error) {
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
    [self updateSmartObject:smartObject withDeviceId:deviceId completion:nil];
}
- (void)createSmartObject:(MNUSmartObject *)smartObject withDeviceId:(NSString *)deviceId withObjectType:(NSString *)objectType {
    [self createSmartObject:smartObject withDeviceId:deviceId withObjectType:objectType completion:nil];
}

- (void)deleteSmartObjectWithDeviceId:(NSString *)deviceId {
    [self deleteSmartObjectWithDeviceId:deviceId completion:nil];
}

- (void)updateOwner:(MNUOwner *)owner {
    [self updateOwner:owner completion:nil];
}

- (void)updateOwner:(MNUOwner *)owner withUsername:(NSString *)username {
    [self updateOwner:owner completion:nil];
}

- (void)createOwner:(MNUOwner *)owner withPassword:(NSString *)password  {
    [self createOwner:owner withPassword:password completion:nil];
}

- (void)deleteOwner {
    [self deleteOwner:nil];
}

- (void)sendEvents:(NSArray *)events withDeviceId:(NSString *)deviceId {
    [self sendEvents:events withDeviceId:deviceId completion:nil];
}

// Services async
- (void)updateSmartObject:(MNUSmartObject *)smartObject withDeviceId:(NSString *)deviceId completion:(void (^)(NSError *error))completion {
    NSString *path = [NSString stringWithFormat:@"/api/v3/objects/%@", deviceId];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[smartObject toDictionary] options:0 error:nil];

    [_apiManager putWithPath:path body:jsonData completion:^(NSData *data, NSError *error) {
        if(completion) completion(error);
    }];
}
- (void)createSmartObject:(MNUSmartObject *)smartObject withDeviceId:(NSString *)deviceId withObjectType:(NSString *)objectType completion:(void (^)(NSError *error))completion {
    NSMutableDictionary * md = [[smartObject toDictionary] mutableCopy];
    [md setObject:deviceId forKey:@"x_device_id"];
    [md setObject:objectType forKey:@"x_object_type"];

    NSString *path = [NSString stringWithFormat:@"/api/v3/owners/%@/objects", _apiManager.getUsername];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:md options:0 error:nil];

    [_apiManager postWithPath:path body:jsonData completion:^(NSData *data, NSError *error) {
        if(completion) completion(error);
    }];
}


- (void)deleteSmartObjectWithDeviceId:(NSString *)deviceId completion:(void (^)(NSError *))completion {
    NSString *path = [NSString stringWithFormat:@"/api/v3/owners/%@/objects/%@", _apiManager.getUsername, deviceId];

    [_apiManager putWithPath:path body:nil completion:^(NSData *data, NSError *error) {
        if(completion) completion(error);
    }];
}

- (void)updateOwner:(MNUOwner *)owner completion:(void (^)(NSError *error))completion {
    NSString *path = [NSString stringWithFormat:@"/api/v3/owners/%@", _apiManager.getUsername];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[owner toDictionary] options:0 error:nil];

    [_apiManager putWithPath:path body:jsonData completion:^(NSData *data, NSError *error) {
        if(completion) completion(error);
    }];
}

- (void)updateOwner:(MNUOwner *)owner withUsername:(NSString *)username completion:(void (^)(NSError *error))completion {
    [self updateOwner:owner completion:completion];
}

- (void)createOwner:(MNUOwner *)owner withPassword:(NSString *)password completion:(void (^)(NSError *error))completion {
    NSString *path = @"/api/v3/owners";

    NSMutableDictionary * md = [[owner toDictionary] mutableCopy];
    [md setObject:_apiManager.getUsername forKey:@"username"];
    [md setObject:password forKey:@"x_password"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:md options:0 error:nil];

    [_apiManager putWithPath:path body:jsonData completion:^(NSData *data, NSError *error) {
        if(completion) completion(error);
    }];
}

- (void) deleteOwner: (void (^)(NSError *error))completion {
    NSString *path = [NSString stringWithFormat:@"/api/v3/owners/%@", _apiManager.getUsername];

    [_apiManager putWithPath:path body:nil completion:^(NSData *data, NSError *error) {
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

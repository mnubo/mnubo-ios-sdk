//
//  MNUAccessToken.m
//
//  Copyright (c) 2016 mnubo. All rights reserved.
//

#import "MNUAccessToken.h"
#import "MNUConstants.h"
#import "PDKeychainBindings.h"

@implementation MNUAccessToken

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    
    self = [super init];
    if (self) {
        _accessToken = [dictionary objectForKey:@"access_token"];
        _refreshToken = [dictionary objectForKey:@"refresh_token"];
        _expiresIn = [dictionary objectForKey:@"expires_in"];
        _requestedAt = [NSDate date];
    }
    
    return self;
}

- (void)removeTokens {
    _accessToken = nil;
    _refreshToken = nil;
    _expiresIn = nil;
    _requestedAt = nil;
}

- (BOOL)isValid {
    int tokenExpiration = [[NSNumber numberWithDouble:[_requestedAt timeIntervalSince1970]] intValue] + [_expiresIn intValue];
    int timeNow = [[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] intValue];
    
    return (tokenExpiration > timeNow);
}

- (void)loadTokens
{
    _accessToken = [[PDKeychainBindings sharedKeychainBindings] stringForKey:kMnuboUserAccessTokenKey];
    _refreshToken = [[PDKeychainBindings sharedKeychainBindings] stringForKey:kMnuboUserRefreshTokenKey];
    _expiresIn = [[NSUserDefaults standardUserDefaults] objectForKey:kMnuboUserExpiresInKey];
    _requestedAt = [[NSUserDefaults standardUserDefaults] objectForKey:kMnuboUserTokenTimestampKey];
}

- (void)saveTokens
{
    
    [[PDKeychainBindings sharedKeychainBindings] setString:_accessToken forKey:kMnuboUserAccessTokenKey];
    [[PDKeychainBindings sharedKeychainBindings] setString:_refreshToken forKey:kMnuboUserRefreshTokenKey];
    [[NSUserDefaults standardUserDefaults] setObject:_expiresIn forKey:kMnuboUserExpiresInKey];
    [[NSUserDefaults standardUserDefaults] setObject:_requestedAt forKey:kMnuboUserTokenTimestampKey];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end

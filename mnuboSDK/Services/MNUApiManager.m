//
//  MNUApiManager.m
//
//  Copyright (c) 2016 mnubo. All rights reserved.
//

#import "MNUApiManager.h"
#import "MNUHTTPClient.h"
#import "NSString+mnubo.h"
#import "MNUConstants.h"
#import "PDKeychainBindings.h"
#import "MNUAccessToken.h"



@interface MNUApiManager()

@property (nonatomic, strong) NSString *clientId;
@property (nonatomic, strong) NSString *baseURL;

@property (nonatomic, strong) MNUAccessToken *accessToken;

@end

@implementation MNUApiManager


- (instancetype)initWithClientId:(NSString *)clientId andHostname:(NSString *)hostname {
    self = [super init];
    if (self) {
        _clientId = clientId;
        _baseURL = hostname;

        _accessToken = [[MNUAccessToken alloc] init];
    }
    return self;
}


// Private

- (void)getUserAccessTokenWithUsername:(NSString *)username password:(NSString *)password completion:(void (^)(NSError *error))completion {
    
    
    NSDictionary *headers = @{ @"Content-Type": @"application/x-www-form-urlencoded"};
    NSDictionary *parameters = @{ @"grant_type": @"password", @"client_id": _clientId, @"username": username, @"password": password};
    
    NSString *url = [NSString stringWithFormat:@"%@%@", _baseURL, kTokenPath];
    
    [MNUHTTPClient POST:url headers:headers parameters:parameters body:nil completion:^(NSData *data, NSDictionary *responsesHeaderFields, NSError *error) {
        
         if(!error) {
             id jsonData = data.length > 0 ? [NSJSONSerialization JSONObjectWithData:data options:0 error:&error] : nil;
             if(!error && [jsonData isKindOfClass:[NSDictionary class]]) {
                 _accessToken = [[MNUAccessToken alloc] initWithDictionary:jsonData];
                NSLog(@"User tokens fetched successfully with username/password");
             } else {
                 NSLog(@"Could not parse the authorization result.");
             }
         } else {

             NSLog(@"An error occured while fetching the user tokens with username/password...");
         }
        
         if(completion) completion(error);
     }];
}


- (void)getUserAccessTokenWithRefreshTokenCompletion:(void (^)(NSError *error))completion {
    
    NSDictionary *headers = @{ @"Content-Type": @"application/x-www-form-urlencoded"};
    //TODO Should validate if refreshtoken is not nil
    NSDictionary *parameters = @{ @"grant_type": @"refresh_token", @"client_id": _clientId, @"refresh_token": _accessToken.refreshToken};
    
    NSString *url = [NSString stringWithFormat:@"%@%@", _baseURL, kTokenPath];

    [MNUHTTPClient POST:url headers:headers parameters:parameters body:nil completion:^(NSData *data, NSDictionary *responsesHeaderFields, NSError *error)
     {
         if(!error) {
             id jsonData = data.length > 0 ? [NSJSONSerialization JSONObjectWithData:data options:0 error:&error] : nil;
             if(!error && [jsonData isKindOfClass:[NSDictionary class]]) {
                 _accessToken = [[MNUAccessToken alloc] initWithDictionary:jsonData];
                 NSLog(@"User tokens fetched successfully with refresh token");
             } else {
                 NSLog(@"Could not parse the authorization result.");
             }
         } else {
             //Refresh Token expired
             //TODO Logout the user and redirect to login view
             [[NSNotificationCenter defaultCenter] postNotificationName:kMnuboLoginExpiredKey object:nil];
             
             NSLog(@"An error occured while fetching the user tokens with refresh token...");
         }
         if(completion) completion(error);
     }];
}


- (void)postWithPath:(NSString *)path body:(NSData *)body completion:(void (^)(NSData *data, NSError *error))completion {
    
    if (![_accessToken isValid]) {
        
        [self getUserAccessTokenWithRefreshTokenCompletion:^(NSError *error) {
            
            if (error) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Access Token Invalid, Logout" object:nil];

                if (completion) completion(nil, error);
            } else {
            
                [self postWithPath:path body:body completion:completion];
            }
        }];
    } else {
        
        NSDictionary *headers = @{@"Content-Type": @"application/json", @"Authorization": [NSString stringWithFormat:@"Bearer %@", _accessToken.accessToken]};
        NSString *url = [NSString stringWithFormat:@"%@%@", _baseURL, path];
        
        [MNUHTTPClient POST:url headers:headers parameters:nil body:body completion:^(id data, NSDictionary *responsesHeaderFields, NSError *error) {
            if (completion) completion(data, error);
        }];
    }
}

- (void)putWithPath:(NSString *)path body:(NSData *)body completion:(void (^)(NSData *data, NSError *error))completion {
    
    if (![_accessToken isValid]) {
        
        [self getUserAccessTokenWithRefreshTokenCompletion:^(NSError *error) {
            
            if (error) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Access Token Invalid, Logout" object:nil];
                
                if (completion) completion(nil, error);
            } else {
                
                [self putWithPath:path body:body completion:completion];
            }
        }];
    } else {
        
        NSDictionary *headers = @{@"Content-Type": @"application/json", @"Authorization": [NSString stringWithFormat:@"Bearer %@", _accessToken.accessToken]};
        NSString *url = [NSString stringWithFormat:@"%@%@", _baseURL, path];
        
        [MNUHTTPClient PUT:url headers:headers parameters:nil body:body completion:^(NSData *data, NSDictionary *responsesHeaderFields, NSError *error) {
            if (completion) completion(data, error);
        }];
    }
}

- (BOOL)isOwnerAccessTokenPresent {
    if (_accessToken.accessToken) {
        return YES;
    } else {
        return NO;
    }
}

- (void)removeTokens {
    [_accessToken removeTokens];
}

//------------------------------------------------------------------------------
#pragma mark Helper methods
//------------------------------------------------------------------------------

- (NSDictionary *)generateAuthHeader:(NSString *)accessToken {
    return @{ @"Authorization" : [NSString stringWithFormat:@"Bearer %@", accessToken] };
}


@end

//
//  MNUAccessTokenTests.m
//
//  Copyright © 2016 mnubo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MNUAccessToken.h"
#import "PDKeychainBindings.h"
#import "MNUConstants.h"

@interface MNUAccessTokenTests : XCTestCase

@end


@implementation MNUAccessTokenTests

NSDate *now;
NSDictionary *sampleTokenDict;
MNUAccessToken *sampleToken;

- (void)cleanupPersitedData {
    [[PDKeychainBindings sharedKeychainBindings] setString:nil forKey:kMnuboUserAccessTokenKey];
    [[PDKeychainBindings sharedKeychainBindings] setString:nil forKey:kMnuboUserRefreshTokenKey];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kMnuboUserExpiresInKey];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kMnuboUserTokenTimestampKey];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setUp {
    [super setUp];
    now = [NSDate date];
    sampleTokenDict = @{ @"access_token": @"ACCESS_TOKEN", @"refresh_token": @"REFRESH_TOKEN", @"expires_in": @90 };
    
    sampleToken = [[MNUAccessToken alloc] initWithDictionary:sampleTokenDict andUsername:@"username"];
    sampleToken.requestedAt = now;
    
    XCTAssertEqual(@"ACCESS_TOKEN", sampleToken.accessToken);
    XCTAssertEqual(@"REFRESH_TOKEN", sampleToken.refreshToken);
    XCTAssertEqual(@90, sampleToken.expiresIn);
    XCTAssertEqual(now, sampleToken.requestedAt);
    
    [self cleanupPersitedData];
}

- (void)tearDown {
    now = nil;
    sampleTokenDict = nil;
    sampleToken = nil;
    
    [self cleanupPersitedData];
    
    [super tearDown];
}

- (void)testInitWithEmptyDictionary {
    MNUAccessToken *token = [[MNUAccessToken alloc] initWithDictionary:nil andUsername:nil];
    
    XCTAssertNotNil(token);
    XCTAssertNil(token.username);
    XCTAssertNil(token.accessToken);
    XCTAssertNil(token.refreshToken);
    XCTAssertNil(token.expiresIn);
    XCTAssertNotNil(token.requestedAt);
}


- (void)testRemoveTokens {
    [sampleToken removeTokens];
    
    XCTAssertNil(sampleToken.accessToken);
    XCTAssertNil(sampleToken.refreshToken);
    XCTAssertNil(sampleToken.expiresIn);
    XCTAssertNil(sampleToken.requestedAt);
}

- (void)testIsValid {
    //TODO
}

- (void)testLoadTokens {
    [sampleToken saveTokens];
    
    MNUAccessToken *token = [[MNUAccessToken alloc] initWithDictionary:nil andUsername:nil];
    [token loadTokens];
    
    XCTAssertEqual(@"ACCESS_TOKEN", token.accessToken);
    XCTAssertEqual(@"username", token.username);
    XCTAssertEqual(@"REFRESH_TOKEN", token.refreshToken);
    XCTAssertTrue([token.expiresIn isEqualToNumber:@90]);
    XCTAssertTrue([token.requestedAt isEqual:now]);
}

- (void)testSaveTokens {
    [sampleToken saveTokens];
    
    NSString *accessToken = [[PDKeychainBindings sharedKeychainBindings] stringForKey:kMnuboUserAccessTokenKey];
    NSString *refreshToken = [[PDKeychainBindings sharedKeychainBindings] stringForKey:kMnuboUserRefreshTokenKey];
    NSNumber *expiresIn = [[NSUserDefaults standardUserDefaults] objectForKey:kMnuboUserExpiresInKey];
    NSDate *requestedAt = [[NSUserDefaults standardUserDefaults] objectForKey:kMnuboUserTokenTimestampKey];
    
    XCTAssertEqual(@"ACCESS_TOKEN", accessToken);
    XCTAssertEqual(@"REFRESH_TOKEN", refreshToken);
    XCTAssertTrue([expiresIn isEqualToNumber:@90]);
    XCTAssertTrue([requestedAt isEqual:now]);
    
}

@end

//
//  MNUAccessToken.h
//
//  Copyright (c) 2016 mnubo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNUAccessToken : NSObject

@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *refreshToken;
@property (nonatomic, copy) NSNumber *expiresIn;
@property (nonatomic, copy) NSDate *requestedAt;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (void)removeTokens;
- (BOOL)isValid;
- (void)loadTokens;
- (void)saveTokens;

@end

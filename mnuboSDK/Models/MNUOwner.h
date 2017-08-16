//
//  MNUOwner.h
//
//  Copyright (c) 2016 mnubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNUMacros.h"

@interface MNUOwner : NSObject

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSMutableDictionary* attributes;

- (NSDictionary *)toDictionary;

@end

//
//  MNUSmartObject.h
//
//  Copyright (c) 2016 mnubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNUOwner.h"

@interface MNUSmartObject : NSObject

@property (nonatomic, copy) NSMutableDictionary *attributes;
@property (nonatomic, copy) NSString *deviceId;
@property (nonatomic, copy) NSString *objectType;
@property (nonatomic, copy) MNUOwner *owner;

- (NSDictionary *)toDictionary;

@end

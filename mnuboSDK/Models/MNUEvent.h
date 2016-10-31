//
//  MNUEvent.h
//
//  Copyright (c) 2016 mnubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNUSmartObject.h"
#import "MNUMacros.h"

@interface MNUEvent : NSObject

@property (nonatomic, copy) NSString *eventId;
@property (nonatomic, copy) MNUSmartObject *smartObject;
@property (nonatomic, copy) NSString *eventType;
@property (nonatomic, copy) NSMutableDictionary *timeseries;

- (NSDictionary *)toDictionary;

@end

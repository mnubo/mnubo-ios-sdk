//
//  MNUEvent.m
//
//  Copyright (c) 2016 mnubo. All rights reserved.
//

#import "MNUEvent.h"

@implementation MNUEvent


- (instancetype)init {
    
    self = [super init];
    if (self) {
        _timeseries = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

//------------------------------------------------------------------------------
#pragma mark Helper methods
//------------------------------------------------------------------------------

- (NSDictionary *)toDictionary {
    NSMutableDictionary *attributeDictionary = [NSMutableDictionary dictionary];
    
    SafeSetValueForKey(attributeDictionary, @"event_id", _eventId);
    
    SafeSetValueForKey(attributeDictionary, @"x_event_type", _eventType);

    for (id key in _timeseries)
        SafeSetValueForKey(attributeDictionary, key, [_timeseries objectForKey:key]);
    
    return [NSDictionary dictionaryWithDictionary:attributeDictionary];
}

@end

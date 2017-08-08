//
//  MNUSmartObject.m
//
//  Copyright (c) 2016 mnubo. All rights reserved.
//

#import "MNUSmartObject.h"

@implementation MNUSmartObject

//------------------------------------------------------------------------------
#pragma mark Helper methods
//------------------------------------------------------------------------------
- (instancetype)init {
    
    self = [super init];
    if (self) {
        _attributes = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (NSDictionary *)toDictionary {
    NSMutableDictionary *attributeDictionary = [NSMutableDictionary dictionary];
    
    for (id key in _attributes)
        SafeSetValueForKey(attributeDictionary, key, [_attributes objectForKey:key]);
    
    return [NSDictionary dictionaryWithDictionary:attributeDictionary];
}

@end

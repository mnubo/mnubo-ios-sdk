//
//  MNUOwner.m
//
//  Copyright (c) 2016 mnubo. All rights reserved.
//

#import "MNUOwner.h"

@implementation MNUOwner


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
    
    SafeSetValueForKey(attributeDictionary, @"username", _username);
    SafeSetValueForKey(attributeDictionary, @"x_password", _password);
    
    for (id key in _attributes)
        SafeSetValueForKey(attributeDictionary, key, [_attributes objectForKey:key]);
    
    return [NSDictionary dictionaryWithDictionary:attributeDictionary];
}

@end

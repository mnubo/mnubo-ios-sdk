//
//  MBOError.h
//  SensorLogger
//
//  Created by Hugo Lefrancois on 2014-06-27.
//  Copyright (c) 2014 Mirego. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBOError : NSError

@property(nonatomic, readonly) NSString *mnuboErrorMessage;
@property(nonatomic, readonly) NSInteger mnuboErrorCode;

@end

//
//  MNUMacros.h
//
//  Copyright (c) 2016 mnubo. All rights reserved.
//

#define IsEqualToString(x,y) (([x isEqualToString:y]) || (!x && !y))
#define IsEqualToDate(x,y) (([x isEqualToDate:y]) || (!x && !y))
#define IsEqualToArray(x,y) (([x isEqualToArray:y]) || (!x && !y))
#define IsEqualToDictionary(x,y) (([x isEqualToDictionary:y]) || (!x && !y))
#define IsEqualToNumber(x,y) (([x isEqualToNumber:y]) || (!x && !y))
#define IsEqual(x,y) (([x isEqual:y]) || (!x && !y))

#define SafeSetValueForKey(dict, k, v) if (v) dict[k] = v;

#define MNULog(string, ...) if ([MnuboClient isLoggingEnabled]) NSLog (string, ##__VA_ARGS__)
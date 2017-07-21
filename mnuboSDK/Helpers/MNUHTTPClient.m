//
//  MNUHTTPClient.m
//
//  Copyright (c) 2016 mnubo. All rights reserved.
//

#import "MNUHTTPClient.h"
#import "MNUConstants.h"

@implementation MNUHTTPClient

+ (void)POST:(NSString *)path headers:(NSDictionary *)headers parameters:(NSDictionary *)parameters body:(NSData *)body completion:(void (^)(NSData *data, NSDictionary *responsesHeaderFields, NSError *error))completion {

    NSMutableURLRequest *urlRequest = [self generateRequestWithPath:path method:@"POST" headers:headers parameters:parameters];

    if (body) {
        [urlRequest setHTTPBody:body];
    }

    NSURLSessionDataTask * dataTask =[[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        if (httpResponse.statusCode >= 300) {
            error = [[NSError alloc] initWithDomain:kMnuboDomain code:httpResponse.statusCode userInfo:nil];
            NSString *errorPayload = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"An error occurred: %@", errorPayload);
        }
        
        if (completion) completion(data, httpResponse.allHeaderFields, error);
    }];
    
    [dataTask resume];
}


+ (void)PUT:(NSString *)path headers:(NSDictionary *)headers parameters:(NSDictionary *)parameters body:(NSData *)body completion:(void (^)(NSData *data, NSDictionary *responsesHeaderFields, NSError *error))completion {
    
    NSMutableURLRequest *urlRequest = [self generateRequestWithPath:path method:@"PUT" headers:headers parameters:parameters];
    
    if (body) {
        [urlRequest setHTTPBody:body];
    }
    
    NSURLSessionDataTask * dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;

        if (httpResponse.statusCode >= 300) {
            error = [[NSError alloc] initWithDomain:kMnuboDomain code:httpResponse.statusCode userInfo:nil];
            NSString *errorPayload = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"An error occurred: %@", errorPayload);
        }
        
        if (completion) completion(data, httpResponse.allHeaderFields, error);
    }];
    
    [dataTask resume];
}


+ (void)DELETE:(NSString *)path headers:(NSDictionary *)headers parameters:(NSDictionary *)parameters completion:(void (^)(NSData *, NSDictionary *, NSError *))completion{
    
    NSMutableURLRequest *urlRequest = [self generateRequestWithPath:path method:@"DELETE" headers:headers parameters:parameters];
    
    NSURLSessionDataTask * dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        // NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        if (httpResponse.statusCode >= 300) {
            error = [[NSError alloc] initWithDomain:kMnuboDomain code:httpResponse.statusCode userInfo:nil];
            NSString *errorPayload = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"An error occurred: %@", errorPayload);
        }
        
        if (completion) completion(data, httpResponse.allHeaderFields, error);
    }];
    
    [dataTask resume];
}


//------------------------------------------------------------------------------
#pragma mark Helper methods
//------------------------------------------------------------------------------

+ (NSMutableURLRequest *)generateRequestWithPath:(NSString *)path method:(NSString *)method headers:(NSDictionary *)headers parameters:(NSDictionary *)parameters
{
    NSMutableURLRequest *request;
    
    if ([[headers objectForKey:@"Content-Type"] isEqualToString:@"application/x-www-form-urlencoded"])
    {
        request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:path]];
        NSString *encodedParams = [self encodeParameters:parameters];
        [request setHTTPBody:[encodedParams dataUsingEncoding:NSUTF8StringEncoding]];
    }
    else
    {
        request = [[NSMutableURLRequest alloc] initWithURL:[self encodeURL:path withParameters:parameters]];
    }

    [request setHTTPMethod:method];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [headers enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop)
     {
         [request setValue:value forHTTPHeaderField:key];
     }];

    return request;
}

+ (NSString *)encodeParameters:(NSDictionary *)parameters {
    if (!parameters || [parameters count] < 1) return @"";

    NSMutableArray *encodedParams = [NSMutableArray array];

    NSURLComponents *components = [NSURLComponents init];

    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop)
     {
         [encodedParams addObject:[NSURLQueryItem queryItemWithName:key value:value]];
     }];

    components.queryItems = encodedParams;

    return components.percentEncodedQuery;
}


+ (NSURL *)encodeURL: (NSString *)url withParameters:(NSDictionary *)parameters {
    NSURLComponents *components = [NSURLComponents componentsWithString:url];
    
    if (!parameters || [parameters count] < 1) return components.URL;
    
    NSMutableArray *encodedParams = [NSMutableArray array];
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop)
     {
         [encodedParams addObject:[NSURLQueryItem queryItemWithName:key value:value]];
         
     }];
    
    components.queryItems = encodedParams;
    
    return components.URL;
}

@end

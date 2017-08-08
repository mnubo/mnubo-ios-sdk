//
//  MnuboClient.h
//
//  Copyright (c) 2016 mnubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNUApiManager.h"
#import "MNUSmartObject.h"
#import "MNUEvent.h"
#import "MNUOwner.h"
#import "MNUSupportedIsp.h"

@interface MnuboClient : NSObject

/*!
 @method
 
 @abstract
 Initialize the mnubo client
 
 @param clientId The client id associated with the account
 @param hostname The hostname to connect to the mnubo's platform
 
 @return The shared instance of the mnubo client
 */
+ (MnuboClient *)sharedInstanceWithClientId:(NSString *)clientId andHostname:(NSString *)hostname;

/*!
 @method
 
 @abstract
 Fetch the shared isntance of the mnubo client
 
 @return The shared instance of the mnubo client
 */
+ (MnuboClient *)sharedInstance;

/*!
 @method
 
 @abstract
 Authenticate the mnubo client using a valid username and password (OAuth 2) and save the tokens in the keychain
 
 @param username The username to use for the authentication
 @param password The password to use for the authentication
 @param completion The block called once the action is completed (If and error occured it will be passed via the NSError)
 */
- (void)loginWithUsername:(NSString *)username password:(NSString *)password completion:(void (^)(NSError *error))completion;

/*!
 @method
 
 @abstract
 Return whether or not a user is currently authentication via the mnubo client
 
 @return the authentication state (YES/NO)
 */
- (BOOL)isOwnerConnected;

/*!
 @method
 
 @abstract
 Clear the access tokens for the logged in user, futur actions won't be authenticated
 */
- (void)logout;

// Services
- (void)updateSmartObject:(MNUSmartObject *)smartObject withDeviceId:(NSString *)deviceId;
- (void)createSmartObject:(MNUSmartObject *)smartObject withDeviceId:(NSString *)deviceId withObjectType:(NSString *)objectType;
- (void)deleteSmartObjectWithDeviceId:(NSString *)deviceId;
- (void)updateOwner:(MNUOwner *)owner;
- (void)createOwner:(MNUOwner *)owner withPassword:(NSString *)password;
- (void)deleteOwner;
- (void)sendEvents:(NSArray *)events withDeviceId:(NSString *)deviceId;

/*!
 @method
 
 @abstract
 Update an existing SmartObject on the mnubo's platform
 
 @param smartObject The updated SmartObject
 @param deviceId The deviceId corresponding to that SmartObject
 @param completion The block called once the action is completed (If and error occured it will be passed via the NSError)
 */
- (void)updateSmartObject:(MNUSmartObject *)smartObject withDeviceId:(NSString *)deviceId completion:(void (^)(NSError *error))completion;

/*!
 @method
 
 @abstract
 Create a SmartObject that belongs to the logged in user
 
 @param smartObject The updated SmartObject
 @param deviceId The device id of the SmartObject
 @param objectType The object type of the SmartObject
 @param completion The block called once the action is completed (If and error occured it will be passed via the NSError)
 */
- (void)createSmartObject:(MNUSmartObject *)smartObject withDeviceId:(NSString *)deviceId withObjectType:(NSString *)objectType completion:(void (^)(NSError *error))completion;

/*!
 @method

 @abstract
 Delete a SmartObject that belongs to the logged in user

 @param deviceId The device id of the SmartObject
 @param completion The block called once the action is completed (If and error occured it will be passed via the NSError)
 */
- (void)deleteSmartObjectWithDeviceId:(NSString *)deviceId completion:(void (^)(NSError *error))completion;

/*!
 @method

 @abstract
 Update an existing Owner on the mnubo's platform

 @param owner The updated Owner
 @param completion The block called once the action is completed (If and error occured it will be passed via the NSError)
 */
- (void)updateOwner:(MNUOwner *)owner completion:(void (^)(NSError *error))completion;


/*!
 @method

 @abstract
 Create an owner with a username matching the token retrieved

 @param owner The Owner to create
 @param completion The block called once the action is completed (If and error occured it will be passed via the NSError)
 */
- (void)createOwner:(MNUOwner *)owner withPassword:(NSString *)password  completion:(void (^)(NSError *error))completion;


/*!
 @method

 @abstract
 Delete the owner with a username matching the token retrieved

 @param completion The block called once the action is completed (If and error occured it will be passed via the NSError)
 */
- (void)deleteOwner: (void (^)(NSError *error))completion;

/*!
 @method
 
 @abstract
 Send events to the mnubo's platform. In case of error, an array of NSError is return containing the error for each failled send
 
 @param events An array of Events to be sent to the mnubo's platform
 @param deviceId The deviceId linked to the event
 @param completion The block called once the action is completed (If and error occured it will be passed via the NSError)
 */
- (void)sendEvents:(NSArray *)events withDeviceId:(NSString *)deviceId completion:(void (^)(NSError *error))completion;



@end

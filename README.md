# mnubo iOS SDK

Table of Content
================

[1. Introduction](#section1)

[2. Architecture](#section2)

[3. Pre-requisites](#section3)

[4. Installation & Configuration](#section4)

[5. Usage](#section5)

[6. Important notes](#section6)

[7. Source code](#section7)

[8. Known limitations](#section8)

[9. References](#section9)

---
#<a name="section1"></a>1. Introduction

iOS SDK allowing iOS apps to quickly implement the mnubo REST API.

---
#<a name="section3"></a>2. Architecture

### mnubo

The primary class of the SDK has to be initialized with your mnubo account informations (client id and hostname ). The functions above are available from this class.

* `SDK Management`
  - `sharedInstanceWithClientId:andHostname:`
  - `sharedInstance`

* `Authentication`
  - `logInWithUsername:password:completion:`
  - `logout`
  - `isOwnerConnected`

* `Services`
  - `updateSmartObject:withDeviceId:completion:`
  - `updateOwner:withUsername:completion:`
  - `sendEvents:withDeviceId:completion:`

---
#<a name="section3"></a>3. Pre-requisites

- CocoaPods
- iOS

---
#<a name="section4"></a>4. Installation & Configuration

1. Install [CocoaPods](http://cocoapods.org/) with `gem install cocoapods`.
2. Create a file in your Xcode project called `Podfile` and add the following lines:

    ```ruby
    pod 'mnuboSDK'
    ```

3. Run `pod install` in your xcode project directory. CocoaPods should download and
install the mnubo iOS SDK, and create a new Xcode workspace. Open up this workspace in Xcode.

---
#<a name="section5"></a>5. Usage

### Initialize the MnuboClient

We recommend to use the shared instance of the mnubo SDK in your application and should initialize the SDK as follows in your app delegate:

```objc
#import <mnuboSDK/MnuboClient.h>

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

  [MnuboClient sharedInstanceWithClientId:@"CLIENT_ID" andHostname:@"BASE_URL"];

  return YES
}
```

### Log In an owner

Once an owner is present in the mnubo SmartObjects platform, an authentication can be executed to fetch the owner's access tokens. This login method requires the username and the password of the owner to authenticate.

```objc

[[MnuboClient sharedInstance] loginWithUsername:@"USERNAME" password:@"PASSWORD" completion:^(NSError *error)
{
  if (!error) {
    // The owner is connected and can now use the app
  } else {
    // An error occured while login the owner
  }
}];

```

### Check if an owner is connected

At anytime you can validate if an owner is connected. Simply retrieve a boolean with the help of the isOwnerConnected method.

```objc

// YES if the owner is connected and NO if the owner is not currently connected
BOOL isOwnerConnected = [[MnuboClient sharedInstance] isOwnerConnected];
```

### Log Out an owner

When the owner needs to be logged out, the logout method will clear all of the owner's access tokens. After that operation, the isOwnerConnected method will return NO (false). Access to restricted section of your app should be made unavailable.

```objc
// Log the owner out and clear all the tokens
[[MnuboClient sharedInstance] logout];

```
### Update Owner

You can update an owner properties

```objc

[[MnuboClient sharedInstance] updateOwner:owner withUsername:@"USERNAME" completion:^(NSError *error) {
    if (!error) {
        //Update Successful
    } else {
        //Update failed
    }
}];

```

### Update SmartObject

You can update a SmartObject properties

```objc

[[MnuboClient sharedInstance] updateSmartObject:smartObject withDeviceId:@"DEVICE_ID" completion:^(NSError *error) {
    if (!error) {
        //Update Successful
    } else {
        //Update failed
    }
}];

```

### Send Events

At anytime, you can send custom events.

```objc

MNUEvent *event = [[MNUEvent alloc] init];
event.eventType = @"EVENT_TYPE";
[event setTimeseries: @{ @"KEY": @"VALUE"}];

// Send the event to the mnubo SmartObjects platform by specifying the device_id
[[MnuboClient sharedInstance] sendEvents:@[event] withDeviceId:@"DEVICE_ID" completion:^(NSError *error) {
    if (!error) {
        //Send Successful
    } else {
        //Send failed
    }
}];


```

  ---
#<a name="section6"></a>6. Important notes

Do not forget to listen for the `com.mnubo.sdk.login.expired` notification. This notification will be sent in case the authentication is not able to renew its token. The response to this notification should be to log the user back in via its username/password.


---
#<a name="section7"></a>7. Source code

https://github.com/mnubo/mnubo-ios-sdk/tree/master/Pod/Classes

---
#<a name="section8"></a>8. Known limitations

Search function is not supported at the momment.
Retry mechanism while sending events offline is not supported at the moment.

---
#<a name="section9"></a>9. References

https://en.wikipedia.org/wiki/IOS_SDK

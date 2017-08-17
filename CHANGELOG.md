<a name="2.0.1"></a>
## [2.0.1](https://github.com/mnubo/mnubo-ios-sdk/compare/v2.0.0...v2.0.1) (2017-08-17)

This release is ISO to 2.0.0 but the breaking changes were reverted.

<a name="2.0.0"></a>
## [2.0.0](https://github.com/mnubo/mnubo-ios-sdk/compare/v1.3.2..v2.0.0) (2017-08-08)

### Features
This version of the SDK supports a new authentication flow with Google, Facebook and Microsoft as third parties.
Documentation can be found [here](https://smartobjects.mnubo.com/documentation/api_security.html#third-party-authentication-services-via-sso).

### Models

In `MNUOwner.h`, the breaking changes were:

* `@property (nonatomic, copy) NSString *username;` were removed (get/set)
* `@property (nonatomic, copy) NSString *password;` were removed (get/set)

In MNUSmartObject.h`, the breaking changes were:
* `@property (nonatomic, copy) NSString *deviceId;` were removed (get/set)
* `@property (nonatomic, copy) NSString *objectType;` were removed (get/set)
* `@property (nonatomic, copy) MNUOwner *owner;` were removed (get/set)


### Operations

The breaking changes were in `MnuboClient.h`:
* `(void)updateOwner:(MNUOwner *)owner withUsername:(NSString *)username;` to `(void)updateOwner:(MNUOwner *)owner;`

<a name="1.3.2"></a>
## [1.3.2](https://github.com/mnubo/mnubo-ios-sdk/compare/1.3.1...v1.3.2) (2016-11-01)


### Bug Fixes

* **callbacks:** add callback on mnubo client methods ([4998f71](https://github.com/mnubo/mnubo-ios-sdk/commit/4998f71))
* **completion:** keep the data around for the callback in PUT ([c441032](https://github.com/mnubo/mnubo-ios-sdk/commit/c441032))
* **completion:** updated completion handlers for sendEvents, updateOwner and updateObject ([b1013ed](https://github.com/mnubo/mnubo-ios-sdk/commit/b1013ed))
* **json:** send the payload directly to the MnuboHTTPClient ([ee9359d](https://github.com/mnubo/mnubo-ios-sdk/commit/ee9359d))
* **podfile:** Fix the source files path for the new structure ([dd82c10](https://github.com/mnubo/mnubo-ios-sdk/commit/dd82c10))
* **session:** use the session so that we can test the SDK ([e9b13a3](https://github.com/mnubo/mnubo-ios-sdk/commit/e9b13a3))
* **statusCode:** invalid handling with response status ([d678740](https://github.com/mnubo/mnubo-ios-sdk/commit/d678740))


### Features

* **changelog:** add package.json to allow generation of changelog ([c3f2748](https://github.com/mnubo/mnubo-ios-sdk/commit/c3f2748))



<a name="1.3.1"></a>

# 1.3.1 (2016-10-17)

### Bug fixes

* remove NSDate from Owner, Object and Event

<a name="1.3.0"></a>

# 1.3.0 (2016-10-17)

### Features

* modified .podspec that changes in the way files are fetched by CocoaPods

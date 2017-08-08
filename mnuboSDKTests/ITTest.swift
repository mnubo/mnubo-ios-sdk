//  Created by david francoeur on 2016-10-25.
//  Copyright © 2017 mnubo. All rights reserved.
//

import XCTest

class ITTest: XCTestCase {

    var mnuboTestUtil: MnuboTestUtil?
    var mnuboClient: MnuboClient?

    override func setUp() {
        if mnuboTestUtil == nil {
            do {
                mnuboTestUtil = try MnuboTestUtil();
                mnuboClient = MnuboClient.sharedInstance(
                    withClientId: "TTtFCVUySo1cpGMm1WhiyugtbF8pVb8BhHyIy6UaOct1O2vpBu",
                    andHostname: "https://sandbox.api.mnubo.com"
                )
                let semaphore = DispatchSemaphore.init(value: 0)
                mnuboClient!.login(
                    withUsername: mnuboTestUtil?.username,
                    password: mnuboTestUtil?.password,
                    completion:{ error in
                        if error != nil {
                            print("Login failed: \(error!)")
                        }
                        semaphore.signal()
                })

                _ = semaphore.wait(timeout: DispatchTime.distantFuture)
            } catch {
                print("An error occurred: \(error)")
            }
        }
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSendEvents() {
        XCTAssertNotNil(mnuboTestUtil, "initialization failed")
        XCTAssertNotNil(mnuboClient, "initialization failed")

        let event1 = MNUEvent.init()
        let event1Id = UUID().uuidString
        event1.eventType = mnuboTestUtil?.eventType
        let value1 = "value-" + UUID().uuidString
        event1.timeseries = [
            "event_id": event1Id,
            "ts_text_attribute": value1
        ];

        let event2 = MNUEvent.init()
        let event2Id = UUID().uuidString
        event2.eventType = mnuboTestUtil?.eventType
        let value2 = "value-" + UUID().uuidString
        event2.timeseries = [
            "event_id": event2Id,
            "ts_text_attribute": value2
        ];

        let asyncExpectation = expectation(description: "sending events")

        mnuboClient!.sendEvents(
            [
                event1,
                event2
            ],
            withDeviceId: mnuboTestUtil!.deviceId
        ){ (error) in
            XCTAssertNil(error, "Something went horribly wrong")
            asyncExpectation.fulfill()
        }

        self.waitForExpectations(timeout: 15, handler: { error in
            XCTAssertNil(error, "Something went horribly wrong")
        })
    }

    func testUpdateOwner() {
        XCTAssertNotNil(mnuboTestUtil, "initialization failed")
        XCTAssertNotNil(mnuboClient, "initialization failed")

        let owner = MNUOwner.init()
        let value = "value-" + UUID().uuidString
        owner.attributes = [
            "owner_text_attribute": value,
            "x_registration_date": Date().iso8601
        ];

        let asyncExpectation = expectation(description: "update owner")

        mnuboClient!.update(
            owner
        ) { (error) in
            XCTAssertNil(error, "Something went horribly wrong")
            asyncExpectation.fulfill()
        }

        self.waitForExpectations(timeout: 15, handler: { error in
            XCTAssertNil(error, "Something went horribly wrong")
        })
    }

    func testUpdateObject() {
        XCTAssertNotNil(mnuboTestUtil, "initialization failed")
        XCTAssertNotNil(mnuboClient, "initialization failed")

        let object = MNUSmartObject.init()
        let value = "value-" + UUID().uuidString
        object.attributes = [
            "object_text_attribute": value,
            "x_registration_date": Date().iso8601
        ];

        let asyncExpectation = expectation(description: "update object")

        mnuboClient!.update(
            object,
            withDeviceId: mnuboTestUtil?.deviceId
        ) { (error) in
            XCTAssertNil(error, "Something went horribly wrong")
            asyncExpectation.fulfill()
        }

        self.waitForExpectations(timeout: 15, handler: { error in
            XCTAssertNil(error, "Something went horribly wrong")
        })
    }
}

class MnuboTestUtil {
    let objectType = "object_type1"
    let eventType = "event_type1"
    let username: String;
    let password: String;
    let deviceId: String;

    let mnuboHttpUtil: MnuboHttpUtil

    init() throws {
        let cKey: String = ProcessInfo.processInfo.environment["CONSUMER_KEY"]!
        let cSecret: String = ProcessInfo.processInfo.environment["CONSUMER_SECRET"]!
        mnuboHttpUtil = try MnuboHttpUtil(
            consumerKey: cKey,
            consumerSecret: cSecret
        )

        username = "username-" + UUID().uuidString
        password = "password-" + UUID().uuidString
        deviceId = "device-" + UUID().uuidString

        try mnuboHttpUtil.createOwner(username: username, password: password)
        try mnuboHttpUtil.createObject(deviceId: deviceId, objectType: objectType)
        try mnuboHttpUtil.claim(deviceId: deviceId, username: username)
    }
}

enum MnuboHttpUtilError: Error {
    case httpError(message: String)
    case parseError(message: String)
}

class MnuboHttpUtil {
    let hostname: String = "https://sandbox.api.mnubo.com"
    let accessToken: String

    init(consumerKey: String, consumerSecret: String) throws {
        let loginString = String(format: "%@:%@", consumerKey, consumerSecret)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        let headers: [(String, String)] = [
            ("Authorization", "Basic \(base64LoginString)")
        ];
        let postString = "grant_type=client_credentials&scope=ALL"
        let result = try MnuboHttpUtil.synchronousRequest(urlString: hostname + "/oauth/token", method: "POST", headers: headers, data: postString.data(using: .utf8))
        accessToken = result!["access_token"] as! String
    }

    func createOwner(username: String, password: String) throws {
        let url = hostname + "/api/v3/owners"
        let data = try JSONSerialization.data(
            withJSONObject: [
                "username": username,
                "x_password": password
            ],
            options: .prettyPrinted
        )
        let headers = [
            ("Authorization", "Bearer \(accessToken)"),
            ("Content-Type", "application/json")
        ]
        _ = try MnuboHttpUtil.synchronousRequest(urlString: url, method: "POST", headers: headers, data: data)
    }

    func createObject(deviceId: String, objectType: String) throws {
        let url = hostname + "/api/v3/objects"
        let data = try JSONSerialization.data(
            withJSONObject: [
                "x_device_id": deviceId,
                "x_object_type": objectType
            ],
            options: .prettyPrinted
        )
        let headers = [
            ("Authorization", "Bearer \(accessToken)"),
            ("Content-Type", "application/json")
        ]
        _ = try MnuboHttpUtil.synchronousRequest(urlString: url, method: "POST", headers: headers, data: data)
    }

    func claim(deviceId: String, username: String) throws {
        let url = hostname + "/api/v3/owners/\(username)/objects/\(deviceId)/claim"
        let headers = [
            ("Authorization", "Bearer \(accessToken)"),
            ("Content-Type", "application/json")
        ]
        _ = try MnuboHttpUtil.synchronousRequest(urlString: url, method: "POST", headers: headers, data: nil)
    }

    static func synchronousRequest(urlString: String, method: String, headers: [(String, String)], data: Data?) throws -> [String:Any]? {
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = method
        for (headerKey, headerValue) in headers {
            request.setValue(headerValue, forHTTPHeaderField: headerKey)
        }
        request.httpBody = data
        let semaphore = DispatchSemaphore.init(value: 0)

        var maybeResult: [String:Any]?
        var maybeError: Error?

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                maybeError = error
                _ = semaphore.signal()
                return
            }
            guard let resp = response as? HTTPURLResponse, MnuboHttpUtil.isSuccess(maybeResp: resp) else {
                let httpStatus = (response as? HTTPURLResponse)?.statusCode
                maybeError = MnuboHttpUtilError.httpError(message: "Response has unexpected status code \(httpStatus!)")
                _ = semaphore.signal()
                return
            }

            do {
                maybeResult = data.count > 0 ? try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any] : nil
            } catch let error as NSError {
                print(error)
                maybeError = MnuboHttpUtilError.parseError(message: "unable to parse error")
            }
            _ = semaphore.signal()
        }
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)

        guard maybeError == nil else {
            throw maybeError!
        }

        return maybeResult
    }

    static func isSuccess(maybeResp: HTTPURLResponse?) -> Bool {
        if let resp = maybeResp {
            return resp.statusCode >= 200 && resp.statusCode < 300
        } else {
            return false
        }
    }
}

extension Date {
    struct Formatter {
        static let iso8601: DateFormatter = {
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .iso8601)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
            return formatter
        }()
    }
    var iso8601: String {
        return Formatter.iso8601.string(from: self)
    }
}


extension String {
    var dateFromISO8601: Date? {
        return Date.Formatter.iso8601.date(from: self)
    }
}

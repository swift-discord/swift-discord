//
//  RESTErrorTests.swift
//  
//
//  Created by Mina Her on 2022/07/27.
//

import _DiscordTestSupport

@testable
import DiscordRESTModel

final class RESTErrorTests: XCTestCase {

    func testDecodingArrayError() throws {
        let exampleResponse =
            """
            {
                "code": 50035,
                "errors": {
                    "activities": {
                        "0": {
                            "platform": {
                                "_errors": [
                                    {
                                        "code": "BASE_TYPE_CHOICES",
                                        "message": "Value must be one of ('desktop', 'android', 'ios')."
                                    }
                                ]
                            },
                            "type": {
                                "_errors": [
                                    {
                                        "code": "BASE_TYPE_CHOICES",
                                        "message": "Value must be one of (0, 1, 2, 3, 4, 5)."
                                    }
                                ]
                            }
                        }
                    }
                },
                "message": "Invalid Form Body"
            }
            """
            .data(using: .utf8)!
        let jsonDecoder = JSONDecoder.discord
        let error = try jsonDecoder.decode(RESTError.self, from: exampleResponse)
        XCTAssertEqual(error.code, .intValue(50035))
        do {
            XCTAssertEqual(error.errors.count, 1)
            let error = error.errors[0]
            if case .keyedErrors(key: let key, errors: let errors) = error {
                XCTAssertEqual(key, "activities")
                XCTAssertEqual(errors.count, 1)
                if case .errors(errors: let errors) = errors[0] {
                    var assertPlatformFlag = false
                    var assertTypeFlag = false
                    for error in errors {
                        if case .keyedUnderlyingErrors(let key, let errors) = error {
                            func assertPlatform() {
                                XCTAssertEqual(key, "platform")
                                XCTAssertEqual(errors.count, 1)
                                XCTAssertEqual(errors[0].code, .stringValue("BASE_TYPE_CHOICES"))
                                XCTAssertEqual(errors[0].message, "Value must be one of ('desktop', 'android', 'ios').")
                                assertPlatformFlag = true
                            }
                            func assertType() {
                                XCTAssertEqual(key, "type")
                                XCTAssertEqual(errors.count, 1)
                                XCTAssertEqual(errors[0].code, .stringValue("BASE_TYPE_CHOICES"))
                                XCTAssertEqual(errors[0].message, "Value must be one of (0, 1, 2, 3, 4, 5).")
                                assertTypeFlag = true
                            }
                            if key == "platform" {
                                assertPlatform()
                            } else if key == "type" {
                                assertType()
                            } else {
                                XCTFail("\(key) is not equal to platform or type")
                            }
                        } else {
                            XCTFail("case for error does not match to keyedUnderlyingErrors(key:_:)")
                        }
                    }
                    if !assertPlatformFlag {
                        XCTFail("assertPlatform() did not called")
                    }
                    if !assertTypeFlag {
                        XCTFail("assertType() did not called")
                    }
                } else {
                    XCTFail("case for errors[0] does not match to errors(errors:)")
                }
            } else {
                XCTFail("case for error does not match to keyedErrors(key:errors:)")
            }
        }
        XCTAssertEqual(error.message, "Invalid Form Body")
    }

    func testDecodingObjectError() throws {
        let exampleResponse =
            """
            {
                "code": 50035,
                "errors": {
                    "access_token": {
                        "_errors": [
                            {
                                "code": "BASE_TYPE_REQUIRED",
                                "message": "This field is required"
                            }
                        ]
                    }
                },
                "message": "Invalid Form Body"
            }
            """
            .data(using: .utf8)!
        let jsonDecoder = JSONDecoder.discord
        let error = try jsonDecoder.decode(RESTError.self, from: exampleResponse)
        XCTAssertEqual(error.code, .intValue(50035))
        do {
            XCTAssertEqual(error.errors.count, 1)
            let error = error.errors[0]
            if case .keyedUnderlyingErrors(key: let key, let errors) = error {
                XCTAssertEqual(key, "accessToken")
                XCTAssertEqual(errors.count, 1)
                XCTAssertEqual(errors[0].code, .stringValue("BASE_TYPE_REQUIRED"))
                XCTAssertEqual(errors[0].message, "This field is required")
            } else {
                XCTFail("case for error does not match to keyedUnderlyingErrors(key:_:)")
            }
        }
        XCTAssertEqual(error.message, "Invalid Form Body")
    }

    func testDecodingRequestError() throws {
        let exampleResponse =
            """
            {
                "code": 50035,
                "message": "Invalid Form Body",
                "errors": {
                    "_errors": [
                        {
                            "code": "APPLICATION_COMMAND_TOO_LARGE",
                            "message": "Command exceeds maximum size (4000)"
                        }
                    ]
                }
            }
            """
            .data(using: .utf8)!
        let jsonDecoder = JSONDecoder.discord
        let error = try jsonDecoder.decode(RESTError.self, from: exampleResponse)
        XCTAssertEqual(error.code, .intValue(50035))
        do {
            XCTAssertEqual(error.errors.count, 1)
            let error = error.errors[0]
            if case .underlyingErrors(let errors) = error {
                XCTAssertEqual(errors.count, 1)
                XCTAssertEqual(errors[0].code, .stringValue("APPLICATION_COMMAND_TOO_LARGE"))
                XCTAssertEqual(errors[0].message, "Command exceeds maximum size (4000)")
            } else {
                XCTFail("case for error does not match to underlyingErrors(_:)")
            }
        }
        XCTAssertEqual(error.message, "Invalid Form Body")
    }
}

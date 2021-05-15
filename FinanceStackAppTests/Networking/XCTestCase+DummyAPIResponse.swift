//
//  XCTestCase+DummyAPIResponse.swift
//  FinanceStackAppTests
//
//  Created by RN on 15/05/21.
//

import XCTest

extension XCTestCase {

    var anyData: Data {
        return Data(count: 10)
    }

    var anyURL: URL {
        return URL(string: "http://www.dummyUrl.com")!
    }

    var anyResponse: HTTPURLResponse {
        return anyResponse(code: 200)
    }

    var errorResponse: HTTPURLResponse {
        return HTTPURLResponse(url: anyURL, statusCode: 400, httpVersion: nil, headerFields: nil)!
    }

    var anyError: NSError {
        return NSError(domain: "Some Error", code: 1, userInfo: nil)
    }

    func anyResponse(code: Int) -> HTTPURLResponse {
        return HTTPURLResponse(url: anyURL, statusCode: code, httpVersion: nil, headerFields: nil)!
    }
}

//
//  APIManagerTests.swift
//  FinanceStackAppTests
//
//  Created by RN on 15/05/21.
//

import XCTest
import FinanceStackApp

/*sut.makeAPICall(apiConfiguration: apiConfiguration) { (result: Result<String, APIError>) in

 }*/
class APIManagerTests: XCTestCase {

    override func setUp() {
        URLProtocolSpy.startInterceptingRequest()
    }

    override func tearDown() {
        URLProtocolSpy.stopInterceptingRequest()
    }
    
    func test_init_doesNotCallAPI() {
        var capturedMessages = 0
        URLProtocolSpy.observer = { _ in
            capturedMessages += 1
        }
        let _ = makeSUT()
        XCTAssertEqual(capturedMessages, 0, "Expected No API Calls to be made but got \(capturedMessages) instead")
    }

    func test_makeAPICall_shouldMakeAPICallOnlyOnce() {
        var capturedMessages = 0
        URLProtocolSpy.observer = { _ in
            capturedMessages += 1
        }
        let sut = makeSUT()
        let exp = expectation(description: "Wait for api call")
        sut.makeAPICall(apiConfiguration: apiConfiguration) { (result: Result<String, APIError>) in
            exp.fulfill()
         }
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(capturedMessages, 1, "Expected No API Calls to be made but for \(capturedMessages) instead")
    }

    func test_makeAPICall_shouldMakeAPICallMultipleTimesOnCallingMultipleAPI() {
        var capturedMessages = 0
        URLProtocolSpy.observer = { _ in
            capturedMessages += 1
        }
        let sut = makeSUT()
        let exp = expectation(description: "Wait for api call")
        exp.expectedFulfillmentCount = 2
        sut.makeAPICall(apiConfiguration: apiConfiguration) { (result: Result<String, APIError>) in
            exp.fulfill()
        }
        sut.makeAPICall(apiConfiguration: apiConfiguration) { (result: Result<String, APIError>) in
            exp.fulfill()
         }
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(capturedMessages, 2, "Expected No API Calls to be made but for \(capturedMessages) instead")
    }

    func test_makeAPICall_shouldMakeAPICallWithCorrectRequest() throws {
        var capturedRequest: URLRequest?
        URLProtocolSpy.observer = { request in
            capturedRequest = request
        }
        let sut = makeSUT()
        let exp = expectation(description: "Wait for api call")
        let stubbedConfiguration = apiConfiguration
        sut.makeAPICall(apiConfiguration: stubbedConfiguration) { (result: Result<String, APIError>) in
            exp.fulfill()
         }
        wait(for: [exp], timeout: 1)
        let request = try XCTUnwrap(capturedRequest)

        XCTAssertEqual(request.url, stubbedConfiguration.getUrl(), "Expected correct url to be called from configuration but got \(String(describing: request.url)) isntead")

        XCTAssertEqual(request.httpMethod, stubbedConfiguration.requestType.rawValue, "Expected correct requestType to be called from configuration but got \(String(describing: request.httpMethod)) instead")
    }

    func test_makeAPICall_shouldMakeAPICallWithCorrectRequestHeaders() throws {
        var capturedRequest: URLRequest?
        URLProtocolSpy.observer = { request in
            capturedRequest = request
        }
        let sut = makeSUT()
        let exp = expectation(description: "Wait for api call")
        var stubbedConfiguration = apiConfiguration
        stubbedConfiguration.headers = dummyParams
        sut.makeAPICall(apiConfiguration: stubbedConfiguration) { (result: Result<String, APIError>) in
            exp.fulfill()
         }
        wait(for: [exp], timeout: 1)
        let request = try XCTUnwrap(capturedRequest)

        let headers = stubbedConfiguration.getHeaders()! // force unwrapping this as its the correct expectation
        let keys = Array(headers.keys)
        for key in keys {
            XCTAssertEqual(request.allHTTPHeaderFields?[key], headers[key], "Expected correct header \(key) to be called from configuration but got \(String(describing: request.allHTTPHeaderFields?[key])) instead")
        }
    }

    func test_makeAPICall_shouldMakeAPICallWithCorrectGETRequestParams() throws {
        var capturedRequest: URLRequest?
        URLProtocolSpy.observer = { request in
            capturedRequest = request
        }
        let sut = makeSUT()
        let exp = expectation(description: "Wait for api call")
        var stubbedConfiguration = apiConfiguration

        let dummyKey = "dummyKey"
        let dummyValue = "dummyValue"
        stubbedConfiguration.getParms = [dummyKey: dummyValue]

        sut.makeAPICall(apiConfiguration: stubbedConfiguration) { (result: Result<String, APIError>) in
            exp.fulfill()
         }
        wait(for: [exp], timeout: 1)
        let request = try XCTUnwrap(capturedRequest)

        XCTAssertEqual(request.url, stubbedConfiguration.url.append(key: dummyKey, value: dummyValue), "Expected GetParams to be passed with url but got \(String(describing: request.url)) instead")

    }

    func test_makeAPICall_returnFailureOnInvalidStatusCodes() {
        let sut = makeSUT()
        let stubbedConfiguration = apiConfiguration
        let invalidCodes: [Int] = [199, 101, 400, 401, 500]
        for code in invalidCodes {
            let exp = expectation(description: "Wait for api call")
            URLProtocolSpy.stubRequest(data: nil, response: anyResponse(code: code), error: nil)
            sut.makeAPICall(apiConfiguration: stubbedConfiguration) { (result: Result<String, APIError>) in
                switch result {
                case .success(_):
                    XCTFail("Expected failure but got success instead")
                case let .failure(error):
                    XCTAssertNotNil(error, "Expected error to not be nil but got \(error) instead")
                }
                exp.fulfill()
             }
            wait(for: [exp], timeout: 1)
        }
    }

    func test_makeAPICall_returnFailureWithInValidDataOnValidStatusCodes() {
        let sut = makeSUT()
        let stubbedConfiguration = apiConfiguration
        let exp = expectation(description: "Wait for api call")
        let invalidJSONResponse = "dummyResponse"
        URLProtocolSpy.stubRequest(data: invalidJSONResponse.data(using: .utf8), response: anyResponse, error: nil)
        sut.makeAPICall(apiConfiguration: stubbedConfiguration) { (result: Result<String, APIError>) in
            switch result {
            case let .success(response):
                XCTFail("Expected failure with invalid response but got \(response) instead")
            case let .failure(error):
                XCTAssertEqual(error.message, ApiConstants.parsingError, "Expected parsing error but got \(error.message) instead")
            }
            exp.fulfill()
         }
        wait(for: [exp], timeout: 2)

    }

    func test_makeAPICall_returnSuccessWithValidDataOnValidStatusCodes() {
        let sut = makeSUT()
        let stubbedConfiguration = apiConfiguration
        let exp = expectation(description: "Wait for api call")
        let validDummyResponse = DummyResponse()
        URLProtocolSpy.stubRequest(data: validDummyResponse.getData(), response: anyResponse, error: nil)
        sut.makeAPICall(apiConfiguration: stubbedConfiguration) { (result: Result<DummyResponse, APIError>) in
            switch result {
            case let .success(response):
                XCTAssertEqual(response, validDummyResponse, "Expected valid correct response from api but got \(response) instead")
            case let .failure(error):
                XCTFail("Expected success with valid response but got failure with error: \(error) instead")            }
            exp.fulfill()
         }
        wait(for: [exp], timeout: 2)

    }

    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> APIManagerInput {
        let apiManager = APIManager()
        testMemoryLeak(value: apiManager, file: file, line: line)
        return apiManager
    }

    private struct StubDummyAPIConfiguration: APIConfiguration {
        var getParms: [String : String?]?
        var headers: [String : String]?
        var url: URL = URL(string: "http://www.google.com")!
        var requestType: RequestType = .GET
        var timeout: TimeInterval = 15
        var postParms: [String : Any?]?

        func getGetParams() -> [String : String?]? {
            return getParms
        }

        func getHeaders() -> [String : String]? {
            return headers
        }

        func getUrl() -> URL {
            return url
        }

        func getRequestType() -> RequestType {
            return requestType
        }

        func getRequestTimeout() -> TimeInterval {
            return timeout
        }

        func getPostParams() -> [String : Any?]? {
            return postParms
        }
    }

    private var apiConfiguration: StubDummyAPIConfiguration {
        return StubDummyAPIConfiguration()
    }

    private var dummyParams: [String: String] {
        var dict: [String: String] = [:]
        dict["dummyParam"] = "dummyValue"
        return dict
    }

    private struct DummyResponse: Codable, Equatable {
        var key = "dummyResponseKey"

        func getData() -> Data {
            return try! JSONEncoder().encode(self)
        }
    }

}

fileprivate extension URL {
    func append(key: String, value: String) -> URL {
        let string = self.absoluteString
        let modifiedURLString = "\(string)?\(key)=\(value)"
        return URL(string: modifiedURLString)!
    }
}

//
//  StockClientTests.swift
//  FinanceStackAppTests
//
//  Created by RN on 14/05/21.
//

import XCTest
import RxSwift

@testable import FinanceStackApp

class StockClientTests: XCTestCase {

    func test_init_shouldNotMakeAPICall() {
        let sut = makeSUT()
        XCTAssertTrue(sut.apiManager.messageCount == 0, "Expected No api calls on initialization but got \(sut.apiManager.messageCount) instead")
    }

    func test_fetchStockList_shouldCallAPIManager() {
        let sut = makeSUT()
        let single = sut.client.fetchStockListFromAPI()
        let _ = SingleSpy(single)

        XCTAssertTrue(sut.apiManager.messageCount == 1, "Expected 1 api call on calling fetchtockLit method but got \(sut.apiManager.messageCount) instead")
    }

    func test_fetchStockList_shouldCallAPIManagerMultipleTimesOnMutipleCalls() {
        let sut = makeSUT()
        let _ = SingleSpy(sut.client.fetchStockListFromAPI())
        let _ = SingleSpy(sut.client.fetchStockListFromAPI())

        XCTAssertTrue(sut.apiManager.messageCount == 2, "Expected 2 api call on calling fetchtockLit method but got \(sut.apiManager.messageCount) instead")
    }

    func test_fetchStockList_shouldPassCorrectConfigurationToAPI() throws {
        let sut = makeSUT()
        let _ = SingleSpy(sut.client.fetchStockListFromAPI())

        let configuration = try XCTUnwrap(sut.apiManager.messages.first)
        XCTAssertTrue(configuration.getUrl() == StockListAPIConstants.rapidAPIURL)
        XCTAssertTrue(configuration.getRequestType() == .GET)
        XCTAssertTrue(configuration.getHeaders() == apiHeaders)
        XCTAssertTrue(configuration.getGetParams() == getParams)
        XCTAssertTrue(configuration.getRequestTimeout() == StockListAPIConstants.rapidAPITimeout)
    }

    func test_fetchStockList_shouldPassFailure_OnAPIFailure() {
        let sut = makeSUT()
        sut.apiManager.failureError = anyAPIError
        let singleSpy = SingleSpy(sut.client.fetchStockListFromAPI())
        XCTAssertEqual(singleSpy.errorResults, [anyAPIError], "Expected client to fail with error on failure but got \(singleSpy.errorResults) instead")
    }

    func test_fetchStockList_shouldPassSuccessMessage_onSuccess() {
        let sut = makeSUT()
        sut.apiManager.successResults = stockListResponse
        let singleSpy = SingleSpy(sut.client.fetchStockListFromAPI())
        XCTAssertEqual(singleSpy.successResults, [stockListResponse.marketSummaryAndSparkResponse.result], "Expected client to success with response but got \(singleSpy.successResults) instead")
    }

    func test_fetchStockList_shouldPassSuccessMessage_onEmptyResponse() {
        let sut = makeSUT()
        sut.apiManager.successResults = emptyStockListResponse
        let singleSpy = SingleSpy(sut.client.fetchStockListFromAPI())
        XCTAssertEqual(singleSpy.successResults, [[]], "Expected client to success with empty response but got \(singleSpy.successResults) instead")
    }


    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (client: StockClient, apiManager: APIManagerSpy){
        let apiManager = APIManagerSpy()
        let stockClient = StockClient(apiManagerInput: apiManager)
        testMemoryLeak(value: apiManager, file: file, line: line)
        testMemoryLeak(value: stockClient, file: file, line: line)
        return (client: stockClient, apiManager: apiManager)
    }

    private class SingleSpy {

        let disposeBag = DisposeBag()
        var successResults: [StockListClient.Result] = []
        var errorResults: [APIError] = []

        init(_ single: Single<StockListClient.Result>) {
            single.subscribe {[weak self] models in
                self?.successResults.append(models)
            } onFailure: {[weak self] error in
                self?.errorResults.append(error as! APIError) // force unwrapping as it should crash on test run if incorrect
            }
            .disposed(by: disposeBag)

        }
    }
    private class APIManagerSpy: APIManagerInput {

        var messages: [APIConfiguration] = []
        var failureError: APIError?
        var successResults: StockListResponse?

        var messageCount: Int {
            return messages.count
        }

        func makeAPICall<T>(apiConfiguration: APIConfiguration,
                            completion: @escaping (Result<T, APIError>) -> Void) {
            messages.append(apiConfiguration)
            if let error = failureError {
                completion(.failure(error))
            }
            if let response = successResults {
                completion(.success(response as! T)) // force unwrapping as it should crash if expectation is wrong in tests
            }
        }
    }

    private var apiHeaders: [String: String] {
        var dict: [String: String] = [:]
        dict[StockListAPIConstants.rapidAPIKey] = StockListAPIConstants.rapidAPIKeyValue
        dict[StockListAPIConstants.rapidAPIHost] = StockListAPIConstants.rapidAPIHostValue
        return dict
    }

    private var getParams: [String: String] {
        var dict: [String: String] = [:]
        dict[StockListAPIConstants.regionKey] = StockListAPIConstants.regionValue
        return dict
    }

    private var anyAPIError: APIError {
        return APIError(message: "Any Error Message")
    }

}

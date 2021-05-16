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

    typealias SingleListSpy = SingleSpy<StockLisAPIClient.Result>
    typealias StockDetailAPIManagerSpy = APIManagerSpy<StockListResponse>

    func test_init_shouldNotMakeAPICall() {
        let sut = makeSUT()
        XCTAssertTrue(sut.apiManager.messageCount == 0, "Expected No api calls on initialization but got \(sut.apiManager.messageCount) instead")
    }

    func test_fetchStockList_shouldCallAPIManager() {
        let sut = makeSUT()
        let single = sut.client.fetchStockListFromAPI()
        let _ = SingleListSpy(single)

        XCTAssertTrue(sut.apiManager.messageCount == 1, "Expected 1 api call on calling fetchtStockList method but got \(sut.apiManager.messageCount) instead")
    }

    func test_fetchStockList_shouldCallAPIManagerMultipleTimesOnMutipleCalls() {
        let sut = makeSUT()
        let _ = SingleListSpy(sut.client.fetchStockListFromAPI())
        let _ = SingleListSpy(sut.client.fetchStockListFromAPI())

        XCTAssertTrue(sut.apiManager.messageCount == 2, "Expected 2 api call on calling fetchtStockList method but got \(sut.apiManager.messageCount) instead")
    }

    func test_fetchStockList_shouldPassCorrectConfigurationToAPI() throws {
        let sut = makeSUT()
        let _ = SingleListSpy(sut.client.fetchStockListFromAPI())

        let configuration = try XCTUnwrap(sut.apiManager.messages.first)
        XCTAssertTrue(configuration.getUrl() == StockListAPIConstants.rapidAPIURL)
        XCTAssertTrue(configuration.getRequestType() == .GET)
        XCTAssertTrue(configuration.getHeaders() == apiHeaders)
        XCTAssertTrue(configuration.getGetParams() == getParams)
        XCTAssertTrue(configuration.getRequestTimeout() == StockAPIConstants.rapidAPITimeout)
    }

    func test_fetchStockList_shouldPassFailure_OnAPIFailure() {
        let sut = makeSUT()
        sut.apiManager.failureError = anyAPIError
        let singleSpy = SingleListSpy(sut.client.fetchStockListFromAPI())
        XCTAssertEqual(singleSpy.errorResults, [anyAPIError], "Expected client to fail with error on failure but got \(singleSpy.errorResults) instead")
    }

    func test_fetchStockList_shouldPassSuccessMessage_onSuccess() {
        let sut = makeSUT()
        sut.apiManager.successResults = stockListResponse
        let singleSpy = SingleListSpy(sut.client.fetchStockListFromAPI())
        XCTAssertEqual(singleSpy.successResults, [stockListResponse.marketSummaryAndSparkResponse.result], "Expected client to success with response but got \(singleSpy.successResults) instead")
    }

    func test_fetchStockList_shouldPassSuccessMessage_onEmptyResponse() {
        let sut = makeSUT()
        sut.apiManager.successResults = emptyStockListResponse
        let singleSpy = SingleListSpy(sut.client.fetchStockListFromAPI())
        XCTAssertEqual(singleSpy.successResults, [[]], "Expected client to success with empty response but got \(singleSpy.successResults) instead")
    }


    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (client: StockLisAPIClient, apiManager: StockDetailAPIManagerSpy){
        let apiManager = StockDetailAPIManagerSpy()
        let stockClient = StockLisAPIClient(apiManagerInput: apiManager)
        testMemoryLeak(value: apiManager, file: file, line: line)
        testMemoryLeak(value: stockClient, file: file, line: line)
        return (client: stockClient, apiManager: apiManager)
    }

    private var getParams: [String: String] {
        var dict: [String: String] = [:]
        dict[StockListAPIConstants.regionKey] = StockListAPIConstants.regionValue
        return dict
    }
}

//
//  StockDetailAPIClientTests.swift
//  FinanceStackAppTests
//
//  Created by RN on 16/05/21.
//

import XCTest
import RxSwift

@testable import FinanceStackApp

class StockDetailAPIClientTests: XCTestCase {

    typealias SingleDetailSpy = SingleSpy<StockDetailModel>
    typealias StockDetailAPIManagerSpy = APIManagerSpy<StockDetailModel>

    func test_init_shouldNotMakeAPICall() {
        let sut = makeSUT()
        XCTAssertTrue(sut.apiManager.messageCount == 0, "Expected No api calls on initialization but got \(sut.apiManager.messageCount) instead")
    }

    func test_fetchStockDetail_shouldCallAPIManager() {
        let sut = makeSUT()
        let single = sut.client.fetchStockDetails(with: symbol, region: region)
        let _ = SingleSpy(single)

        XCTAssertTrue(sut.apiManager.messageCount == 1, "Expected 1 api call on calling fetchStockDetail method but got \(sut.apiManager.messageCount) instead")
    }

    func test_fetchStockDetail_shouldCallAPIManagerMultipleTimesOnMutipleCalls() {
        let sut = makeSUT()
        let _ = SingleDetailSpy(sut.client.fetchStockDetails(with: symbol, region: region))
        let _ = SingleDetailSpy(sut.client.fetchStockDetails(with: symbol, region: region))

        XCTAssertTrue(sut.apiManager.messageCount == 2, "Expected 2 api call on calling fetchStockDetail method but got \(sut.apiManager.messageCount) instead")
    }

    func test_fetchStockDetail_shouldPassCorrectConfigurationToAPI() throws {
        let sut = makeSUT()
        let _ = SingleDetailSpy(sut.client.fetchStockDetails(with: symbol, region: region))

        let configuration = try XCTUnwrap(sut.apiManager.messages.first)
        XCTAssertTrue(configuration.getUrl() == StockDetailAPIConstants.url)
        XCTAssertTrue(configuration.getRequestType() == .GET)
        XCTAssertTrue(configuration.getHeaders() == apiHeaders)
        XCTAssertTrue(configuration.getGetParams() == getParams(symbol: symbol, region: region))
        XCTAssertTrue(configuration.getRequestTimeout() == StockAPIConstants.rapidAPITimeout)
    }

    func test_fetchStockDetail_shouldPassFailure_OnAPIFailure() {
        let sut = makeSUT()
        sut.apiManager.failureError = anyAPIError
        let singleSpy = SingleDetailSpy(sut.client.fetchStockDetails(with: symbol, region: region))
        XCTAssertEqual(singleSpy.errorResults, [anyAPIError], "Expected client to fail with error on failure but got \(singleSpy.errorResults) instead")
    }

    func test_fetchStockDetail_shouldPassSuccessMessage_onSuccess() {
        let sut = makeSUT()
        sut.apiManager.successResults = stockDetailModel
        let singleSpy = SingleDetailSpy(sut.client.fetchStockDetails(with: symbol, region: region))
        XCTAssertEqual(singleSpy.successResults, [stockDetailModel], "Expected client to success with response but got \(singleSpy.successResults) instead")
    }

    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (client: StockDetailClient, apiManager: StockDetailAPIManagerSpy){
        let apiManager = StockDetailAPIManagerSpy()
        let stockClient = StockDetailAPIClient(apiManager: apiManager)
        testMemoryLeak(value: apiManager, file: file, line: line)
        testMemoryLeak(value: stockClient, file: file, line: line)
        return (client: stockClient, apiManager: apiManager)
    }



    private func getParams(symbol: String, region: String) -> [String: String] {
        var dict: [String: String] = [:]
        dict[StockDetailAPIConstants.symbolKey] = symbol
        dict[StockDetailAPIConstants.regionKey] = region
        return dict
    }

    private var symbol: String {
        return "SomeSymbol"
    }

    private var region: String {
        return "SomeRegion"
    }
}

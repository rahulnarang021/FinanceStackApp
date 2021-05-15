//
//  FinanceStackAppTests.swift
//  FinanceStackAppTests
//
//  Created by RN on 08/05/21.
//

import XCTest
@testable import FinanceStackApp
import RxSwift
import RxCocoa

class StockListViewModelTests: XCTestCase {

    var disposeBag = DisposeBag()
    func test_viewModelDoesNotCallAPI_OnInit() {
        let sut = makeSUT()
        XCTAssertTrue(sut.client.messageCount == 0, "StockViewModel should not fetch stocks on init but got \(sut.client.messageCount) instead")
    }

    func test_viewModelShouldMakeAPICall_OnCallingViewDidLoad() {
        let sut = makeSUT()
        sut.viewModel.fetchStockList()
        XCTAssertTrue(sut.client.messageCount == 1, "StockViewModel should fetch stocks on viewDidLoad but got \(sut.client.messageCount) instead")
    }

    func test_viewModelInitialState_isLoading() {
        let sut = makeSUT()
        let stateSpy = StateSpy(sut.viewModel.viewStates)

        XCTAssertEqual(stateSpy.values, [.loading(LoadingViewModel(message: loadingMessage))], "Expected loading state only but got \(stateSpy.values) instead")
    }

    func test_viewModelShouldFail_onClientFailure() {
        let sut = makeSUT()
        let stateSpy = StateSpy(sut.viewModel.viewStates)

        sut.viewModel.fetchStockList()

        sut.client.makeClientFail(withError: anyError)
        XCTAssertEqual(stateSpy.values,
                       [.loading(LoadingViewModel(message: loadingMessage)),
                        .failure(ErrorViewModel(message: errorMessage))],
                       "Expected Error State on client but got \(stateSpy.values) instead")

    }

    func test_viewModelShouldSuccess_onClientSuccess() {
        let sut = makeSUT()
        let stateSpy = StateSpy(sut.viewModel.viewStates)

        sut.viewModel.fetchStockList()
        let stockListData = [stockModel, stockModel]
        let stockViewModelList = [stockViewModel(), stockViewModel()]
        sut.client.makeClientSuccess(withData: stockListData)

        XCTAssertEqual(stateSpy.values,
                       [.loading(LoadingViewModel(message: loadingMessage)),
                        .success(stockViewModelList)],
                       "Expected list Succcess State on client but got \(stateSpy.values) instead")

    }

    func test_viewModelShouldNotFailWhenDataIsPresent_onClientFailure() {
        let sut = makeSUT()
        let stateSpy = StateSpy(sut.viewModel.viewStates)

        sut.viewModel.fetchStockList()
        let stockListData = [stockModel, stockModel]
        let stockViewModelList = [stockViewModel(), stockViewModel()]
        sut.client.makeClientSuccess(withData: stockListData)

        sut.viewModel.fetchStockList()
        sut.client.makeClientFail(withError: anyError, atIndex: 1)
        XCTAssertEqual(stateSpy.values,
                       [.loading(LoadingViewModel(message: loadingMessage)),
                        .success(stockViewModelList)],
                       "Expected Success list state only but got \(stateSpy.values) instead")

    }

    func test_viewModelShouldNotFilterResult_onEmptySearchText() {
        let sut = makeSUT()
        let stateSpy = StateSpy(sut.viewModel.viewStates)

        sut.viewModel.fetchStockList()
        let stockListData = [stockModel, stockModel]
        let stockViewModelList = [stockViewModel(), stockViewModel()]

        sut.client.makeClientSuccess(withData: stockListData)

        sut.viewModel.text.accept((""))
        XCTAssertEqual(stateSpy.values, [
            .loading(LoadingViewModel(message: loadingMessage)),
            .success(stockViewModelList)
        ], "Expected Empty Search results but got \(stateSpy.values) instead")
    }

    func test_viewModelShouldCallSearch_OnSearchText() {

        var capturedMessage: [StockQueryStub] = []
        let sut = makeSUT(searchHandler: { stocks, query in
            capturedMessage.append(StockQueryStub(stocks: stocks, query: query))
            return stocks
        })
        let _ = StateSpy(sut.viewModel.viewStates)

        sut.viewModel.fetchStockList()
        let stockListData = [stockModel, stockModel]
        var query = ""

        let initialStockQueryStub = StockQueryStub(stocks: stockListData, query: query)

        sut.client.makeClientSuccess(withData: stockListData)

        let exp1 = expectation(description: "Text Entry Expectation")

        expect(toFullFill: exp1, after: throttlingTimeInSeconds) {
            XCTAssertEqual(capturedMessage, [initialStockQueryStub], "Expected Search Block to be called on success response but got \(capturedMessage) instead")
        }
        wait(for: [exp1], timeout: throttlingTimeInSeconds)

        query = "ABC"

        sut.viewModel.text.accept(query)
        let exp2 = expectation(description: "Text Entry Expectation")

        expect(toFullFill: exp2, after: throttlingTimeInSeconds) {
            XCTAssertEqual(capturedMessage, [initialStockQueryStub, StockQueryStub(stocks: stockListData, query: query)], "Expected Search Block to be called on entering text but got \(capturedMessage) instead")
        }
        wait(for: [exp2], timeout: 2)

    }

    func test_viewModelShouldNotCallSearch_OnSameSearchText() {

        var capturedMessage: [StockQueryStub] = []
        let sut = makeSUT(searchHandler: { stocks, query in
            capturedMessage.append(StockQueryStub(stocks: stocks, query: query))
            return stocks
        })
        let _ = StateSpy(sut.viewModel.viewStates)

        sut.viewModel.fetchStockList()
        let stockListData = [stockModel, stockModel]
        var query = ""

        let initialStockQueryStub = StockQueryStub(stocks: stockListData, query: query)

        sut.client.makeClientSuccess(withData: stockListData)

        XCTAssertEqual(capturedMessage, [initialStockQueryStub], "Expected Search Block to be called on success response but got \(capturedMessage) instead")

        query = "ABC"

        sut.viewModel.text.accept(query)
        sut.viewModel.text.accept(query)

        let exp = expectation(description: "Text Entry Expectation")

        expect(toFullFill: exp, after: throttlingTimeInSeconds) {
            XCTAssertEqual(capturedMessage, [initialStockQueryStub, StockQueryStub(stocks: stockListData, query: query)], "Expected Search Block to be called on entering text but got \(capturedMessage) instead")
        }
        wait(for: [exp], timeout: throttlingTimeInSeconds)

    }

    func test_viewModelShouldCallTap_OnTappingStockViewModel() {
        var capuredStock: [StockModel] = []
        let tapHandler = { stock in
            capuredStock.append(stock)
        }
        let sut = makeSUT(tapHandler: tapHandler)

        sut.viewModel.fetchStockList()
        let stockListData = [stockModel(symbol: "testSymbol1"), stockModel(symbol: "testSymbol2")]
        let stockViewModelListData = [stockViewModel(stockModel: stockModel(symbol: "testSymbol1")),
                                      stockViewModel(stockModel: stockModel(symbol: "testSymbol2"))]

        sut.client.makeClientSuccess(withData: stockListData)
        sut.viewModel.tap.accept(stockViewModelListData[1])

        XCTAssertEqual(capuredStock, [stockListData[1]], "Expected tapped stock at index 0 but got \(capuredStock) instead")
    }

    func test_viewModelScheduleUpdateAPI_AfterResponseSuccessInXSeconds() {
        let delayInSeconds: TimeInterval = apiDelayConfiguration
        let sut = makeSUT(delay: Int(delayInSeconds))

        sut.viewModel.fetchStockList()
        let exp = expectation(description: "Schedule API Call Expectation")
        expect(toFullFill: exp, after: delayInSeconds) {
            XCTAssertTrue(sut.client.messageCount == 2, "Expected 2 API Calls after \(delayInSeconds) seconds but got \(String(describing: sut.client.messageCount)) instead")
        }
        wait(for: [exp], timeout: 2)
    }

    func test_viewModelScheduleUpdateAPI_AfterSomeResponseSuccessInXSeconds() {
        let delayInSeconds: TimeInterval = apiDelayConfiguration
        let sut = makeSUT(delay: Int(delayInSeconds))

        sut.viewModel.fetchStockList()
        let stockListData = [stockModel, stockModel]
        let exp1 = expectation(description: "Schedule first API Call Expectation")
        let exp2 = expectation(description: "Schedule second API Call Expectation")
        sut.client.makeClientSuccess(withData: stockListData, atIndex: 0)

        expect(toFullFill: exp1, after: delayInSeconds) {
            XCTAssertTrue(sut.client.messageCount == 2, "Expected 2 API Calls after \(delayInSeconds) seconds but got \(sut.client.messageCount) instead")

        }

        expect(toFullFill: exp2, after: (delayInSeconds * 3)) { // Wait for additional second to check for api schedule
            XCTAssertTrue(sut.client.messageCount == 3, "Expected 3 API Calls after \(delayInSeconds) seconds but got \(sut.client.messageCount) instead")
        }

        wait(for: [exp1, exp2], timeout: 5)
    }

    func test_viewModelShouldNotScheduleUpdateAPI_ifResponseHasNotRetrieved() {
        let delayInSeconds: TimeInterval = apiDelayConfiguration
        let sut = makeSUT(delay: Int(delayInSeconds))

        sut.viewModel.fetchStockList()
        let stockListData = [stockModel, stockModel]
        let exp1 = expectation(description: "Schedule first API Call Expectation")
        let exp2 = expectation(description: "Schedule second API Call Expectation")
        sut.client.makeClientSuccess(withData: stockListData, atIndex: 0)
        expect(toFullFill: exp1, after: delayInSeconds) {
            XCTAssertTrue(sut.client.messageCount == 2, "Expected 2 API Calls after \(delayInSeconds) seconds but got \(sut.client.messageCount) instead")
        }
        expect(toFullFill: exp2, after: delayInSeconds * 2) {
            XCTAssertTrue(sut.client.messageCount == 2, "Expected 2 API Calls after \(delayInSeconds) seconds but got \(sut.client.messageCount) instead")
        }
        wait(for: [exp1, exp2], timeout: delayInSeconds * 2)
    }

    private func expect(toFullFill exp:XCTestExpectation, after delayInSeconds: TimeInterval, action: () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(delayInSeconds)) {
            exp.fulfill()
        }
    }

    private func makeSUT(delay: Int = 1,
                         tapHandler: @escaping (StockModel) -> Void = {stockModel in },
                         searchHandler: @escaping ([StockModel], String) -> [StockModel] = { stockModels, _ in stockModels},
                         file: StaticString = #file,
                         line: UInt = #line) -> (viewModel: StockListViewModel, client: StockListClientSpy) {
        let client = StockListClientSpy()
        let viewModel = StockListViewModel(client: client,
                                           delay: 1,
                                           tapHandler: tapHandler,
                                           searchHandler: searchHandler)
        testMemoryLeak(value: client, file: file, line: line)
        testMemoryLeak(value: viewModel, file: file, line: line)
        return (viewModel: viewModel, client: client)
    }

    private class StateSpy {
        var values: [StockViewState] = []
        var disposbag = DisposeBag()
        init(_ state: Driver<StockViewState>) {
            state
                .asObservable()
                .subscribe (onNext: { state in
                    self.values.append(state)
                }).disposed(by: disposbag)
        }
    }

    private struct StockQueryStub: Equatable {
        let stocks: [StockModel]
        let query: String
    }

    private class StockListClientSpy: StockListClient {
        var observers: [Single<[StockModel]>.SingleObserver] = []
        var messageCount: Int {
            return observers.count
        }

        func fetchStockListFromAPI() -> Single<[StockModel]> {
            let observable = Single<StockListClient.Result>.create {[weak self] observer -> Disposable in
                self?.observers.append(observer)
                return Disposables.create {
                    // doing nothing on creation
                }
            }
            return observable
        }

        func makeClientFail(withError error: Error, atIndex index: Int = 0) {
            observers[index](.failure(error))
        }

        func makeClientSuccess(withData stockList: [StockModel], atIndex index: Int = 0) {
            observers[index](.success(stockList))
        }
    }

    private func stockViewModel() -> StockViewModel {
        return StockViewModel(stockModel)
    }

    private func stockViewModel(stockModel: StockModel) -> StockViewModel {
        return StockViewModel(stockModel)
    }

    private var loadingMessage: String {
        return "Fetching data"
    }

    private var errorMessage: String {
        return "Failed to load data from server"
    }

    private var throttlingTimeInSeconds: TimeInterval {
        return 0.2
    }

    private var apiDelayConfiguration: TimeInterval {
        return 0.2
    }

}

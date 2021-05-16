//
//  StockDetailViewModelTests.swift
//  FinanceStackAppTests
//
//  Created by RN on 16/05/21.
//

import XCTest
import RxSwift
import RxCocoa
@testable import FinanceStackApp

class StockDetailViewModelTests: XCTestCase {

    var disposeBag = DisposeBag()
    typealias StateDetailSpy = StateSpy<StockDetailViewState>

    func test_viewModelDoesNotCallAPI_OnInit() {
        let sut = makeSUT(stockModel: stockModel)
        XCTAssertTrue(sut.client.messageCount == 0, "StockViewModel should not fetch stock details on init but got \(sut.client.messageCount) instead")
    }

    func test_viewModelShouldMakeAPICall_OnCallingViewDidLoad() {
        let sut = makeSUT(stockModel: stockModel)
        sut.viewModel.fetchStockDetail()
        XCTAssertTrue(sut.client.messageCount == 1, "StockViewModel should fetch stocks on viewDidLoad but got \(sut.client.messageCount) instead")
    }

    func test_viewModelInitialState_isLoading() {
        let sut = makeSUT(stockModel: stockModel)
        let stateSpy = StateDetailSpy(sut.viewModel.viewStates)

        XCTAssertEqual(stateSpy.values, [.loading(LoadingViewModel(message: StockViewModelConstants.loadingMessage))], "Expected loading state only but got \(stateSpy.values) instead")
    }

    func test_viewModelShouldFail_onClientFailure() {
        let sut = makeSUT(stockModel: stockModel)
        let stateSpy = StateDetailSpy(sut.viewModel.viewStates)

        sut.viewModel.fetchStockDetail()

        sut.client.makeClientFail(withError: anyError)
        XCTAssertEqual(stateSpy.values,
                       [.loading(LoadingViewModel(message: StockViewModelConstants.loadingMessage)),
                        .failure(ErrorViewModel(message: StockViewModelConstants.errorMessage))],
                       "Expected Error State on client but got \(stateSpy.values) instead")

    }

    func test_viewModelShouldSuccess_onClientSuccess() {
        let sut = makeSUT(stockModel: stockModel)
        let stateSpy = StateDetailSpy(sut.viewModel.viewStates)

        sut.viewModel.fetchStockDetail()

        let data = stockDetailModel
        let stockViewModel = StockDetailVM(stockDetailModel: data)
        sut.client.makeClientSuccess(withData: data)

        XCTAssertEqual(stateSpy.values,
                       [.loading(LoadingViewModel(message: StockViewModelConstants.loadingMessage)),
                        .success(stockViewModel)],
                       "Expected list Succcess State on client but got \(stateSpy.values) instead")

    }

    private func makeSUT(stockModel: StockModel,
                         file: StaticString = #file,
                         line: UInt = #line) -> (viewModel: StockDetailViewModel, client: StockDetailClientSpy) {
        let client = StockDetailClientSpy()
        let stockDetailInput = StockDetailInput(shortName: stockModel.shortName,
                                                symbol: stockModel.symbol,
                                                region: stockModel.region)

        let viewModel = StockDetailViewModel(stockModel: stockDetailInput, client: client)
        testMemoryLeak(value: client, file: file, line: line)
        testMemoryLeak(value: viewModel, file: file, line: line)
        return (viewModel: viewModel, client: client)
    }

    private class StockDetailClientSpy: StockDetailClient {
        var observers: [Single<StockDetailModel>.SingleObserver] = []
        var messageCount: Int {
            return observers.count
        }

        func fetchStockDetails(with symbol: String, region: String) -> Single<StockDetailModel> {
            let observable = Single<StockDetailModel>.create {[weak self] observer -> Disposable in
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

        func makeClientSuccess(withData stockList: StockDetailModel, atIndex index: Int = 0) {
            observers[index](.success(stockList))
        }
    }
}

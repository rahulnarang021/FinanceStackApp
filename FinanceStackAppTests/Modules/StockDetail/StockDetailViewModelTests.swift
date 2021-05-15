//
//  StockDetailViewModelTests.swift
//  FinanceStackAppTests
//
//  Created by RN on 14/05/21.
//

import XCTest
@testable import FinanceStackApp

class StockDetailViewModelTests: XCTestCase {

    func test_init_initialiesStockDetailVMFromStockModel() {
        let sut = makeSUT(stockModel)
        XCTAssertNotNil(sut.stockDetailVM, "StockDetailVM should be initialised on init")
    }

    func test_stockDetailVM_containsSameValuesAsStockModel() {
        let model = stockModel
        let sut = makeSUT(model)

        XCTAssertEqual(sut.stockDetailVM.exchangeName, model.fullExchangeName, "Expected same exchangeName but got \(sut.stockDetailVM.exchangeName) instead")
        XCTAssertEqual(sut.stockDetailVM.stockName, model.shortName, "Expected same exchangeName but got \(sut.stockDetailVM.stockName) instead")
        XCTAssertEqual(sut.stockDetailVM.marketName, model.market, "Expected same marketName but got \(sut.stockDetailVM.stockName) instead")
        XCTAssertEqual(sut.stockDetailVM.priceValue, "$4,152.10", "Expected formatted marketPrice with currency symbol but got \(sut.stockDetailVM.priceValue) instead")
        XCTAssertEqual(sut.stockDetailVM.marketTime, stockModel.regularMarketTime.fmt, "Expected formatted regularMarketTime symbol but got \(sut.stockDetailVM.marketTime) instead")

    }

    func test_stockDetailVM_containsSymbolNameOnNilShortName() {
        let model = stockModel(shortName: nil)
        let sut = makeSUT(model)

        XCTAssertEqual(sut.stockDetailVM.stockName, model.symbol, "Expected stockName same as symbol but got \(sut.stockDetailVM.stockName) instead")
    }

    func test_stockDetailVM_containsSymbolNameOnEmptyShortName() {
        let model = stockModel(shortName: "")
        let sut = makeSUT(model)

        XCTAssertEqual(sut.stockDetailVM.stockName, model.symbol, "Expected stockName same as symbol but got \(sut.stockDetailVM.stockName) instead")
    }

    func test_stockDetailVM_containsEmptyHighLowPricesIfSparkDoesNotContainAnyPricesAndTimestamps() {
        let model = stockModel
        let sut = makeSUT(model)

        XCTAssertEqual(sut.stockDetailVM.allTimeLowPrice, sut.stockDetailVM.notAvailable, "Expected N/A but got \(sut.stockDetailVM.allTimeLowPrice) instead")
        XCTAssertEqual(sut.stockDetailVM.allTimeHighPrice, sut.stockDetailVM.notAvailable, "Expected N/A but got \(sut.stockDetailVM.allTimeHighPrice) instead")
        XCTAssertEqual(sut.stockDetailVM.allTimeLowPriceDate, sut.stockDetailVM.notAvailable, "Expected N/A but got \(sut.stockDetailVM.allTimeLowPriceDate) instead")
        XCTAssertEqual(sut.stockDetailVM.allTimeHighPriceDate, sut.stockDetailVM.notAvailable, "Expected N/A but got \(sut.stockDetailVM.allTimeHighPriceDate) instead")
    }

    func test_stockDetailVM_containsHighAndLowPriceWhenSparkCloseIsNotEmpty() {
        let closePrices: [Double] = [20, 30, 40]
        let timeStamps: [TimeInterval] = [dummyTimeInterval1, dummyTimeInterval1]
        let model = stockModel(spark: sparkModel(closePrices: closePrices, timestamps: timeStamps))
        let sut = makeSUT(model)
        XCTAssertEqual(sut.stockDetailVM.allTimeHighPrice, "$40.00", "Expected highest price value in currency format but got \(sut.stockDetailVM.allTimeHighPrice) instead")
        XCTAssertEqual(sut.stockDetailVM.allTimeLowPrice, "$20.00", "Expected lowest price value in currency format but got \(sut.stockDetailVM.allTimeHighPrice) instead")
    }

    func test_stockDetailVM_containsValidDateStringForHighAndLowPrices() {
        let closePrices: [Double] = [20, 30, 40]
        let timeStamps: [TimeInterval] = [dummyTimeInterval1, dummyTimeInterval2, dummyTimeInterval3]
        let model = stockModel(spark: sparkModel(closePrices: closePrices, timestamps: timeStamps))
        let sut = makeSUT(model)
        XCTAssertEqual(sut.stockDetailVM.allTimeHighPriceDate, "5/15/21, 12:08 AM", "Expected highest price date in string format but got \(sut.stockDetailVM.allTimeHighPriceDate) instead")
        XCTAssertEqual(sut.stockDetailVM.allTimeLowPriceDate, "5/14/21, 11:35 PM", "Expected lowest price date in string format but got \(sut.stockDetailVM.allTimeLowPriceDate) instead")
    }

    private func makeSUT(_ model: StockModel, file: StaticString = #file, line: UInt = #line) -> StockDetailViewModel {
        let viewModel = StockDetailViewModel(stockModel: model)
        testMemoryLeak(value: viewModel, file: file, line: line)
        return viewModel
    }

    func sparkModel(closePrices: [Double] = [], timestamps: [TimeInterval] = []) -> Spark {
        return Spark(symbol: "^GSPC",
                     start: 1620826200,
                     end: 1620849600,
                     timestamp: timestamps,
                     close: closePrices,
                     dataGranularity: 300,
                     previousClose: 4152.1,
                     chartPreviousClose: 4152.1)
    }

    var dummyTimeInterval1: TimeInterval {
        return 1621028101
    }

    var dummyTimeInterval2: TimeInterval {
        return 1621029101
    }

    var dummyTimeInterval3: TimeInterval {
        return 1621030101
    }


}

//
//  SearchQueryServiceTests.swift
//  FinanceStackAppTests
//
//  Created by RN on 14/05/21.
//

import XCTest
@testable import FinanceStackApp

class SearchQueryServiceTests: XCTestCase {

    func test_shouldReturnSameResult_OnEmptyQuery() {
        let stockModels = [stockModel]
        let models = SearchQueryService.search(stockModelList: stockModels, for: "")
        XCTAssertEqual(models, stockModels, "Expected same result but got \(models) instead")
    }

    func test_shouldReturnEmptyResult_WhenQueryDoesNotMatchWithExchangeSymbolAndShortName() {
        let stockModels = [stockModel(exchangeName: "Exchange", symbol: "Symbol", shortName: "ShortName")]
        let query = "Qwery"
        let models = SearchQueryService.search(stockModelList: stockModels, for: query)
        XCTAssertEqual(models, [], "Expected filtered result but got \(models) instead")
    }

    func test_shouldReturnCorrectResult_WhenQueryStartsWithExchangeName() {
        let exchStockModel = stockModel(exchangeName: "Exchange")
        let stockModels = [exchStockModel, stockModel]
        let query = "Exch"
        let models = SearchQueryService.search(stockModelList: stockModels, for: query)
        XCTAssertEqual(models, [exchStockModel], "Expected filtered result but got \(models) instead")
    }

    func test_shouldReturnCorrectResult_WhenQueryStartsWithCaseInsensitiveExchangeName() {
        let exchStockModel = stockModel(exchangeName: "Exchange")
        let stockModels = [exchStockModel, stockModel]
        let query = "exch"
        let models = SearchQueryService.search(stockModelList: stockModels, for: query)
        XCTAssertEqual(models, [exchStockModel], "Expected filtered result but got \(models) instead")
    }

    func test_shouldReturnCorrectResult_WhenCaseSensitiveQueryStartsWithExchangeName() {
        let exchStockModel = stockModel(exchangeName: "Exchange")
        let stockModels = [exchStockModel, stockModel]
        let query = "eXCH"
        let models = SearchQueryService.search(stockModelList: stockModels, for: query)
        XCTAssertEqual(models, [exchStockModel], "Expected filtered result but got \(models) instead")
    }

    func test_shouldReturnCorrectResult_WhenQueryDoesNotStartButMatchesWithExchange() {
        let exchStockModel = stockModel(exchangeName: "Exchange")
        let stockModels = [exchStockModel, stockModel]
        let query = "change"
        let models = SearchQueryService.search(stockModelList: stockModels, for: query)
        XCTAssertEqual(models, [], "Expected filtered result but got \(models) instead")
    }

    func test_shouldReturnCorrectResult_WhenSymbolNameContainsQweryText() {
        let symStockModel = stockModel(symbol: "Symb")
        let stockModels = [stockModel, symStockModel]
        let query = "ymb"
        let models = SearchQueryService.search(stockModelList: stockModels, for: query)
        XCTAssertEqual(models, [symStockModel], "Expected filtered result but got \(models) instead")
    }

    func test_shouldReturnCorrectResult_WhenSymbolNameContainsQweryTextAsCaseSensitive() {
        let symStockModel = stockModel(symbol: "Symb")
        let stockModels = [stockModel, symStockModel]
        let query = "YMB"
        let models = SearchQueryService.search(stockModelList: stockModels, for: query)
        XCTAssertEqual(models, [symStockModel], "Expected filtered result but got \(models) instead")
    }

    func test_shouldReturnCorrectResult_WhenCaseSensitiveSymbolNameContainsQweryText() {
        let symStockModel = stockModel(symbol: "sYmB")
        let stockModels = [stockModel, symStockModel]
        let query = "YMB"
        let models = SearchQueryService.search(stockModelList: stockModels, for: query)
        XCTAssertEqual(models, [symStockModel], "Expected filtered result but got \(models) instead")
    }

    func test_shouldReturnCorrectResult_WhenShortNameContainsQweryText() {
        let symStockModel = stockModel(shortName: "ShortName")
        let stockModels = [stockModel, symStockModel]
        let query = "ort"
        let models = SearchQueryService.search(stockModelList: stockModels, for: query)
        XCTAssertEqual(models, [symStockModel], "Expected filtered result but got \(models) instead")
    }

    func test_shouldReturnCorrectResult_WhenShortNameContainsQweryTextAsCaseSensitive() {
        let symStockModel = stockModel(shortName: "ShortName")
        let stockModels = [stockModel, symStockModel]
        let query = "NAME"
        let models = SearchQueryService.search(stockModelList: stockModels, for: query)
        XCTAssertEqual(models, [symStockModel], "Expected filtered result but got \(models) instead")
    }

    func test_shouldReturnCorrectResult_WhenCaseSensitiveShortNameContainsQweryText() {
        let symStockModel = stockModel(shortName: "ShOrTName")
        let stockModels = [stockModel, symStockModel]
        let query = "rtn"
        let models = SearchQueryService.search(stockModelList: stockModels, for: query)
        XCTAssertEqual(models, [symStockModel], "Expected filtered result but got \(models) instead")
    }

}


//
//  XCTestCase+StockClientConstants.swift
//  FinanceStackAppTests
//
//  Created by RN on 16/05/21.
//

import XCTest
import FinanceStackApp

extension XCTestCase {
    var apiHeaders: [String: String] {
        var dict: [String: String] = [:]
        dict[StockAPIConstants.rapidAPIKey] = StockAPIConstants.rapidAPIKeyValue
        dict[StockAPIConstants.rapidAPIHost] = StockAPIConstants.rapidAPIHostValue
        return dict
    }
    var anyAPIError: APIError {
        return APIError(message: "Any Error Message")
    }
}

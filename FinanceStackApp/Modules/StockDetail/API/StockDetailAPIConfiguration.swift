//
//  StockDetailAPIConfiguration.swift
//  FinanceStackApp
//
//  Created by RN on 16/05/21.
//

import Foundation

struct StockDetailAPIConfiguration: APIConfiguration {
    let region: String
    let symbol: String
    init(symbol: String, region: String) {
        self.symbol = symbol
        self.region = region
    }

    func getGetParams() -> [String : String?]? {
        var params: [String: String] = [:]
        params[StockDetailAPIConstants.symbolKey] = symbol
        params[StockDetailAPIConstants.regionKey] = region
        return params
    }

    func getHeaders() -> [String : String]? {
        var headers: [String : String] = [:]
        headers[StockAPIConstants.rapidAPIKey] = StockAPIConstants.rapidAPIKeyValue
        headers[StockAPIConstants.rapidAPIHost] = StockAPIConstants.rapidAPIHostValue
        return headers

    }

    func getUrl() -> URL {
        return StockDetailAPIConstants.url
    }

    func getRequestType() -> RequestType {
        .GET
    }

    func getRequestTimeout() -> TimeInterval {
        return StockAPIConstants.rapidAPITimeout
    }

    func getPostParams() -> [String : Any?]? {
        return nil
    }
}

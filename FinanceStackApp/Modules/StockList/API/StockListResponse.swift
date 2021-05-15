//
//  StockListResponse.swift
//  FinanceStackApp
//
//  Created by RN on 12/05/21.
//

import Foundation
public struct StockListResponse: Decodable, Equatable {
    let marketSummaryAndSparkResponse: MarketSummary
}

public struct MarketSummary: Decodable, Equatable {
    let result: [StockModel]
}

public struct StockModel: Decodable, Equatable {
    let fullExchangeName: String
    let exchangeTimezoneName: String
    let symbol: String
    let gmtOffSetMilliseconds: TimeInterval
    let exchangeDataDelayedBy: TimeInterval
    let firstTradeDateMilliseconds: TimeInterval
    let language: String
    let exchangeTimezoneShortName: String
    let quoteType: String
    let marketState: String
    let market: String
    let spark: Spark
    let priceHint: Double
    let tradeable: Bool
    let sourceInterval: TimeInterval
    let exchange: String
    let region: String
    let shortName: String?
    let triggerable: Bool
    let regularMarketPreviousClose: MarketClose
    let regularMarketTime: MarketTime
}

public struct MarketTime: Decodable, Equatable {
    let fmt: String
    let raw: TimeInterval
}

public struct MarketClose: Decodable, Equatable {
    let fmt: String
    let raw: Double
}

public struct Spark: Decodable, Equatable {
    let symbol: String
    let start: TimeInterval?
    let end: TimeInterval?
    let timestamp: [TimeInterval]?
    let close: [Double?]? // Took Optional Double as its becausee of the api requirement
    let dataGranularity: Double
    let previousClose: Double
    let chartPreviousClose: Double
}

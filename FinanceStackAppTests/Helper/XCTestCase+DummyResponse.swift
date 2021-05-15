//
//  DummyStockListResponse.swift
//  FinanceStackAppTests
//
//  Created by RN on 14/05/21.
//

import XCTest
@testable import FinanceStackApp

extension XCTestCase {
    var stockListResponse: StockListResponse {
        return StockListResponse(marketSummaryAndSparkResponse: marketSummaryResponse)
    }

    var emptyStockListResponse: StockListResponse {
        return StockListResponse(marketSummaryAndSparkResponse: emptyMarketSummaryResponse)
    }


    var emptyMarketSummaryResponse: MarketSummary {
        return MarketSummary(result: [])
    }

    var marketSummaryResponse: MarketSummary {
        return MarketSummary(result: [stockModel])
    }

    var stockModel: StockModel {
        return stockModel(spark: sparkModel)
    }

    func stockModel(exchangeName: String = "SNP", symbol: String = "^GSPC", shortName: String? = "S&P 500") -> StockModel {
        return stockModel(exchangeName: exchangeName, symbol: symbol, shortName: shortName, spark: sparkModel)
    }

    func stockModel(exchangeName: String = "SNP", symbol: String = "^GSPC", shortName: String? = "S&P 500", spark: Spark) -> StockModel {
        let stockModel = StockModel(fullExchangeName: exchangeName, exchangeTimezoneName: "America/New_York", symbol: symbol, gmtOffSetMilliseconds: -14400000, exchangeDataDelayedBy: 0, firstTradeDateMilliseconds: -1325583000000, language: "en-US", exchangeTimezoneShortName: "EDT", quoteType: "INDEX", marketState: "REGULAR", market: "US", spark: spark, priceHint: 2, tradeable: false, sourceInterval: 15, exchange: "SNP", region: "US", shortName: shortName, triggerable: false, regularMarketPreviousClose: marketClosePrice, regularMarketTime: marketTime)
        return stockModel
    }

    var marketClosePrice: MarketClose {
        return MarketClose(fmt: "4,152.10", raw: 4152.1)
    }

    var marketTime: MarketTime {
        return MarketTime(fmt: "11:30AM EDT", raw: 1621006203)
    }

    var sparkModel: Spark {
        return Spark(symbol: "^GSPC",
                     start: 1620826200,
                     end: 1620849600,
                     timestamp: [],
                     close: [],
                     dataGranularity: 300,
                     previousClose: 4152.1,
                     chartPreviousClose: 4152.1)
    }
}

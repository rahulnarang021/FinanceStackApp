//
//  StockDetailVM.swift
//  FinanceStackApp
//
//  Created by RN on 14/05/21.
//

import Foundation
struct StockDetailVM {
    private let stockModel: StockModel

    init(stockModel: StockModel) {
        self.stockModel = stockModel
    }

    var stockName: String {
        if let shortName = stockModel.shortName, !shortName.isEmpty {
            return shortName
        }
        return stockModel.symbol
    }

    var notAvailable: String {
        return "N/A"
    }

    var exchangeName: String {
        return stockModel.fullExchangeName
    }

    var marketName: String {
        return stockModel.market
    }

    var priceValue: String {
        return CurrencyFormattingHelper.shared.formatCurrency(stockModel.regularMarketPreviousClose.raw)
    }
    var allTimeHighPrice: String {
        if let maxPrice = stockModel.spark.close?.maxElement() {
            return CurrencyFormattingHelper.shared.formatCurrency(maxPrice)
        }
        return notAvailable
    }

    var allTimeHighPriceDate: String {
        if let priceArray = stockModel.spark.close, let priceValue = priceArray.maxElement() {
            if let index = priceArray.firstIndex(of: priceValue), let timestamp = stockModel.spark.timestamp?[index] {
                let date = Date(timeIntervalSince1970: timestamp)
                return "\(DateFormattingHelper.shared.formattedDate(date))"
            }
        }
        return notAvailable
    }

    var allTimeLowPrice: String {
        if let minPrice = stockModel.spark.close?.minElement() {
            return CurrencyFormattingHelper.shared.formatCurrency(minPrice)
        }
        return notAvailable
    }

    var allTimeLowPriceDate: String {
        if let priceArray = stockModel.spark.close, let priceValue = priceArray.minElement() {
            if let index = priceArray.firstIndex(of: priceValue), let timestamp = stockModel.spark.timestamp?[index] {
                let date = Date(timeIntervalSince1970: timestamp)
                return "\(DateFormattingHelper.shared.formattedDate(date))"
            }
        }
        return notAvailable
    }

    var marketTime: String {
        return stockModel.regularMarketTime.fmt
    }
}


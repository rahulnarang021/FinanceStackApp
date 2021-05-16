//
//  StockDetailModel.swift
//  FinanceStackApp
//
//  Created by RN on 16/05/21.
//

import Foundation

// Note: Marked all parameters as optional due to uncertainty of api
public struct StockDetailModel: Decodable, Equatable {
    let summaryProfile: SummaryProfile?
    let financialData: FinancialData?
    let summaryDetail: SummaryDetail?
    let price: Price?
}

public struct Price: Decodable, Equatable {
    let regularMarketOpen: GenericData?
    let regularMarketChange: GenericData?
    let regularMarketPreviousClose: GenericData?
    let regularMarketDayLow: GenericData?
    let regularMarketPrice: GenericData?
}

public struct SummaryProfile: Decodable, Equatable {
    let zip: String?
    let sector: String?
    let fullTimeEmployees: Int?
    let longBusinessSummary: String?
    let city: String?
    let country: String?
}

public struct FinancialData: Decodable, Equatable {
    let ebitdaMargins: GenericData?
    let profitMargins: GenericData?
    let grossMargins: GenericData?
    let revenueGrowth: GenericData?
    let ebitda: GenericData?
    let targetLowPrice: GenericData?
    let grossProfits: GenericData?
    let totalCash: GenericData?
    let totalDebt: GenericData?
    let totalRevenue: GenericData?
}

public struct SummaryDetail: Decodable, Equatable {
    let previousClose: GenericData?
    let fiftyDayAverage: GenericData?
    let dividendRate: GenericData?
    let dayHigh: GenericData?
}

public struct GenericData: Decodable, Equatable {
    var raw: Double?
    var fmt: String?
}

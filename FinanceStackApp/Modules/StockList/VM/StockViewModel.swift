//
//  StockViewModel.swift
//  FinanceStackApp
//
//  Created by RN on 12/05/21.
//

import Foundation

public struct StockViewModel: Equatable {
    public var name: String
    public var price: String
    public var market: String
    public var identifier: String
    public var shortName: String?
    
    public init(_ stockModel: StockModel) {
        self.identifier = stockModel.symbol //temporary and can be changed on the basis of api requirement
        self.shortName = stockModel.shortName
        if let stockName = shortName {
            self.name = "\(stockName) (\(stockModel.symbol))"
        } else {
            self.name = "\(stockModel.symbol) (\(stockModel.exchange))"
        }
        self.price = stockModel.regularMarketPreviousClose.fmt
        self.market = "\(stockModel.quoteType) - \(stockModel.region)"
    }
}

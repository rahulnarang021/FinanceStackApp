//
//  StockViewModel.swift
//  FinanceStackApp
//
//  Created by RN on 12/05/21.
//

import Foundation

public struct ErrorViewModel: Equatable {
    public var message: String
}

public struct LoadingViewModel: Equatable {
    public var message: String
}

public struct StockViewModel: Equatable {
    public var name: String
    public var price: String
    public var market: String
    public var identifier: String
    public var shortName: String?
    
    public init(_ stockModel: StockModel) {
        self.identifier = stockModel.symbol //temporary and can be changed on the basis of api requirement
        self.shortName = stockModel.shortName
        self.name = "\(stockModel.symbol) (\(stockModel.exchange))"
        self.price = stockModel.regularMarketPreviousClose.fmt
        self.market = "\(stockModel.quoteType) - \(stockModel.region)"
    }
}

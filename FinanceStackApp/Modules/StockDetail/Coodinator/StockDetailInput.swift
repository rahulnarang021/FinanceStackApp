//
//  StockDetailInput.swift
//  FinanceStackApp
//
//  Created by RN on 16/05/21.
//

import Foundation
public struct StockDetailInput {
    let shortName: String?
    let symbol: String
    let region: String

    init(shortName: String?, symbol: String, region: String) {
        self.shortName = shortName
        self.symbol = symbol
        self.region = region
    }
}

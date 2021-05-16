//
//  StockListAPIConstants.swift
//  FinanceStackApp
//
//  Created by RN on 14/05/21.
//

import Foundation

enum StockListAPIConstants {
    static let regionValue = "US"
    static let regionKey = "region"

    static let rapidAPIURL = URL(string: "https://apidojo-yahoo-finance-v1.p.rapidapi.com/market/v2/get-summary")!
}

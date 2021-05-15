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

    static let rapidAPIKey = "x-rapidapi-key"
    static let rapidAPIKeyValue = "c8ec9b6471msh0f9060a722b1e5dp1c40ebjsn29da3d58e58f"
    static let rapidAPIHost = "x-rapidapi-host"
    static let rapidAPIHostValue = "apidojo-yahoo-finance-v1.p.rapidapi.com"
    static let rapidAPIURL = URL(string: "https://apidojo-yahoo-finance-v1.p.rapidapi.com/market/v2/get-summary")!
    static let rapidAPITimeout: TimeInterval = 5
}

//
//  StockDetailAPIConstants.swift
//  FinanceStackApp
//
//  Created by RN on 16/05/21.
//

import Foundation
public enum StockDetailAPIConstants {
    public static let url = URL(string: "https://apidojo-yahoo-finance-v1.p.rapidapi.com/stock/v2/get-summary")!
    public static let symbolKey = "symbol"
    public static let regionKey = "region"
}


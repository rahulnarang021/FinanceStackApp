//
//  Price+StockDetailListVM.swift
//  FinanceStackApp
//
//  Created by RN on 17/05/21.
//

import Foundation
extension Price {
    func getListVM() -> [StockDetailListVM] {
        var list: [StockDetailListVM] = []

        if let regularMarketPrice = self.regularMarketPrice {
            list.append(StockDetailListVM(title: "Regular Price",
                                          data: regularMarketPrice))
        }
        if let regularMarketOpen = self.regularMarketOpen {
            list.append(StockDetailListVM(title: "Regular Open Price",
                                          data: regularMarketOpen))
        }
        if let regularMarketChange = self.regularMarketChange {
            list.append(StockDetailListVM(title: "Regular Change",
                                          data: regularMarketChange))
        }

        if let regularMarketDayLow = self.regularMarketChange {
            list.append(StockDetailListVM(title: "Regular Day Low",
                                          data: regularMarketDayLow))
        }
        if let regularMarketPreviousClose = self.regularMarketPreviousClose {
            list.append(StockDetailListVM(title: "Regular Previous Close",
                                          data: regularMarketPreviousClose))
        }
        return list
    }

}

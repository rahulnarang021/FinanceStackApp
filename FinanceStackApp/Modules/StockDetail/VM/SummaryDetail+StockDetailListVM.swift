//
//  SummaryDetail+StockDetailListVM.swift
//  FinanceStackApp
//
//  Created by RN on 17/05/21.
//

import Foundation
extension SummaryDetail {
    func getListVM() -> [StockDetailListVM] {
        var list: [StockDetailListVM] = []

        if let previousClose = self.previousClose {
            list.append(StockDetailListVM(title: "Previous Close",
                                          data: previousClose))
        }

        if let fiftyDayAverage = self.fiftyDayAverage {
            list.append(StockDetailListVM(title: "Fifty Day Average",
                                          data: fiftyDayAverage))
        }

        if let dividendRate = self.dividendRate {
            list.append(StockDetailListVM(title: "Dividend Rate",
                                          data: dividendRate))
        }

        if let dayHigh = self.dayHigh {
            list.append(StockDetailListVM(title: "Day High",
                                          data: dayHigh))
        }
        return list
    }

}

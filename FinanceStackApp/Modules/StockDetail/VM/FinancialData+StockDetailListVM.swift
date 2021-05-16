//
//  FinancialData+StockDetailListVM.swift
//  FinanceStackApp
//
//  Created by RN on 17/05/21.
//

import Foundation
extension FinancialData {

    func getListVM() -> [StockDetailListVM] {
        var list: [StockDetailListVM] = []
        if let ebitdaMargins = self.ebitdaMargins {
            list.append(StockDetailListVM(title: "Ebitda Margins",
                                          data: ebitdaMargins))
        }
        if let profitMargins = self.profitMargins {
            list.append(StockDetailListVM(title: "Profit Margins",
                                          data: profitMargins))
        }
        if let grossMargins = self.grossMargins {
            list.append(StockDetailListVM(title: "Gross Margins",
                                          data: grossMargins))
        }
        if let revenueGrowth = self.revenueGrowth {
            list.append(StockDetailListVM(title: "Revenue Growth",
                                          data: revenueGrowth))
        }

        if let ebitda = self.ebitda {
            list.append(StockDetailListVM(title: "Ebitda",
                                          data: ebitda))
        }

        if let targetLowPrice = self.targetLowPrice {
            list.append(StockDetailListVM(title: "Target Low Price",
                                          data: targetLowPrice))
        }

        if let grossProfits = self.grossProfits {
            list.append(StockDetailListVM(title: "Gross Profits",
                                          data: grossProfits))
        }

        if let totalDebt = self.totalDebt {
            list.append(StockDetailListVM(title: "Total Debt",
                                          data: totalDebt))
        }

        if let totalRevenue = self.totalRevenue {
            list.append(StockDetailListVM(title: "Total Revenue",
                                          data: totalRevenue))
        }
        return list
    }
}

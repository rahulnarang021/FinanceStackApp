//
//  SummaryProfile+StockDetailListVM.swift
//  FinanceStackApp
//
//  Created by RN on 17/05/21.
//

import Foundation
extension SummaryProfile {
    func getListVM() -> [StockDetailListVM] {
        var list: [StockDetailListVM] = []

        if let sectorName = sector {
            list.append(StockDetailListVM(title: "Sector",
                                          value: sectorName))
        }

        if let employees = fullTimeEmployees {
            list.append(StockDetailListVM(title: "Employees",
                                          value: "\(employees)"))
        }

        if let country = country {
            list.append(StockDetailListVM(title: "Country",
                                          value: country))
        }
        return list
    }
}

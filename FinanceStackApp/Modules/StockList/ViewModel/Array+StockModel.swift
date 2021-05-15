//
//  Array+StockModel.swift
//  FinanceStackApp
//
//  Created by RN on 15/05/21.
//

import Foundation
extension Array where Element == StockModel {
    func mapViewModel() -> [StockViewModel] {
        return self.map({ StockViewModel($0) })
    }
}

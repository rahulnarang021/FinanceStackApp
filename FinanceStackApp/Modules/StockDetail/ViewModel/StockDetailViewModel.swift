//
//  StockDetailViewModel.swift
//  FinanceStackApp
//
//  Created by RN on 14/05/21.
//

import Foundation

class StockDetailViewModel {

    var stockDetailVM: StockDetailVM

    init(stockModel: StockModel) {
        self.stockDetailVM = StockDetailVM(stockModel: stockModel)
    }
}

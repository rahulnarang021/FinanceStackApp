//
//  SearchQueryService.swift
//  FinanceStackApp
//
//  Created by RN on 14/05/21.
//

import Foundation

enum SearchQueryService {

    static func search(stockModelList: [StockModel], for query: String) -> [StockModel] {
        if query.isEmpty {
            return stockModelList
        }
        return stockModelList.filter { stockModel -> Bool in
            let text = query.lowercased()
            return (stockModel.fullExchangeName.lowercased().hasPrefix(text) ||
                        stockModel.symbol.lowercased().contains(text) ||
                        (stockModel.shortName?.lowercased().contains(text) ?? false))
        }
    }
}

//
//  StockDetailVM.swift
//  FinanceStackApp
//
//  Created by RN on 14/05/21.
//

import Foundation
public struct StockDetailVM: Equatable { // Created VM to show raw stock data on screen should be changed on the basis of business requirements
    private var stockDetailModel: StockDetailModel

    public var summaryList: [StockDetailListVM] = []
    public init(stockDetailModel: StockDetailModel) {
        self.stockDetailModel = stockDetailModel

        var list: [StockDetailListVM] = [] // all text should be in localizable file in a realtime project
        if let summaryProfile = stockDetailModel.summaryProfile {
            list.append(contentsOf: summaryProfile.getListVM())
        }

        if let financialData = stockDetailModel.financialData {
            list.append(contentsOf: financialData.getListVM())
        }

        if let summaryDetail = stockDetailModel.summaryDetail {
            list.append(contentsOf: summaryDetail.getListVM())
        }

        if let price = stockDetailModel.price {
            list.append(contentsOf: price.getListVM())
        }

        self.summaryList = list
    }
}


public struct StockDetailListVM: Equatable {
    public let title: String
    public let value: String

    public init(title: String, value: String?) {
        self.title = title
        self.value = value ?? "N/A"
    }

    public init(title: String, data: GenericData?) {
        self.title = title
        guard let data = data else {
            self.value = "N/A"
            return
        }
        if let formattedValue = data.fmt {
            self.value = formattedValue
        } else if let rawValue = data.raw {
            self.value = "\(rawValue)"
        } else {
            self.value = "N/A"
        }
    }
}

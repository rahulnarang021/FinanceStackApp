//
//  StockDetailClient.swift
//  FinanceStackApp
//
//  Created by RN on 16/05/21.
//

import Foundation
import RxSwift

public protocol StockDetailClient {
    typealias Result = StockDetailModel
    func fetchStockDetails(with symbol: String, region: String) -> Single<StockDetailModel>
}


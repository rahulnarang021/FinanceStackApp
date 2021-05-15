//
//  StockListClient.swift
//  FinanceStackApp
//
//  Created by RN on 12/05/21.
//

import Foundation
import RxSwift

public protocol StockListClient {
    typealias Result = [StockModel]
    func fetchStockListFromAPI() -> Single<Result>
}



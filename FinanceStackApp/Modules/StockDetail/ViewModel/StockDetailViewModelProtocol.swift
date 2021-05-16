//
//  StockDetailViewModelProtocol.swift
//  FinanceStackApp
//
//  Created by RN on 17/05/21.
//

import Foundation
import RxSwift
import RxCocoa

public typealias StockDetailViewState = StockViewState<StockDetailVM>
public protocol StockDetailViewModelProtocol {
    var title: String { get }
    var viewStates: Driver<StockDetailViewState> { get }
    func fetchStockDetail()
}

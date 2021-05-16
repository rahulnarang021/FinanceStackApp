//
//  StockListViewModelProtocol.swift
//  FinanceStackApp
//
//  Created by RN on 17/05/21.
//

import Foundation
import RxSwift
import RxCocoa

public typealias StockListViewState = StockViewState<[StockViewModel]>
public protocol StockListViewModelProtocol {
    var title: String { get }
    var text: BehaviorRelay<String> { get }

    var tap: PublishRelay<StockViewModel> { get }
    var viewStates: Driver<StockListViewState> { get }

    func fetchStockList()
}

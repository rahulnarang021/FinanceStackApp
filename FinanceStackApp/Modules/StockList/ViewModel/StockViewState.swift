//
//  StockViewState.swift
//  FinanceStackApp
//
//  Created by RN on 15/05/21.
//

import Foundation
public enum StockViewState: Equatable {
    case loading(LoadingViewModel)
    case success([StockViewModel])
    case failure(ErrorViewModel)
}

public extension StockViewState {
    func getViewModels() -> [StockViewModel] {
        switch self {
        case let .success(stockList):
            return stockList
        default:
            return []
        }
    }

    func getErrorViewModel() -> ErrorViewModel? {
        switch self {
        case let .failure(errorViewModel):
            return errorViewModel
        default:
            return nil
        }
    }

    func getLoadingViewModel() -> LoadingViewModel? {
        switch self {
        case let .loading(loadingViewModel):
            return loadingViewModel
        default:
            return nil
        }
    }

}


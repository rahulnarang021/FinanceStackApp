//
//  StockViewState.swift
//  FinanceStackApp
//
//  Created by RN on 15/05/21.
//

import Foundation
public enum StockViewState<T: Equatable>: Equatable {
    case loading(LoadingViewModel)
    case success(T)
    case failure(ErrorViewModel)
}

public struct ErrorViewModel: Equatable {
    public var message: String
    public init(message: String) {
        self.message = message
    }
}

public struct LoadingViewModel: Equatable {
    public var message: String

    public init(message: String) {
        self.message = message
    }
}


public extension StockViewState {
    func getViewModel() -> T? {
        switch self {
        case let .success(response):
            return response
        default:
            return nil
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


//
//  StockDetailAPIClient.swift
//  FinanceStackApp
//
//  Created by RN on 16/05/21.
//

import Foundation
import RxSwift

public class StockDetailAPIClient: StockDetailClient {
    let apiManagerInput: APIManagerInput
    public init(apiManager: APIManagerInput) {
        self.apiManagerInput = apiManager
    }

    public func fetchStockDetails(with symbol: String, region: String) -> Single<StockDetailModel> {
        return Single<StockDetailClient.Result>.create {[weak self] observer -> Disposable in
            self?.apiManagerInput.makeAPICall(apiConfiguration: StockDetailAPIConfiguration(symbol: symbol, region: region)) { (result: Result<StockDetailModel, APIError>) in

                switch result {
                case let .success(stockDetailResponse):
                    observer(.success(stockDetailResponse))
                case let .failure(error):
                    observer(.failure(error))
                }

            }
            return Disposables.create()
        }

    }
}

//
//  StockClient.swift
//  FinanceStackApp
//
//  Created by RN on 12/05/21.
//

import Foundation
import RxSwift

class StockLisAPIClient: StockListClient {

  private let apiManagerInput: APIManagerInput

  init(apiManagerInput: APIManagerInput) {
    self.apiManagerInput = apiManagerInput
  }

    func fetchStockListFromAPI() -> Single<StockListClient.Result> {

        return Single<StockListClient.Result>.create {[weak self] observer -> Disposable in
            self?.apiManagerInput.makeAPICall(apiConfiguration: StockListAPIConfiguration()) { (result: Result<StockListResponse, APIError>) in

                switch result {
                case let .success(stockListResponse):
                    observer(.success(stockListResponse.stockModels))
                case let .failure(error):
                    observer(.failure(error))
                }

            }
            return Disposables.create()
        }
    }
}

extension StockListResponse {
    var stockModels: [StockModel] {
        return self.marketSummaryAndSparkResponse.result
    }
}

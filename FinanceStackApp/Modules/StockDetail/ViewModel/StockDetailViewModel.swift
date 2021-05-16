//
//  StockDetailViewModel.swift
//  FinanceStackApp
//
//  Created by RN on 14/05/21.
//

import Foundation
import RxSwift
import RxCocoa


public class StockDetailViewModel: StockDetailViewModelProtocol {

    private let client: StockDetailClient
    private let stockModel: StockDetailInput

    private let disposeBag = DisposeBag()

    private var stockDetail: PublishRelay<Result<StockDetailModel, Error>> = PublishRelay<Result<StockDetailModel, Error>>()

    public var title: String {
        return (stockModel.shortName ?? stockModel.symbol)
    }

    public var viewStates: Driver<StockDetailViewState> { // Main viewState listened by View to refresh data on screen
        return Observable.merge(successState,
                                .just(.loading(LoadingViewModel(message: StockViewModelConstants.loadingMessage))))
            .asDriver(onErrorJustReturn: .failure(ErrorViewModel(message: StockViewModelConstants.errorMessage)))
    }

    private var successState: Observable<StockDetailViewState> {
        stockDetail
            .asObservable()
            .map { value ->
                StockDetailViewState in
                if let detailModel = try? value.get() {
                    return StockDetailViewState.success(StockDetailVM(stockDetailModel: detailModel))
                } else {
                    return StockDetailViewState.failure(ErrorViewModel(message: StockViewModelConstants.errorMessage))
                }
            }
            .asObservable()
    }

    public init(stockModel: StockDetailInput, client: StockDetailClient) {
        self.stockModel = stockModel
        self.client = client
    }

    public func fetchStockDetail() {
        client.fetchStockDetails(with: stockModel.symbol, region: stockModel.region)
            .subscribe {[weak self] stockDetailModel in
                guard let `self` = self else {
                    return
                }
                self.stockDetail.accept(.success(stockDetailModel))
            }
            onFailure: {[weak self] error in
                guard let `self` = self else {
                    return
                }
                self.stockDetail.accept(.failure(error))
            }
            .disposed(by: disposeBag)

    }
}

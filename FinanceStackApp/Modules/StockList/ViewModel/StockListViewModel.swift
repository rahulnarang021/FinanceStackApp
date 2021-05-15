//
//  StockListViewModel.swift
//  FinanceStackApp
//
//  Created by RN on 09/05/21.
//

import Foundation
import RxCocoa
import RxSwift

public class StockListViewModel {
    private var disposeBag = DisposeBag()
    private var client: StockListClient

    private var loadingMessage: String {
        return "Fetching data"
    }

    private var errorMessage: String {
        return "Failed to load data from server"
    }

    private var stockList: PublishRelay<[StockModel]> = PublishRelay<[StockModel]>()
    private var errorViewModel: PublishRelay<ErrorViewModel> = PublishRelay<ErrorViewModel>()
    private let searchHandler: ([StockModel], String) -> [StockModel]

    public var title: String {
        return "Stock List"
    }
    public let text: BehaviorRelay<String> = BehaviorRelay<String>(value: "") // fired initial value to create a single chain of events to filter data from searchText and response

    public let tap: PublishRelay<StockViewModel> = PublishRelay<StockViewModel>()

    public init(client: StockListClient,
                delay: Int,
                tapHandler: @escaping (StockModel) -> Void,
                searchHandler: @escaping ([StockModel], String) -> [StockModel]) {
        self.client = client
        self.searchHandler = searchHandler
        bindAPICall(withDelay: delay)
        bindTap(with: tapHandler)
    }

    private func bindAPICall(withDelay delay: Int) {
        Observable
            .merge(
                self.stockList
                    .asObservable()
                    .map { _ -> Void in },
                self.errorViewModel
                    .asObservable()
                    .map { _ -> Void in }
            )
            .subscribe(onNext: {[weak self] (Void) in
                self?.fetchStocksAfterDelay(delay)
            },
            onError: {[weak self] (Void) in
                self?.fetchStocksAfterDelay(delay)
            })
            .disposed(by: disposeBag)
    }

    private func bindTap(with tapHandler: @escaping (StockModel) -> Void) {
        tap.withLatestFrom(stockList) { (stockViewModel, stockModelList) -> StockModel in
            stockModelList.filter({ $0.symbol == stockViewModel.identifier}).first! // Assumed symbol has prime identifier it can be changed based on api consumption
        }
        .subscribe(onNext: { [tapHandler] stockModel in
            tapHandler(stockModel)
        })
        .disposed(by: disposeBag)
    }

    public var viewStates: Driver<StockViewState> { // Main viewState listened by View to refresh data on screen
        return Observable.merge(errorState,
                                searchFilterState,
                                .just(.loading(LoadingViewModel(message: self.loadingMessage))))
            .asDriver(onErrorJustReturn: .failure(ErrorViewModel(message: errorMessage)))
    }

    private var errorState: Observable<StockViewState> {
        errorViewModel
            .asObservable()
            .take(until: stockList)
            .map { error ->
                StockViewState in
                .failure(error)
            }
            .asObservable()
    }

    private var searchFilterState: Observable<StockViewState> {
        Observable.combineLatest(text
                                    .throttle(.milliseconds(200), scheduler: MainScheduler.instance)
                                    .distinctUntilChanged()
                                    .asObservable(),
                                 stockList
                                    .asObservable())
            .map { [weak self] (text, stockList) -> StockViewState in

                guard let `self` = self else {
                    return .failure(ErrorViewModel(message: ""))
                }
                return .success(self.searchHandler(stockList,text)
                                    .mapViewModel())
            }
            .asObservable()
    }

    // MARK: Fetch Stocks from API
    private func fetchStocksAfterDelay(_ delay: Int) { // called api after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(delay)) {[weak self] in
            self?.fetchStockList()
        }
    }

    public func fetchStockList() {
        self.client.fetchStockListFromAPI()
            .subscribe {[weak self] stockList in
                guard let `self` = self else {
                    return
                }
                self.updateState(withSuccess: stockList)
            } onFailure: { [weak self] error in
                guard let `self` = self else {
                    return
                }
                self.updateState(withError: error)
            }
            .disposed(by: disposeBag)
    }

    private func updateState(withSuccess stockModels: [StockModel]) {
        self.stockList.accept(stockModels) // Created separate observables for stockList and error to avoid checks on fetching values everytime from the stream
    }

    private func updateState(withError error: Error) {
        self.errorViewModel.accept(ErrorViewModel(message: self.errorMessage))
    }
}

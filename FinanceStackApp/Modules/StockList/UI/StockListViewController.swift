//
//  ViewController.swift
//  FinanceStackApp
//
//  Created by RN on 08/05/21.
//

import UIKit
import RxCocoa
import RxSwift

class StockListViewController: UIViewController, Storyboardable, Deinitcallable {

    @IBOutlet weak var searchBarView: UISearchBar!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loadingView: UIStackView!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var stockListTableView: UITableView!

    var onDeinit: (() -> Void)?
    var viewModel: StockListViewModelProtocol!

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = viewModel.title
        prepareAllViews()
        doBinding()
        viewModel.fetchStockList()
        // Do any additional setup after loading the view.
    }

    // MARK: - Do Binding for ViewModel and View
    private func doBinding() {
        bindTableViewData()
        bindSearchViewText()
        bindHiddenShowViewStates()
    }

    // MARK: - Do TableView Binding
    private func bindTableViewData() {
        viewModel.viewStates
            .map { $0.getViewModel() ?? [] }
            .asDriver()
            .drive(stockListTableView.rx.items(cellIdentifier: StockListCell.reusableIdentifier, cellType: StockListCell.self)) {row, element, cell in
                cell.bind(element)
            }
            .disposed(by: disposeBag)

        stockListTableView.rx.modelSelected(StockViewModel.self)
            .bind(to: self.viewModel.tap)
            .disposed(by: disposeBag)

    }

    // MARK: - Do SearchView Text Binding
    private func bindSearchViewText() {
        self.searchBarView.rx.text
            .map { text -> String in
                return (text ?? "")
            }
            .bind(to: self.viewModel.text)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Manage Views According to viewState
    private func bindHiddenShowViewStates() {
        self.viewModel.viewStates
            .drive(onNext: {[weak self] state in
                guard let self = self else {
                    return
                }
                self.configureViewState(state)
            })
            .disposed(by: disposeBag)
    }

    private func configureViewState(_ state: StockListViewState) {
        prepareAllViews()
        if let loadingViewModel = state.getLoadingViewModel() {
            loadingView.isHidden = false
            searchBarView.isHidden = true
            loadingLabel.text = loadingViewModel.message
        }
        else if let errorViewModel = state.getErrorViewModel() {
            errorLabel.isHidden = false
            searchBarView.isHidden = true
            errorLabel.text = errorViewModel.message
        }
        else if state.getViewModel() != nil {
            stockListTableView.isHidden = false
            searchBarView.isHidden = false
        }

    }
    
    func prepareAllViews() {
        stockListTableView.isHidden = true
        errorLabel.isHidden = true
        loadingView.isHidden = true
    }

    deinit {
        onDeinit?()
    }
}

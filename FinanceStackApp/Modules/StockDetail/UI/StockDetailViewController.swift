//
//  StockDetailViewController.swift
//  FinanceStackApp
//
//  Created by RN on 14/05/21.
//

import UIKit
import RxSwift
import RxCocoa

class StockDetailViewController: UIViewController, Storyboardable, Deinitcallable {
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var loadingView: UIStackView!
    @IBOutlet weak var tableView: UITableView!

    private let disposeBag = DisposeBag()
    var viewModel: StockDetailViewModelProtocol!
    var onDeinit: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = viewModel.title
        doBinding()
        viewModel.fetchStockDetail()
        // Do any additional setup after loading the view.
    }

    func doBinding() {
        bindTableViewData()
        bindHiddenShowViewStates()
    }

    // MARK: - Do TableView Binding
    private func bindTableViewData() {
        viewModel.viewStates
            .map { $0.getViewModel()?.summaryList ?? [] }
            .asDriver()
            .drive(tableView.rx.items(cellIdentifier: StockDetailTableViewCell.reusableIdentifier, cellType: StockDetailTableViewCell.self)) {row, element, cell in
                cell.bind(element)
            }
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

    // Using same logic in two screens which can be extracted out in a separate method call
    private func configureViewState(_ state: StockDetailViewState) {
        prepareAllViews()
        if let loadingViewModel = state.getLoadingViewModel() {
            loadingView.isHidden = false
            loadingLabel.text = loadingViewModel.message
        }
        else if let errorViewModel = state.getErrorViewModel() {
            errorLabel.isHidden = false
            errorLabel.text = errorViewModel.message
        }
        else if state.getViewModel() != nil {
            tableView.isHidden = false
        }

    }

    func prepareAllViews() {
        tableView.isHidden = true
        errorLabel.isHidden = true
        loadingView.isHidden = true
    }

    deinit {
        onDeinit?()
    }
}

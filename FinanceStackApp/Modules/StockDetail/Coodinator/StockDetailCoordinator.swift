//
//  StockDetailCoordinator.swift
//  FinanceStackApp
//
//  Created by RN on 14/05/21.
//

import UIKit

class StockDetailCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []

    var didFinish: (() -> Void)?

    weak var deallocallable: Deinitcallable?

    var navigationController: UINavigationController
    private let stockModel: StockModel

    init(stockModel: StockModel, navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.stockModel = stockModel
    }

    func start() {
        let detailVC = StockDetailViewController.instantiate()
        let viewModel = StockDetailViewModel(stockModel: stockModel)
        detailVC.viewModel = viewModel
        setDeallocallable(with: detailVC)
        navigationController.pushViewController(detailVC, animated: true)
    }
}

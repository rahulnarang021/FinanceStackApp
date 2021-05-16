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
    private let apiManager: APIManagerInput

    init(stockModel: StockModel, apiManager: APIManagerInput, navigationController: UINavigationController) {
        self.apiManager = apiManager
        self.navigationController = navigationController
        self.stockModel = stockModel
    }

    func start() {
        let detailVC = StockDetailViewController.instantiate()
        let client = StockDetailAPIClient(apiManager: apiManager)
        let stockDetailInput = StockDetailInput(shortName: stockModel.shortName,
                                                symbol: stockModel.symbol,
                                                region: stockModel.region)
        let viewModel = StockDetailViewModel(stockModel: stockDetailInput, client: client)
        detailVC.viewModel = viewModel
        setDeallocallable(with: detailVC)
        navigationController.pushViewController(detailVC, animated: true)
    }
}


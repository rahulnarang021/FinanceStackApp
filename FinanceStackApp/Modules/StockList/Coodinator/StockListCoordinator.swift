//
//  StockListCoordinator.swift
//  FinanceStackApp
//
//  Created by RN on 14/05/21.
//

import UIKit

class StockListCoordinator: Coordinator {
    var didFinish: (() -> Void)?

    let apiPeriodicIntervalInSeconds = 8
    weak var deallocallable: Deinitcallable? // Called on View Denit to remove from from ChildCoordinator

    lazy var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    let apiManager: APIManagerInput

    init(navigationController: UINavigationController, apiManager: APIManagerInput) {
        self.navigationController = navigationController
        self.apiManager = apiManager
    }

    func start() {
        let client = StockLisAPIClient(apiManagerInput: apiManager)
        let viewModel = StockListViewModel(client: client, delay: apiPeriodicIntervalInSeconds, tapHandler: {[weak self] stockModel in
            self?.pushDetailCoordinator(stockModel: stockModel)
        }, searchHandler: SearchQueryService.search)

        let stockListVC = StockListViewController.instantiate()
        stockListVC.viewModel = viewModel

        setDeallocallable(with: stockListVC)
        navigationController.pushViewController(stockListVC, animated: false)
    }

    func pushDetailCoordinator(stockModel: StockModel) {
        let coordinator = StockDetailCoordinator(stockModel: stockModel,
                                                 apiManager: apiManager,
                                                 navigationController: navigationController)
        coordinator.start()
        self.childCoordinators.append(coordinator)
        removeCoordinatorOnFinish(coordinator)
    }
}


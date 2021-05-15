//
//  Coordinator.swift
//  FinanceStackAppTests
//
//  Created by RN on 15/05/21.

import UIKit

protocol Deinitcallable: AnyObject {
    var onDeinit: (() -> Void)? { get set }
}

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
    var didFinish: (() -> Void)? { get set }
    func setDeallocallable(with object: Deinitcallable)
    var deallocallable: Deinitcallable? { get set }
    func removeCoordinatorOnFinish(_ coordinator: Coordinator)
}

extension Coordinator {
    func setDeallocallable(with object: Deinitcallable) {
        deallocallable?.onDeinit = nil
        object.onDeinit = {[weak self] in
            self?.didFinish?()
        }
        deallocallable = object
    }

    func removeCoordinatorOnFinish(_ coordinator: Coordinator) {
        coordinator.didFinish = {[weak self, weak coordinator] in
            guard let self = self, let coordinator = coordinator else {
                return
            }
            self.childCoordinators.removeAll(where: {childCoordinator -> Bool in
                return childCoordinator === coordinator
            })
        }
    }
}

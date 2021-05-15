//
//  AppDelegate.swift
//  FinanceStackApp
//
//  Created by RN on 08/05/21.
//

import UIKit
import RxSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var coordinator: Coordinator?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    let navigationController = UINavigationController()
    coordinator = StockListCoordinator(navigationController: navigationController)

    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.window?.rootViewController = navigationController
    self.window?.makeKeyAndVisible()

    coordinator?.start()
    return true
  }
}

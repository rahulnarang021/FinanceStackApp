//
//  File.swift
//  FinanceStackAppTests
//
//  Created by RN on 16/05/21.
//

import Foundation
import RxSwift

@testable import FinanceStackApp

class SingleSpy<T> {

    let disposeBag = DisposeBag()
    var successResults: [T] = []
    var errorResults: [APIError] = []

    init(_ single: Single<T>) {
        single.subscribe {[weak self] models in
            self?.successResults.append(models)
        } onFailure: {[weak self] error in
            self?.errorResults.append(error as! APIError) // force unwrapping as it should crash on test run if incorrect
        }
        .disposed(by: disposeBag)

    }
}


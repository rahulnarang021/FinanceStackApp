//
//  StateSpy.swift
//  FinanceStackAppTests
//
//  Created by RN on 16/05/21.
//

import Foundation
import RxSwift
import RxCocoa

class StateSpy<T> {
    var values: [T] = []
    var disposbag = DisposeBag()
    init(_ state: Driver<T>) {
        state
            .asObservable()
            .subscribe (onNext: { state in
                self.values.append(state)
            }).disposed(by: disposbag)
    }
}


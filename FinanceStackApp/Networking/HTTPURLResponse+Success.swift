//
//  HTTPURLResponse+Success.swift
//  FinanceStackApp
//
//  Created by RN on 15/05/21.
//

import Foundation

extension HTTPURLResponse {
    func isSuccess() -> Bool {
        return (statusCode >= 200 && statusCode < 400)// failure check
    }
}

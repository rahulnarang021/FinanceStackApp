//
//  APIManagerSpy.swift
//  FinanceStackAppTests
//
//  Created by RN on 16/05/21.
//

import Foundation
import RxSwift

@testable import FinanceStackApp

class APIManagerSpy<Response>: APIManagerInput {

    var messages: [APIConfiguration] = []
    var failureError: APIError?
    var successResults: Response?

    var messageCount: Int {
        return messages.count
    }

    func makeAPICall<T>(apiConfiguration: APIConfiguration,
                        completion: @escaping (Result<T, APIError>) -> Void) {
        messages.append(apiConfiguration)
        if let error = failureError {
            completion(.failure(error))
        }
        if let response = successResults {
            completion(.success(response as! T)) // force unwrapping as it should crash if expectation is wrong in tests
        }
    }
}

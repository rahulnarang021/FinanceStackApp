//
//  APIManagerInput.swift
//  FinanceStackAppTests
//
//  Created by RN on 15/05/21.
//

import Foundation

public struct APIError: Error, Equatable {// created custom error object to be passed on views
    public var code: Int?
    public var message: String

    init(error: Error?) {
        message = error?.localizedDescription ?? "Something went wrong"
    }

    init(message: String) {
        self.message = message
    }
}

public enum RequestType: String {
    case GET = "GET";
    case POST = "POST";
    case PUT = "PUT";
    case DELETE = "DELETE";
}

public protocol APIManagerInput {// Impelemented by APIManager to make api call
    func makeAPICall<T: Decodable>(apiConfiguration: APIConfiguration, completion: @escaping ((Result<T, APIError>) -> Void))
}

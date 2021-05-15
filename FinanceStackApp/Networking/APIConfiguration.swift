//
//  APIConfiguration.swift
//  FinanceStackAppTests
//
//  Created by RN on 15/05/21.
//

import Foundation
public protocol APIConfiguration {//  Used by APIManager to make api call
    func getGetParams() -> [String: String?]?
    func getHeaders() -> [String: String]?
    func getUrl() -> URL
    func getRequestType() -> RequestType
    func getRequestTimeout() -> TimeInterval
    func getPostParams() -> [String: Any?]?
}

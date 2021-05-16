//
//  StockListAPIConfiguration.swift
//  FinanceStackApp
//
//  Created by RN on 12/05/21.
//

import Foundation

struct StockListAPIConfiguration: APIConfiguration {
  func getGetParams() -> [String : String?]? {
    return [StockListAPIConstants.regionKey: StockListAPIConstants.regionValue]
  }

  func getHeaders() -> [String : String]? {
    var headers: [String: String] = [:]
    headers[StockAPIConstants.rapidAPIKey] = StockAPIConstants.rapidAPIKeyValue
    headers[StockAPIConstants.rapidAPIHost] = StockAPIConstants.rapidAPIHostValue
    return headers
  }

  func getUrl() -> URL {
    return StockListAPIConstants.rapidAPIURL
  }

  func getRequestType() -> RequestType {
    return .GET
  }

  func getRequestTimeout() -> TimeInterval {
    return StockAPIConstants.rapidAPITimeout
  }

  func getPostParams() -> [String : Any?]? {
    return nil
  }
}

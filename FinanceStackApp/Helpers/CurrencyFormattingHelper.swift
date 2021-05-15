//
//  CurrencyFormattingHelper.swift
//  FinanceStackApp
//
//  Created by RN on 14/05/21.
//

import Foundation

class CurrencyFormattingHelper {

  static let shared = CurrencyFormattingHelper()

  private lazy var currencyFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.locale = Locale.US
    return formatter
  }()

  func formatCurrency(_ value: Double) -> String {
    self.currencyFormatter.string(from: NSNumber(value: value)) ?? ""
  }
}

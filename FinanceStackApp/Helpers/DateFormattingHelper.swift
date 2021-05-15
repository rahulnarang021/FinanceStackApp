//
//  DateFormattingHelper.swift
//  FinanceStackApp
//
//  Created by RN on 14/05/21.
//

import Foundation

class DateFormattingHelper {
    static let shared = DateFormattingHelper()

    private lazy var dateFormatter: DateFormatter = {
      let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale.US
        return dateFormatter
    }()

    func formattedDate(_ date: Date) -> String {
        return dateFormatter.string(from: date)
    }
}

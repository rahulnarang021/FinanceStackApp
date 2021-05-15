//
//  Array_OptionalMinMax.swift
//  FinanceStackApp
//
//  Created by RN on 15/05/21.
//

import Foundation
extension Array where Element == Double? {
    func maxElement() -> Double? {
        var maxElement: Double? = nil
        for element in self {
            if let value = element {
                if let maxValue = maxElement {
                    maxElement = Swift.max(maxValue, value)
                } else {
                    maxElement = value
                }
            }
        }
        return maxElement
    }

    func minElement() -> Double? {
        var minElement: Double? = nil
        for element in self {
            if let value = element {
                if let minValue = minElement {
                    minElement = Swift.min(minValue, value)
                } else {
                    minElement = value
                }
            }
        }
        return minElement
    }
}

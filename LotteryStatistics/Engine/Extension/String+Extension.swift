//
//  String.swift
//  LotteryStatistics
//
//  Created by levantAJ on 11/3/18.
//  Copyright © 2018 levantAJ. All rights reserved.
//

import Foundation

extension String {
    func date(format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
    
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }

    func toInt() -> Int? {
        return Int(self)
    }

    func toDouble() -> Double? {
        return Double(self)
    }
}

// MARK: - Tracking.EventName

extension String {
    static let eventNameDraw = "draw"
}

// MARK: - EventParams

extension String {
    static let eventParamId = "id"
    static let eventParamDate = "date"
    static let eventParamNumber = "number"
}

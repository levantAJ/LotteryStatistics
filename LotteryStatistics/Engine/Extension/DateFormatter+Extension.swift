//
//  DateFormatter.swift
//  LotteryStatistics
//
//  Created by levantAJ on 18/3/18.
//  Copyright © 2018 levantAJ. All rights reserved.
//

import UIKit

extension DateFormatter {
    static let ddMMyyyyFormat = "dd-MM-yyyy"
    
    static var ddMMyyyy: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = ddMMyyyyFormat
        return formatter
    }()

    static let ddMMYYY: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter
    }()
}

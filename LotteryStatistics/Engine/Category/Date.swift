//
//  Date.swift
//  LotteryStatistics
//
//  Created by levantAJ on 11/3/18.
//  Copyright © 2018 levantAJ. All rights reserved.
//

import Foundation

extension Date {
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    
    var shortFormatString: String {
        return string(dateFormat: DateFormatter.ddMMyyyyFormat)
    }
    
    func string(dateFormat: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return formatter.string(from: self)
    }
}

//
//  Crawl.swift
//  LotteryStatistics
//
//  Created by levantAJ on 12/3/18.
//  Copyright © 2018 levantAJ. All rights reserved.
//

import Foundation

struct Crawl: Codable {
    let date: Date
    let hasData: Bool
    
    var json: [String: Any] {
        return [
            "date": date.shortFormatString,
            "hasData": hasData,
        ]
    }
}

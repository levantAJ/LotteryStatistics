//
//  Draw.swift
//  LotteryStatistics
//
//  Created by levantAJ on 11/3/18.
//  Copyright © 2018 levantAJ. All rights reserved.
//

import Foundation

struct Draw {
    let id: String
    let date: Date
    let numbers: [Int]
    let results: [DrawResult]
    
    
    var json: [String: Any] {
        var resultsJSON: [[String:Any]] = []
        for result in results {
            resultsJSON.append(result.json)
        }
        return [
            "id": id,
            "date": date.shortFormatString,
            "numbers": numbers,
            "results": resultsJSON
        ]
    }
}

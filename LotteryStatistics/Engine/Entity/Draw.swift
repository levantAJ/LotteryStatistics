//
//  Draw.swift
//  LotteryStatistics
//
//  Created by levantAJ on 11/3/18.
//  Copyright © 2018 levantAJ. All rights reserved.
//

import Foundation

struct Draw: Codable, Dateable, JSONParsable {
    let id: String
    let date: Date
    let numbers: [Int]
    let results: [DrawResult]
    
    init(id: String, date: Date, numbers: [Int], results: [DrawResult]) {
        self.id = id
        self.date = date
        self.numbers = numbers
        self.results = results
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        numbers = try container.decode([Int].self, forKey: .numbers)
        results = try container.decodeIfPresent([DrawResult].self, forKey: .results) ?? []
        
        let formatter = DateFormatter.ddMMYYY
        if let parsingDate = formatter.date(from: try container.decode(String.self, forKey: .date)) {
            date = parsingDate
        } else {
            throw DecodingError.dataCorruptedError(forKey: .date, in: container, debugDescription: "Date string does not match format expected by formatter.")
        }
    }
    
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

// MARK: - FirebaseStorable

extension Draw: FirebaseStorable {
    var firebaseKeyPath: String {
        return "draws"
    }
}

//
//  DrawResult.swift
//  LotteryStatistics
//
//  Created by levantAJ on 11/3/18.
//  Copyright © 2018 levantAJ. All rights reserved.
//

struct DrawResult {
    let name: String
    let matching: Int
    let numberOfPrize: Int
    let prizeAmount: String
    
    var json: [String: Any] {
        return [
            "name": name,
            "matching": matching,
            "numberOfPrize": numberOfPrize,
            "prizeAmount": prizeAmount,
        ]
    }
}

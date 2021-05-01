//
//  Tracker.swift
//  LotteryStatistics
//
//  Created by Tai Le on 01/05/2021.
//  Copyright © 2021 levantAJ. All rights reserved.
//

import Firebase

final class Tracker {
    lazy var firebaseDatabase = FirebaseDatabase()

    func track(draws: [Draw]) {
        for draw in draws {
            track(draw: draw)
        }
    }

    func track(draw: Draw) {
        firebaseDatabase.isExisted(Tracking.self, date: draw.date) { [weak self] (isExisted) in
            guard !isExisted else { return }
            var parameters: [String: Any] = [:]
            parameters[.eventParamId] = draw.id
            parameters[.eventParamDate] = DateFormatter.ddMMYYY.string(from: draw.date)
            for (index, number) in draw.numbers.enumerated() {
                parameters["\(String.eventParamNumber)_\(index)"] = number
            }
            Analytics.logEvent(.eventNameDraw, parameters: parameters)
            let tracking = Tracking(date: draw.date, providers: [.firebase])
            self?.firebaseDatabase.saveIfNeeded(tracking)
        }
    }
}

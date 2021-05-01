//
//  Crawl.swift
//  LotteryStatistics
//
//  Created by levantAJ on 12/3/18.
//  Copyright © 2018 levantAJ. All rights reserved.
//

import Foundation

struct Crawl: Codable, Dateable, JSONParsable {
    let date: Date
    let hasData: Bool
    
    var json: [String: Any] {
        return [
            "date": date.shortFormatString,
            "hasData": hasData,
        ]
    }
}

// MARK: - FirebaseStorable

extension Crawl: FirebaseStorable {
    var firebaseKeyPath: String {
        return "crawls"
    }
}

struct Tracking: Codable, Dateable, JSONParsable {
    let date: Date
    let providers: [TrackingProvider]

    var json: [String: Any] {
        return [
            "date": date.shortFormatString,
            "providers": providers.map { $0.rawValue }
        ]
    }
}

// MARK: - FirebaseStorable

extension Tracking: FirebaseStorable {
    var firebaseKeyPath: String {
        return "tracking"
    }
}

enum TrackingProvider: String, Codable {
    case firebase
}

protocol Dateable {
    var date: Date { get }
}

protocol JSONParsable {
    var json: [String: Any] { get }
}

protocol FirebaseStorable {
    var firebaseKeyPath: String { get }
}

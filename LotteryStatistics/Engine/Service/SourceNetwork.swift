//
//  SourceNetwork.swift
//  LotteryStatistics
//
//  Created by levantAJ on 11/3/18.
//  Copyright © 2018 levantAJ. All rights reserved.
//

import Foundation
import FirebasePerformance

enum Response<Value> {
    case success(Value)
    case failure(Error)
}

class SourceNetwork {
    func request(url: URL, completion: @escaping (Response<Data>) -> Void) {
        let metric = HTTPMetric(url: url, httpMethod: .get)
        metric?.start()
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            metric?.stop()
            if let data = data {
                completion(.success(data))
            } else if let error = error {
                completion(.failure(error))
            } else {
                let error = NSError(domain: "com.levantAJ.LotteryStatistics.error", code: -1, userInfo: [NSLocalizedDescriptionKey:"Unspecific error"])
                completion(.failure(error))
            }
        }
        task.resume()
    }

    func request(
        url: URL,
        httpMethod: Method,
        httpBody: Data?,
        allHTTPHeaderFields: [String: String]?,
        completion: @escaping (Response<Data>) -> Void
    ) {
        let metric = HTTPMetric(url: url, httpMethod: .get)
        metric?.start()
        var request = URLRequest(url: url)
        request.httpBody = httpBody
        request.allHTTPHeaderFields = allHTTPHeaderFields
        request.httpMethod = httpMethod.rawValue
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            metric?.stop()
            if let data = data {
                completion(.success(data))
            } else if let error = error {
                completion(.failure(error))
            } else {
                let error = NSError(domain: "com.levantAJ.LotteryStatistics.error", code: -1, userInfo: [NSLocalizedDescriptionKey:"Unspecific error"])
                completion(.failure(error))
            }
        }
        task.resume()
    }

    func request(
        request: URLRequest,
        completion: @escaping (Response<Data>) -> Void
    ) {
        let metric = HTTPMetric(url: request.url!, httpMethod: .get)
        metric?.start()
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            metric?.stop()
            if let data = data {
                completion(.success(data))
            } else if let error = error {
                completion(.failure(error))
            } else {
                let error = NSError(domain: "com.levantAJ.LotteryStatistics.error", code: -1, userInfo: [NSLocalizedDescriptionKey:"Unspecific error"])
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

extension SourceNetwork {
    enum Method: String {
        case get = "GET"
        case post = "POST"
    }
}

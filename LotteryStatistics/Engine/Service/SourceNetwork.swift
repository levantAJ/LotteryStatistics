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
    
}

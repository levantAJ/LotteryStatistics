//
//  Crawler.swift
//  LotteryStatistics
//
//  Created by levantAJ on 11/3/18.
//  Copyright © 2018 levantAJ. All rights reserved.
//

import Foundation

class Crawler {
    let network = SourceNetwork()
    let database = FirebaseDatabase()
    
    func crawl() {
        let url = URL(string: "http://vietlott.vn/en/trung-thuong/ket-qua-trung-thuong/mega-6-45/?dayPrize=02/03/2018")!
        network.request(url: url) { [weak self] (response) in
            guard let strongSelf = self else { return }
            switch response {
            case .success(let data):
                if let html = String(data: data, encoding: .utf8),
                    let draw = HtmlParser(html: html)?.draw {
                    strongSelf.database.saveIfNeeded(draw: draw)
                } else {
                    debugPrint("Cannot parse data to string")
                }
            case .failure(let error):
                debugPrint("Cannot make a request with error: ", error)
            }
        }
    }
}

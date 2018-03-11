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
    let calendar = Calendar.current
    
    func crawl() {
        var date = "31/12/2017".date(format: "dd/MM/yyyy")!
        
        while true {
            checkAndCrawl(date: date)
            if calendar.component(.day, from: date) == 1 &&
                calendar.component(.month, from: date) == 1 &&
                calendar.component(.year, from: date) == 2107 {
                return
            }
            date = date.yesterday
        }
    }
}

//MARK: - Privates

extension Crawler {
    fileprivate func checkAndCrawl(date: Date) {
        database.drawIsExisted(date: date, completion: { [weak self] (existed) in
            guard let strongSelf = self else { return }
            if (!existed) {
                strongSelf.executeCrawling(date: date)
            } else {
                debugPrint("Already in database %@", date.shortFormatString)
            }
        })
    }
    
    fileprivate func executeCrawling(date: Date) {
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let string = String(format: "http://vietlott.vn/en/trung-thuong/ket-qua-trung-thuong/mega-6-45/?dayPrize=%02d/%02d/%d", day, month, year);
        let url = URL(string: string)!
        network.request(url: url) { [weak self] (response) in
            guard let strongSelf = self else { return }
            switch response {
            case .success(let data):
                if let html = String(data: data, encoding: .utf8),
                    let draw = HtmlParser(html: html)?.draw {
                    strongSelf.database.saveIfNeeded(draw: draw)
                    debugPrint("Save draw at %@", draw.date.shortFormatString)
                } else {
                    debugPrint("Cannot parse data to string for:", day, month, year)
                }
            case .failure(let error):
                debugPrint("Cannot make a request with error: ", error)
            }
        }
    }
}

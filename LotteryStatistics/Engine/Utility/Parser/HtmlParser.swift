//
//  HtmlParser.swift
//  LotteryStatistics
//
//  Created by levantAJ on 11/3/18.
//  Copyright © 2018 levantAJ. All rights reserved.
//

import Fuzi

class HtmlParser {
    let doc: HTMLDocument
    
    init?(html: String) {
        do {
            doc = try HTMLDocument(string: html, encoding: String.Encoding.utf8)
        } catch {
            return nil
        }
    }

    var draw: Draw? {
        if let idAndDate = drawIdAndDate,
            let numbers = drawNumbers,
            let results = drawResults {
            return Draw(id: idAndDate.id, date: idAndDate.date, numbers: numbers, results: results)
        }
        return nil
    }
    
    func nodeSet(xpath: String) -> NodeSet {
        return doc.xpath(xpath)
    }
}

// MARK: - Privates

extension HtmlParser {
    fileprivate var drawIdAndDate: (id: String, date: Date)? {
        let titleNodeSet = nodeSet(xpath: "//div[@class=\"box-result-detail\"]/p[@class=\"time-result\"]/b")
        if let titleAndDateComponents = titleNodeSet.first?.stringValue.components(separatedBy: "|"),
            let id = titleAndDateComponents.first?.components(separatedBy: "#").last?.trimmingCharacters(in: .whitespacesAndNewlines),
            let dateString = titleAndDateComponents.last?.components(separatedBy: " ").last?.trimmingCharacters(in: .whitespacesAndNewlines),
            let date = dateString.date(format: "dd/MM/yyyy") {
            return (id, date)
        }
        return nil
    }
    
    fileprivate var drawNumbers: [Int]? {
        let numbersNodeSet = nodeSet(xpath: "//html/body/div/div/div/div/div/div/ul/img")
        var numbers: [Int] = []
        for node in numbersNodeSet {
            if let src = node["src"],
                let imageURL = URL(string: src)?.deletingPathExtension(),
                let number = Int(imageURL.lastPathComponent) {
                numbers.append(number)
            }
        }
        if numbers.isEmpty {
            return nil
        }
        return numbers
    }
    
    fileprivate var drawResults: [DrawResult]? {
        let resultNodeSet = nodeSet(xpath: "//div[@class=\"result clearfix table-responsive\"]/table[@class=\"table table-striped\"]/tbody/tr")
        var resutls: [DrawResult] = []
        for node in resultNodeSet {
            var name: String?
            var matching: Int?
            var numberOfPrize: Int?
            var prizeAmount: String?
            for (index, child) in node.children.enumerated() {
                if index == 0 {
                    name = child.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
                } else if index == 1 {
                    matching = Int(child.stringValue.digits)
                } else if index == 2 {
                    numberOfPrize = Int(child.stringValue.trimmingCharacters(in: .whitespacesAndNewlines))
                } else if index == 3 {
                    prizeAmount = child.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
                }
            }
            if let name = name,
                let matching = matching,
                let numberOfPrize = numberOfPrize,
                let prizeAmount = prizeAmount {
                resutls.append(DrawResult(name: name, matching: matching, numberOfPrize: numberOfPrize, prizeAmount: prizeAmount))
            }
        }
        if resutls.isEmpty {
            return nil
        }
        return resutls
    }
}

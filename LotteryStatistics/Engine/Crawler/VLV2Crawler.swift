//
//  VLV2Crawler.swift
//  LotteryStatistics
//
//  Created by Tai Le on 30/04/2021.
//  Copyright © 2021 levantAJ. All rights reserved.
//

import UIKit
import Fuzi
import SafetyCollection

final class VLV2Crawler {
    lazy var network = SourceNetwork()
    lazy var parser = VLV2HTMLParser()

    func crawl() {
        firstRequest { [weak self] in
            self?.secondRequest { [weak self] in
                self?.mainRequest(pageIndex: 1) { [weak self] response in
                    self?.parser.parse(html: response.value.HtmlContent)
                }
            }
        }
    }
}

extension VLV2Crawler {
    func firstRequest(completion: (() -> Void)?) {
        request(request: makeFirstRequest()) { (result) in
            if (try? result.get()) != nil {
                completion?()
            }
        }
    }

    func secondRequest(completion: (() -> Void)?) {
        request(request: makeSecondRequest()) { (result) in
            if (try? result.get()) != nil {
                completion?()
            }
        }
    }

    func mainRequest(pageIndex: Int, completion: ((VLV2Response) -> Void)?) {
        request(request: makeMainRequest(pageIndex: pageIndex)) { (result) in
            switch result {
            case .success(let data):
                do {
                    let response = try JSONDecoder().decode(VLV2Response.self, from: data)
                    completion?(response)
                } catch {
                    print("⛔️ Cannot parse page: \(pageIndex) with error \(error)")
                }
            case .failure(let error):
                print("⛔️ Request page: \(pageIndex) failed with error \(error)")
            }
        }
    }

    func request(request: URLRequest, completion: ((Result<Data, Error>) -> Void)?) {
        print("Requesting \(request.url!.absoluteString)...")
        network.request(request: request) { result in
            switch result {
            case .success(let data):
                print("✅ \(request.url!.absoluteString) success")
                completion?(.success(data))
            case .failure(let error):
                print("⛔️ \(request.url!.absoluteString) with error: \(error)")
                completion?(.failure(error))
            }
        }
    }

    private func makeFirstRequest() -> URLRequest {
        var request = URLRequest(url: URL(string: "https://www.vietlott.vn/ajaxpro/Vietlott.Utility.WebEnvironments,Vietlott.Utility.ashx")!,timeoutInterval: Double.infinity)
        request.addValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.85 Safari/537.36", forHTTPHeaderField: "User-Agent")
        request.addValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
        request.addValue("?0", forHTTPHeaderField: "sec-ch-ua-mobile")
        request.addValue("fa70a63b6c4ca19b57b1a1c03898e88cb33a103592676b3473f989293ff97a8c", forHTTPHeaderField: "X-Ajax-Token")
        request.addValue("no-cache", forHTTPHeaderField: "Pragma")
        request.addValue("cors", forHTTPHeaderField: "Sec-Fetch-Mode")
        request.addValue("www.vietlott.vn", forHTTPHeaderField: "Host")
        request.addValue("no-cache", forHTTPHeaderField: "Cache-Control")
        request.addValue("same-origin", forHTTPHeaderField: "Sec-Fetch-Site")
        request.addValue("empty", forHTTPHeaderField: "Sec-Fetch-Dest")
        request.addValue("https://www.vietlott.vn", forHTTPHeaderField: "Origin")
        request.addValue("\" Not A;Brand\";v=\"99\", \"Chromium\";v=\"90\", \"Google Chrome\";v=\"90\"", forHTTPHeaderField: "sec-ch-ua")
        request.addValue("167a86d57619ef66ac5fecd33b396f66600ecf705c8a5fd1b535d5d41d9c7a521240dd1dcad1377e", forHTTPHeaderField: "X-csrftoken")
        request.addValue("https://www.vietlott.vn/vi/trung-thuong/ket-qua-trung-thuong/winning-number-645", forHTTPHeaderField: "Referer")
        request.addValue("en-US,en;q=0.9,vi;q=0.8,ko;q=0.7", forHTTPHeaderField: "Accept-Language")
        request.addValue("*/*", forHTTPHeaderField: "Accept")
        request.addValue("keep-alive", forHTTPHeaderField: "Connection")
        request.addValue("text/plain; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.addValue("ServerSideFrontEndCreateRenderInfo", forHTTPHeaderField: "X-AjaxPro-Method")
        request.addValue("29", forHTTPHeaderField: "Content-Length")
        request.addValue("session-cookie=167a8766cfd4383d78a0712a18991a241d1ae4223b13d940e48c06316169d2f247cd0c99b2d6c7e623bc870fd3a3d4a5", forHTTPHeaderField: "Cookie")
        request.httpMethod = "POST"
        let parameters = "{\"SiteId\":\"main.frontend.vi\"}"
        let postData = parameters.data(using: .utf8)
        request.httpBody = postData
        return request
    }

    private func makeSecondRequest() -> URLRequest {
        let parameters = "2537422532326576656e74253232253341253232757365725f636f6f72647325323225324325323264617461253232253341253542253542313030342532433937352535442532432535423130303425324339373525354425324325354231303034253243393735253544253243253542373436253243313333253544253243253542363131253243353625354425324325354236393225324332353625354425324325354236303925324332323325354425324325354232373825324337372535442532432535423239322532433737253544253243253542343531253243353739253544253243253542343033253243313137392535442532432535423130343725324339363225354425324325354231303538253243393634253544253544253243253232686f73742532322533412532327777772e766965746c6f74742e766e253232253744"
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "https://www.vietlott.vn/55ba03d95337b9c47ad4a42e88f30289")!,timeoutInterval: Double.infinity)
        request.addValue("no-cache", forHTTPHeaderField: "Pragma")
        request.addValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
        request.addValue("en-US,en;q=0.9,vi;q=0.8,ko;q=0.7", forHTTPHeaderField: "Accept-Language")
        request.addValue("660", forHTTPHeaderField: "Content-Length")
        request.addValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.85 Safari/537.36", forHTTPHeaderField: "User-Agent")
        request.addValue("no-cache", forHTTPHeaderField: "Cache-Control")
        request.addValue("\" Not A;Brand\";v=\"99\", \"Chromium\";v=\"90\", \"Google Chrome\";v=\"90\"", forHTTPHeaderField: "sec-ch-ua")
        request.addValue("?0", forHTTPHeaderField: "sec-ch-ua-mobile")
        request.addValue("*/*", forHTTPHeaderField: "Accept")
        request.addValue("https://www.vietlott.vn/vi/trung-thuong/ket-qua-trung-thuong/winning-number-645", forHTTPHeaderField: "Referer")
        request.addValue("www.vietlott.vn", forHTTPHeaderField: "Host")
        request.addValue("cors", forHTTPHeaderField: "Sec-Fetch-Mode")
        request.addValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        request.addValue("167a86d57619ef66ac5fecd33b396f66600ecf705c8a5fd1b535d5d41d9c7a521240dd1dcad1377e", forHTTPHeaderField: "X-csrftoken")
        request.addValue("https://www.vietlott.vn", forHTTPHeaderField: "Origin")
        request.addValue("b3841ba883cf1d896add1c740c344c843e9b532bf7d4003db55baf82c497fcd9", forHTTPHeaderField: "X-Ajax-Token")
        request.addValue("empty", forHTTPHeaderField: "Sec-Fetch-Dest")
        request.addValue("same-origin", forHTTPHeaderField: "Sec-Fetch-Site")
        request.addValue("keep-alive", forHTTPHeaderField: "Connection")
        request.addValue("session-cookie=167a8766cfd4383d78a0712a18991a241d1ae4223b13d940e48c06316169d2f247cd0c99b2d6c7e623bc870fd3a3d4a5; csrf-token-name=csrftoken; csrf-token-value=167a881db94c0a1d2cdfcbb4e003ece2930171fe20808b1cb31ed057658fc352f7da2e002d2ff85f", forHTTPHeaderField: "Cookie")

        request.httpMethod = "POST"
        request.httpBody = postData
        return request
    }

    private func makeMainRequest(pageIndex: Int) -> URLRequest {
        let parameters = "{\"ORenderInfo\":{\"SiteId\":\"main.frontend.vi\",\"SiteAlias\":\"main.vi\",\"UserSessionId\":\"\",\"SiteLang\":\"vi\",\"IsPageDesign\":false,\"ExtraParam1\":\"\",\"ExtraParam2\":\"\",\"ExtraParam3\":\"\",\"SiteURL\":\"\",\"WebPage\":null,\"SiteName\":\"Vietlott\",\"OrgPageAlias\":null,\"PageAlias\":null,\"FullPageAlias\":null,\"RefKey\":null,\"System\":1},\"Key\":\"1028d502\",\"GameDrawId\":\"\",\"ArrayNumbers\":[[\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\"],[\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\"],[\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\"],[\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\"],[\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\"],[\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\"]],\"CheckMulti\":false,\"PageIndex\":\(pageIndex)}"
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "https://www.vietlott.vn/ajaxpro/Vietlott.PlugIn.WebParts.Game645CompareWebPart,Vietlott.PlugIn.WebParts.ashx")!,timeoutInterval: Double.infinity)
        request.addValue("cors", forHTTPHeaderField: "Sec-Fetch-Mode")
        request.addValue("en-US,en;q=0.9,vi;q=0.8,ko;q=0.7", forHTTPHeaderField: "Accept-Language")
        request.addValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.85 Safari/537.36", forHTTPHeaderField: "User-Agent")
        request.addValue("empty", forHTTPHeaderField: "Sec-Fetch-Dest")
        request.addValue("?0", forHTTPHeaderField: "sec-ch-ua-mobile")
        request.addValue("no-cache", forHTTPHeaderField: "Pragma")
        request.addValue("726", forHTTPHeaderField: "Content-Length")
        request.addValue("no-cache", forHTTPHeaderField: "Cache-Control")
        request.addValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
        request.addValue("ServerSideDrawResult", forHTTPHeaderField: "X-AjaxPro-Method")
        request.addValue("\" Not A;Brand\";v=\"99\", \"Chromium\";v=\"90\", \"Google Chrome\";v=\"90\"", forHTTPHeaderField: "sec-ch-ua")
        request.addValue("167a86d57619ef66ac5fecd33b396f66600ecf705c8a5fd1b535d5d41d9c7a521240dd1dcad1377e", forHTTPHeaderField: "X-csrftoken")
        request.addValue("keep-alive", forHTTPHeaderField: "Connection")
        request.addValue("same-origin", forHTTPHeaderField: "Sec-Fetch-Site")
        request.addValue("text/plain; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.addValue("https://www.vietlott.vn", forHTTPHeaderField: "Origin")
        request.addValue("c1057f1d3dffd4dbb37a1c59fbe7d7b963f9ba9ff5949801bbd5b7f3bc9bf454", forHTTPHeaderField: "X-Ajax-Token")
        request.addValue("*/*", forHTTPHeaderField: "Accept")
        request.addValue("www.vietlott.vn", forHTTPHeaderField: "Host")
        request.addValue("https://www.vietlott.vn/vi/trung-thuong/ket-qua-trung-thuong/winning-number-645", forHTTPHeaderField: "Referer")
        request.addValue("session-cookie=167a8766cfd4383d78a0712a18991a241d1ae4223b13d940e48c06316169d2f247cd0c99b2d6c7e623bc870fd3a3d4a5; csrf-token-name=csrftoken; csrf-token-value=167a881db94c0a1d2cdfcbb4e003ece2930171fe20808b1cb31ed057658fc352f7da2e002d2ff85f", forHTTPHeaderField: "Cookie")

        request.httpMethod = "POST"
        request.httpBody = postData
        return request
    }
}

struct VLV2Response: Codable {
    var value: VLV2ResponseValue
}

struct VLV2ResponseValue: Codable {
    var HtmlContent: String
}

class VLV2HTMLParser {
    func parse(html: String) {
        do {
            let doc = try HTMLDocument(string: html, encoding: String.Encoding.utf8)
            let table = doc.xpath("//table/tbody/tr")
            for row in table {
                let tds = row.xpath("td")
                let date = tds[safe: 0]?.stringValue
                let rounds = tds[safe: 1]?.stringValue

                let numbers = tds[safe: 2]?.xpath("div/span")
                print(numbers?[safe: 0]?.stringValue)
                print(numbers?[safe: 1]?.stringValue)
                print(numbers?[safe: 2]?.stringValue)
                print(numbers?[safe: 3]?.stringValue)
                print(numbers?[safe: 4]?.stringValue)
                print(numbers?[safe: 5]?.stringValue)
            }
            print(table)
        } catch {
            print("⛔️ Cannot parse \(html)")
        }
    }
}

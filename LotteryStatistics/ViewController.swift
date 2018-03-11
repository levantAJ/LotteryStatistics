//
//  ViewController.swift
//  LotteryStatistics
//
//  Created by levantAJ on 11/3/18.
//  Copyright © 2018 levantAJ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var crawler: Crawler!

    override func viewDidLoad() {
        super.viewDidLoad()
        crawler = Crawler()
        crawler.crawl()
    }
    
}


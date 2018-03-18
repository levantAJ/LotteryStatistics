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
    var db: FirebaseDatabase!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if crawler == nil {
            crawler = Crawler()
        }
        crawler.crawl()
        
        if db == nil {
            db = FirebaseDatabase()
        }
        db.draws { (draws) in
            debugPrint(draws)
        }
    }
    
}


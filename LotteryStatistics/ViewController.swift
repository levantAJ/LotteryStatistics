//
//  ViewController.swift
//  LotteryStatistics
//
//  Created by levantAJ on 11/3/18.
//  Copyright © 2018 levantAJ. All rights reserved.
//

import UIKit
import CoreML
import TheConstraints

class ViewController: UIViewController {
    lazy var crawler: Crawler = Crawler()
    lazy var db: FirebaseDatabase = FirebaseDatabase()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let crawlButton = UIButton(type: .system)
        crawlButton.setTitle("Start crawl", for: .normal)
        crawlButton.setTitleColor(.white, for: .normal)
        crawlButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        crawlButton.translatesAutoresizingMaskIntoConstraints = false
        crawlButton.addTarget(self, action: #selector(crawl), for: .touchUpInside)
        crawlButton.backgroundColor = .red
        view.addSubview(crawlButton)
        NSLayoutConstraint.activate([
            crawlButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            crawlButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            crawlButton.widthAnchor.constraint(equalToConstant: 200),
            crawlButton.heightAnchor.constraint(equalToConstant: 44),
        ])

        let predictButton = UIButton(type: .system)
        predictButton.setTitle("Predict", for: .normal)
        predictButton.setTitleColor(.white, for: .normal)
        predictButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        predictButton.translatesAutoresizingMaskIntoConstraints = false
        predictButton.addTarget(self, action: #selector(predict), for: .touchUpInside)
        predictButton.backgroundColor = .green
        view.addSubview(predictButton)
        predictButton.leading == crawlButton.leading
        predictButton.trailing == crawlButton.trailing
        predictButton.top == crawlButton.bottom + 16
        predictButton.height == crawlButton.height
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        db.draws { (draws) in
            debugPrint(draws)
        }
    }

    @objc private func crawl() {
        crawler.crawl {
            print("✅ Success")
        }
    }

    @objc func predict() {
//        let numbers = [2,3,1,14,7,6,28,13,11,8,10,4,9,5,16,24,12,17,22,15,18,19,23,27,25,26,20,21]
//        let providers = numbers.map { NumberFeatureProvider(number: $0) }
//        let model = MLModel()
//        let value = MLFeatureValue()
//        let provider = MLArrayBatchProvider(array: providers)
//        try model.prediction(from: provider as! MLFeatureProvider)

        //        let csvFile = Bundle.main.url(forResource: "lotterystatistics", withExtension: "csv")!
        //        let dataTable = try MLDataTable(contentsOf: csvFile)

        do {
            let numbers: [Double] = [03,04,20,21,36]
            let input = MarsHabitatPricerInput(n1: numbers[0], n2: numbers[1], n3: numbers[2], n4: numbers[3], n5: numbers[4])
            let model = try MarsHabitatPricer(configuration: MLModelConfiguration())
            let output = try model.prediction(input: input)
            print("predict n6", output.n6)

//            let input2 = MarsHabitatPurposeClassifierInput(n2: numbers[0], n3: numbers[1], n4: numbers[2], n5: 43, n6: 45)
//            let model2 = try MarsHabitatPurposeClassifier(configuration: MLModelConfiguration())
//            let output2 = try model2.prediction(input: input2)
//            print("predict n1", output2.n1)
        } catch {
            print("\(error)")
        }
    }
}

//class NumberFeatureProvider: MLFeatureProvider {
//    var featureNames: Set<String> {
//        get {
//            return  ["number"]
//        }
//    }
//
//    let number: Int
//
//    init(number: Int) {
//        self.number = number
//    }
//
//    func featureValue(for featureName: String) -> MLFeatureValue? {
//        guard featureName == "number" else {
//            return MLFeatureValue(int64: Int64(number))
//        }
//    }
//}

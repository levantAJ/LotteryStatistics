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
    lazy var tracker: Tracker = Tracker()
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        db.draws { [weak self] result in
            switch result {
            case .success(let draws):
                self?.tracker.track(draws: draws)
                print(draws)
            case .failure(let error):
                print("Fetch draws failed with error \(error)")
            }
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
            // Predict N2 from N1
            let input1 = N1ToN2Input(n1: 21)
            let model1 = try N1ToN2(configuration: MLModelConfiguration())
            let output1 = try model1.prediction(input: input1)
            print("predict n2 from n1", output1.n2)

            // Predict N3 from N1, N2
            let input2 = N1N2ToN3Input(n1: 21, n2: 39)
            let model2 = try N1N2ToN3(configuration: MLModelConfiguration())
            let output2 = try model2.prediction(input: input2)
            print("predict n3 from n1, n2", output2.n3)

            // Predict N4 from N1, N2, N3
            let input3 = N1N2N3ToN4Input(n1: 21, n2: 39, n3: 40)
            let model3 = try N1N2N3ToN4(configuration: MLModelConfiguration())
            let output3 = try model3.prediction(input: input3)
            print("predict n4 from n1, n2, n3", output3.n4)

            // Predict N5 from N1, N2, N3, N4
            let input4 = N1N2N3N4ToN5Input(n1: 21, n2: 39, n3: 40, n4: 41)
            let model4 = try N1N2N3N4ToN5(configuration: MLModelConfiguration())
            let output4 = try model4.prediction(input: input4)
            print("predict n5 from n1, n2, n3, n4", output4.n5)

            // Predict N6 from N1, N2, N3, N4, N5
            let n1ToN5Numbers: [Double] = [03,04,20,21,36]
            let input = MarsHabitatPricerInput(n1: n1ToN5Numbers[0], n2: n1ToN5Numbers[1], n3: n1ToN5Numbers[2], n4: n1ToN5Numbers[3], n5: n1ToN5Numbers[4])
            let model = try MarsHabitatPricer(configuration: MLModelConfiguration())
            let output = try model.prediction(input: input)
            print("predict n6 from n1, n2, n3, n4, n5", output.n6)

//            // Classifier
//            let input10 = MarsHabitatPurposeClassifierInput(n2: n1ToN5Numbers[0], n3: n1ToN5Numbers[1], n4: n1ToN5Numbers[2], n5: 43, n6: 45)
//            let model10 = try MarsHabitatPurposeClassifier(configuration: MLModelConfiguration())
//            let output10 = try model10.prediction(input: input10)
//            print("predict n1", output10.n1)


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

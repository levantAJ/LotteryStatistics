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
import DequeueKit

class ViewController: UIViewController {
    lazy var crawler: Crawler = Crawler()
    lazy var db: FirebaseDatabase = FirebaseDatabase()
    lazy var tracker: Tracker = Tracker()
    lazy var predictionTextFields: [UITextField] = []
    lazy var draws: [Draw] = []

    lazy var allStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .equalCentering
        return stackView
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(class: DrawTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(allStackView)
        allStackView.mid == view.mid
        allStackView.leading >= view.leading
        allStackView.trailing <= view.trailing
        allStackView.top >= view.top + 44
        allStackView.bottom <= view.bottom - 44

        addTableView()

        let crawlButton = UIButton(type: .system)
        crawlButton.setTitle("Start crawl", for: .normal)
        crawlButton.setTitleColor(.white, for: .normal)
        crawlButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        crawlButton.translatesAutoresizingMaskIntoConstraints = false
        crawlButton.addTarget(self, action: #selector(crawl), for: .touchUpInside)
        crawlButton.backgroundColor = .red
        crawlButton.height == 44
        allStackView.addArrangedSubview(crawlButton)

        addPredictionView()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        db.draws { [weak self] result in
            switch result {
            case .success(let draws):
                self?.tracker.track(draws: draws)
                self?.draws = draws.sorted(by: { (lhs, rhs) -> Bool in
                    return lhs.date.timeIntervalSince1970 > rhs.date.timeIntervalSince1970
                })
                self?.tableView.reloadData()
            case .failure(let error):
                print("Fetch draws failed with error \(error)")
            }
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return draws.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(type: DrawTableViewCell.self, for: indexPath)
        if let draw = draws[safe: indexPath.row] {
            cell.setDraw(draw)
        }
        return cell
    }
}

extension ViewController {
    private func addTableView() {
        allStackView.addArrangedSubview(tableView)
        tableView.height == 600
    }

    private func addPredictionView() {

        let viewLine = UIView()
        viewLine.backgroundColor = .red
        viewLine.height == 0.5
        allStackView.addArrangedSubview(viewLine)

        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.height == 44
        stackView.distribution = .fillEqually

        for i in 0...5 {
            let textField = UITextField()
            textField.width == 70
            textField.tag = i
            textField.textAlignment = .center
            textField.font = .systemFont(ofSize: 15, weight: .bold)
            textField.layer.borderWidth = 2
            textField.layer.borderColor = UIColor.gray.cgColor
            textField.delegate = self
            textField.addTarget(self, action: #selector(textDidChanged(_:)), for: .editingChanged)
            stackView.addArrangedSubview(textField)
            predictionTextFields.append(textField)
        }

        allStackView.addArrangedSubview(stackView)

        let predictButton = UIButton(type: .system)
        predictButton.setTitle("Predict", for: .normal)
        predictButton.setTitleColor(.white, for: .normal)
        predictButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        predictButton.translatesAutoresizingMaskIntoConstraints = false
        predictButton.addTarget(self, action: #selector(predict), for: .touchUpInside)
        predictButton.backgroundColor = .green
        allStackView.addArrangedSubview(predictButton)
        predictButton.height == 44
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

extension ViewController: UITextFieldDelegate {
    @objc func textDidChanged(_ textField: UITextField) {
        do {
            let index = textField.tag
            switch index {
            case 0:
                let n1 = predictionTextFields[0].text?.toDouble()
                let n2 = try predictN2(n1: n1)
                predictionTextFields[1].text = String(format: "%0.3f", n2)
                fallthrough
            case 1:
                let n1 = predictionTextFields[0].text?.toDouble()
                let n2 = predictionTextFields[1].text?.toDouble()
                let n3 = try predictN3(n1: n1, n2: n2)
                predictionTextFields[2].text = String(format: "%0.3f", n3)
                fallthrough
            case 2:
                let n1 = predictionTextFields[0].text?.toDouble()
                let n2 = predictionTextFields[1].text?.toDouble()
                let n3 = predictionTextFields[2].text?.toDouble()
                let n4 = try predictN4(n1: n1, n2: n2, n3: n3)
                predictionTextFields[3].text = String(format: "%0.3f", n4)
                fallthrough
            case 3:
                let n1 = predictionTextFields[0].text?.toDouble()
                let n2 = predictionTextFields[1].text?.toDouble()
                let n3 = predictionTextFields[2].text?.toDouble()
                let n4 = predictionTextFields[2].text?.toDouble()
                let n5 = try predictN5(n1: n1, n2: n2, n3: n3, n4: n4)
                predictionTextFields[4].text = String(format: "%0.3f", n5)
                fallthrough
            case 4:
                let n1 = predictionTextFields[0].text?.toDouble()
                let n2 = predictionTextFields[1].text?.toDouble()
                let n3 = predictionTextFields[2].text?.toDouble()
                let n4 = predictionTextFields[3].text?.toDouble()
                let n5 = predictionTextFields[4].text?.toDouble()
                let n6 = try predictN6(n1: n1, n2: n2, n3: n3, n4: n4, n5: n5)
                predictionTextFields[5].text = String(format: "%0.3f", n6)
            default:
                break
            }
        } catch {
            print("Cannot predict with error \(error)")
        }
    }
}

extension ViewController {
    private func predictN2(n1: Double?) throws -> Double {
        guard let n1 = n1 else { return 0 }
        let input1 = N1ToN2Input(n1: n1)
        let model1 = try N1ToN2(configuration: MLModelConfiguration())
        let output1 = try model1.prediction(input: input1)
        print("predict n2 from n1", output1.n2)
        return output1.n2
    }

    private func predictN3(n1: Double?, n2: Double?) throws -> Double {
        // Predict N3 from N1, N2
        guard let n1 = n1, let n2 = n2 else { return 0 }
        let input2 = N1N2ToN3Input(n1: n1, n2: n2)
        let model2 = try N1N2ToN3(configuration: MLModelConfiguration())
        let output2 = try model2.prediction(input: input2)
        print("predict n3 from n1, n2", output2.n3)
        return output2.n3
    }

    private func predictN4(n1: Double?, n2: Double?, n3: Double?) throws -> Double {
        // Predict N3 from N1, N2
        guard let n1 = n1, let n2 = n2, let n3 = n3 else { return 0 }
        // Predict N4 from N1, N2, N3
        let input3 = N1N2N3ToN4Input(n1: n1, n2: n2, n3: n3)
        let model3 = try N1N2N3ToN4(configuration: MLModelConfiguration())
        let output3 = try model3.prediction(input: input3)
        print("predict n4 from n1, n2, n3", output3.n4)
        return output3.n4
    }

    private func predictN5(n1: Double?, n2: Double?, n3: Double?, n4: Double?) throws -> Double {
        // Predict N3 from N1, N2
        guard let n1 = n1, let n2 = n2, let n3 = n3, let n4 = n4 else { return 0 }
        // Predict N4 from N1, N2, N3
        let input4 = N1N2N3N4ToN5Input(n1: n1, n2: n2, n3: n3, n4: n4)
        let model4 = try N1N2N3N4ToN5(configuration: MLModelConfiguration())
        let output4 = try model4.prediction(input: input4)
        print("predict n5 from n1, n2, n3, n4", output4.n5)
        return output4.n5
    }

    private func predictN6(n1: Double?, n2: Double?, n3: Double?, n4: Double?, n5: Double?) throws -> Double {
        guard let n1 = n1, let n2 = n2, let n3 = n3, let n4 = n4, let n5 = n5 else { return 0 }
        let input = MarsHabitatPricerInput(n1: n1, n2: n2, n3: n3, n4: n4, n5: n5)
        let model = try MarsHabitatPricer(configuration: MLModelConfiguration())
        let output = try model.prediction(input: input)
        print("predict n6 from n1, n2, n3, n4, n5", output.n6)
        return output.n6
    }
}

class DrawTableViewCell: UITableViewCell {
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        return label
    }()

    lazy var drawsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(dateLabel)
        dateLabel.top == contentView.top
        dateLabel.height == 22
        dateLabel.leading == contentView.leading + 16
        dateLabel.trailing == contentView.trailing - 16

        contentView.addSubview(drawsLabel)
        drawsLabel.leading == contentView.leading + 16
        drawsLabel.trailing == contentView.trailing - 16
        drawsLabel.top == dateLabel.bottom
        drawsLabel.bottom == contentView.bottom
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setDraw(_ draw: Draw) {
        dateLabel.text = DateFormatter.ddMMYYY.string(from: draw.date)
        drawsLabel.text = draw.numbers.map { "\($0)" }.joined(separator: " - ")
    }
}

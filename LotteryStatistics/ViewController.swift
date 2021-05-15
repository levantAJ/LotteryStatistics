//
//  ViewController.swift
//  LotteryStatistics
//
//  Created by levantAJ on 11/3/18.
//  Copyright © 2018 levantAJ. All rights reserved.
//

import UIKit
import TheConstraints
import DequeueKit

class ViewController: UIViewController {
    lazy var crawler: Crawler = Crawler()
    lazy var db: FirebaseDatabase = FirebaseDatabase()
    lazy var tracker: Tracker = Tracker()
    lazy var predictionTextFields: [UITextField] = []
    lazy var draws: [Draw] = []
    lazy var predictor: Predictor = Predictor()

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

    @objc func predict() {}
}


extension ViewController: UITextFieldDelegate {
    @objc func textDidChanged(_ textField: UITextField) {
        let index = textField.tag
        switch index {
        case 0:
            guard let n1 = predictionTextFields[0].text?.toDouble(),
                  let result: PredictorResult = predictor.predict(
                    number: .n2(n1: n1)
                  ) else { return }
            setPredictorResult(result)
        case 1:
            guard let n1 = predictionTextFields[0].text?.toDouble(),
                  let n2 = predictionTextFields[1].text?.toDouble(),
                  let result: PredictorResult = predictor.predict(number: .n3(n1: n1, n2: n2)) else { return }
            setPredictorResult(result)
        case 2:
            guard let n1 = predictionTextFields[0].text?.toDouble(),
                  let n2 = predictionTextFields[1].text?.toDouble(),
                  let n3 = predictionTextFields[2].text?.toDouble(),
                  let result: PredictorResult = predictor.predict(number: .n4(n1: n1, n2: n2, n3: n3)) else { return }
            setPredictorResult(result)
        case 3:
            guard let n1 = predictionTextFields[0].text?.toDouble(),
                  let n2 = predictionTextFields[1].text?.toDouble(),
                  let n3 = predictionTextFields[2].text?.toDouble(),
                  let n4 = predictionTextFields[3].text?.toDouble(),
                  let result: PredictorResult = predictor.predict(
                    number: .n5(n1: n1, n2: n2, n3: n3, n4: n4)
                  ) else { return }
            setPredictorResult(result)
        case 4:
            guard let n1 = predictionTextFields[0].text?.toDouble(),
                  let n2 = predictionTextFields[1].text?.toDouble(),
                  let n3 = predictionTextFields[2].text?.toDouble(),
                  let n4 = predictionTextFields[3].text?.toDouble(),
                  let n5 = predictionTextFields[3].text?.toDouble(),
                  let result: PredictorResult = predictor.predict(
                    number: .n6(n1: n1, n2: n2, n3: n3, n4: n4, n5: n5)
                  ) else { return }
            setPredictorResult(result)
        default:
            break
        }
    }

    private func setPredictorResult(_ result: PredictorResult) {
        setTextField(predictionTextFields[0], value: result.n1)
        setTextField(predictionTextFields[1], value: result.n2)
        setTextField(predictionTextFields[2], value: result.n3)
        setTextField(predictionTextFields[3], value: result.n4)
        setTextField(predictionTextFields[4], value: result.n5)
        setTextField(predictionTextFields[5], value: result.n6)
    }

    private func setTextField(_ textField: UITextField, value: Double) {
        textField.text = String(format: "%0.3f", value)
    }
}

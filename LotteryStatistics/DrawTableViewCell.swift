//
//  DrawTableViewCell.swift
//  LotteryStatistics
//
//  Created by Tai Le on 15/05/2021.
//  Copyright © 2021 levantAJ. All rights reserved.
//

import UIKit
import TheConstraints

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

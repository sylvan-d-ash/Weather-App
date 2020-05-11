//
//  ForecastCell.swift
//  Weather App
//
//  Created by Sylvan Ash on 11/05/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

import UIKit

class ForecastCell: UITableViewCell {
    private enum Constants {
        static let fontSize: CGFloat = 11
        static let dateWidth: CGFloat = 70
    }

    private let dateLabel = UILabel()
    private let highLabel = UILabel()
    private let lowLabel = UILabel()
    private let humidityLabel = UILabel()
    private let windInfoLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with forecast: Forecast) {
        dateLabel.text = forecast.displayDate
        windInfoLabel.text = "\(forecast.wind.speed)km/hr"
        humidityLabel.text = "\(Int(forecast.main.humidity))%"

        let max = Int(forecast.main.maxTemp.rounded())
        highLabel.text = "\(max)°"

        let min = Int(forecast.main.minTemp.rounded())
        lowLabel.text = "\(min)°"
    }
}

private extension ForecastCell {
    func setupSubviews() {
        dateLabel.font = UIFont.systemFont(ofSize: Constants.fontSize)
        highLabel.font = UIFont.systemFont(ofSize: Constants.fontSize)
        lowLabel.font = UIFont.systemFont(ofSize: Constants.fontSize)
        humidityLabel.font = UIFont.systemFont(ofSize: Constants.fontSize)
        windInfoLabel.font = UIFont.systemFont(ofSize: Constants.fontSize)

        let stackview = UIStackView(arrangedSubviews: [highLabel, lowLabel, humidityLabel, windInfoLabel])
        stackview.axis = .horizontal
        stackview.distribution = .fillEqually

        [dateLabel, stackview].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            dateLabel.widthAnchor.constraint(equalToConstant: Constants.dateWidth),

            stackview.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackview.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 8),
            stackview.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            stackview.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }
}

private extension Forecast {
    var displayDate: String {
        let weekdayIndex = Calendar.current.component(.weekday, from: date) - 1
        return DateFormatter().weekdaySymbols[weekdayIndex]
    }
}

//
//  DailyWeatherView.swift
//  Weather App
//
//  Created by Sylvan Ash on 23/06/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

import UIKit

class DailyWeatherView: UIView {
    private let tableView = UITableView(frame: .zero, style: .plain)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }

    func update(with forecasts: [Forecast]) {
        //
    }
}

private extension DailyWeatherView {
    func setupSubviews() {
        tableView.register(ForecastCell.self, forCellReuseIdentifier: "\(ForecastCell.self)")
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsets()
        tableView.dataSource = self
        tableView.allowsSelection = false
    }
}

extension DailyWeatherView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

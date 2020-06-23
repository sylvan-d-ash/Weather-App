//
//  HourlyWeatherView.swift
//  Weather App
//
//  Created by Sylvan Ash on 23/06/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

import UIKit

class HourlyWeatherView: UIView {
    private var collectionView: UICollectionView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
}

private extension HourlyWeatherView {
    func setupSubviews() {
        //
    }
}

extension HourlyWeatherView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}

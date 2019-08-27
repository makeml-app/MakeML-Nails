//
//  ColorCollectionViewCell.swift
//  Segmentation Nails
//
//  Created by Alexander Kartsev on 8/28/19.
//  Copyright © 2019 Alexey Korotkov. All rights reserved.
//

import Foundation

class ColorCollectionViewCell: UICollectionViewCell {
    static let identifier = "ColorCollectionViewCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        layer.cornerRadius = 35
        layer.masksToBounds = true
    }
}

//
//  CameraCollectionViewCell.swift
//  Segmentation Nails
//
//  Created by Alexander Kartsev on 8/27/19.
//  Copyright © 2019 Alexey Korotkov. All rights reserved.
//

import Foundation

class CameraCollectionViewCell: UICollectionViewCell {
    static let identifier = "CameraCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        let imageView = UIImageView(image: UIImage(named: "flip-camera"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                           constant: 5).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                            constant: -5).isActive = true
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                       constant: 5).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                          constant: -5).isActive = true
    }
}

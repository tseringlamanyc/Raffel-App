//
//  RaffleCell.swift
//  Raffel-App
//
//  Created by Tsering Lama on 5/30/21.
//

import UIKit

class RaffleCell: UICollectionViewCell {
    
    static let reuseIdentifier = "raffleCell"
    
    public lazy var raffleName: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 0 
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        imageViewConstraints()
    }
    
    private func imageViewConstraints() {
        addSubview(raffleName)
        raffleName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            raffleName.centerYAnchor.constraint(equalTo: centerYAnchor),
            raffleName.centerXAnchor.constraint(equalTo: centerXAnchor),
            raffleName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            raffleName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }
}

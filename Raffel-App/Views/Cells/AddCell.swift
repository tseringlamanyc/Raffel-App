//
//  AddCell.swift
//  Raffel-App
//
//  Created by Tsering Lama on 5/31/21.
//

import UIKit

class AddButtonCell: UICollectionViewCell {
    static let resueIdentifier = "addCell"
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.clipsToBounds = true
        self.backgroundColor = .systemRed
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        
    }
    
}


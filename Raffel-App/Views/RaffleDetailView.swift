//
//  RaffleDetailView.swift
//  Raffel-App
//
//  Created by Tsering Lama on 5/31/21.
//

import UIKit

class RaffleDetailView: UIView {

    public lazy var cv: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.backgroundColor = .systemRed
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    
    private func commonInit() {
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        addSubview(cv)
        
        cv.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cv.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            cv.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            cv.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            cv.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

}

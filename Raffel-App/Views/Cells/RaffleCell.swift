//
//  RaffleCell.swift
//  Raffel-App
//
//  Created by Tsering Lama on 5/30/21.
//

import UIKit

class RaffleCell: UICollectionViewCell {
    
    static let reuseIdentifier = "raffleCell"
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.clipsToBounds = true
        self.layer.cornerRadius = 8
    }
    
    public lazy var raffleName: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
        label.numberOfLines = 0 
        return label
    }()
    
    public lazy var winnerLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    public lazy var createdAt: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 35, weight: .light)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        return label
    }()
    
    public lazy var raffledOn: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    public lazy var verticalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        [self.raffleName,
         self.createdAt,
         self.winnerLabel,
         self.raffledOn
        ].forEach {
            stack.addArrangedSubview($0)
        }
        return stack
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
        configureStackView()
    }
    
    private func configureStackView() {
        addSubview(verticalStack)
        
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            verticalStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            verticalStack.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            verticalStack.rightAnchor.constraint(equalTo: rightAnchor, constant: -8),
            verticalStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    public func configureCell(raffle: Raffle) {
        
        layer.borderColor = UIColor.systemGreen.cgColor
        layer.borderWidth = 2
        
        raffleName.text = raffle.name ?? ""
        
        if let _ = raffle.winner_id {
            layer.borderColor = UIColor.red.cgColor
            layer.borderWidth = 2
            raffledOn.text = "Raffled At: \(raffle.raffled_at?.toDate() ?? "")"
            winnerLabel.text = "Winner Id: \(raffle.winner_id?.description ?? "")"
        } else {
            winnerLabel.text = "No winner yet for: \(raffle.id ?? 0)"
            raffledOn.text = "Not raffled"
        }
        
        createdAt.text = "Created @ \(raffle.created_at?.toDate() ?? "")"
    }
}

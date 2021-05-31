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
        
        layer.borderColor = UIColor.green.cgColor
        layer.borderWidth = 2
        
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = SFLabel.name.attachment
        let fullString = NSMutableAttributedString(string: "")
        fullString.append(NSAttributedString(attachment: imageAttachment))
        fullString.append(NSAttributedString(string: " \(raffle.name ?? "")"))
        raffleName.attributedText = fullString
        
        if let _ = raffle.winner_id {
           layer.borderColor = UIColor.red.cgColor
           layer.borderWidth = 2
            
            let imageAttachment2 = NSTextAttachment()
            imageAttachment2.image = SFLabel.raffleAt.attachment
            let fullString2 = NSMutableAttributedString(string: "")
            fullString2.append(NSAttributedString(attachment: imageAttachment2))
            fullString2.append(NSAttributedString(string: " Raffled At: \(raffle.raffled_at?.toDate() ?? "")"))
            raffledOn.attributedText = fullString2
            
            let imageAttachment3 = NSTextAttachment()
            imageAttachment3.image = SFLabel.winner.attachment
            let fullString3 = NSMutableAttributedString(string: "")
            fullString3.append(NSAttributedString(attachment: imageAttachment3))
            fullString3.append(NSAttributedString(string: " Winner Id: \(raffle.winner_id?.description ?? "")"))
            winnerLabel.attributedText = fullString3
        } else {
            winnerLabel.text = "No winner yet for: \(raffle.id ?? 0)"
            raffledOn.text = "Not raffled"
        }
        
        let imageAttachment4 = NSTextAttachment()
        imageAttachment4.image = SFLabel.created.attachment
        let fullString4 = NSMutableAttributedString(string: "")
        fullString4.append(NSAttributedString(attachment: imageAttachment4))
        fullString4.append(NSAttributedString(string: " Created @ \(raffle.created_at?.toDate() ?? "")"))
       createdAt.attributedText = fullString4
        
    }
}

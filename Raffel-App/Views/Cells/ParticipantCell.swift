//
//  ParticipantCell.swift
//  Raffel-App
//
//  Created by Tsering Lama on 5/31/21.
//

import UIKit

class ParticipantCell: UICollectionViewCell {
    static let resueIdentifier = "participantCell"
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.clipsToBounds = true
        self.layer.cornerRadius = 8
    }
    
    public lazy var participantName: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
        label.numberOfLines = 0
        return label
    }()
    
    public lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    public lazy var participantId: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 35, weight: .light)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        return label
    }()
    
    public lazy var phonelLabel: UILabel = {
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
        [self.participantName,
         self.participantId,
         self.emailLabel,
         self.phonelLabel
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
    
    public func configureCell(participant: Participant, raffle: Raffle) {
        
        self.layer.borderColor = UIColor.systemRed.cgColor
        self.layer.borderWidth = 2
        
        participantName.text = "\(participant.firstname.capitalized) \(participant.lastname.capitalized)"
        emailLabel.text = participant.email
        
        if raffle.winner_id == participant.id {
            self.layer.borderColor = UIColor.systemGreen.cgColor
        }
        
        if let phoneNumber = participant.phone {
            phonelLabel.text = phoneNumber
        } else {
            phonelLabel.text = "Phone number not provided"
        }
        
        participantId.text = participant.id?.description ?? ""
    }
}

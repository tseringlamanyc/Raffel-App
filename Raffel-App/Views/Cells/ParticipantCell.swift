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
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.numberOfLines = 0
        return label
    }()
    
    public lazy var buttonImage: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "star.fill"), for: .normal)
        button.tintColor = .systemYellow
        button.frame.size.width = 44
        button.frame.size.height = 44
       return button
    }()
    
    public lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 25, weight: .thin)
        label.numberOfLines = 0
        return label
    }()
    
    public lazy var participantId: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.numberOfLines = 0
        return label
    }()
    
    public lazy var phonelLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15, weight: .thin)
        label.numberOfLines = 0
        return label
    }()
    
    public lazy var horizontalStack: UIStackView = {
       let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .leading
        stack.distribution = .equalSpacing
        [self.participantName,
         self.buttonImage
        ].forEach {
            stack.addArrangedSubview($0)
        }
        return stack
    }()
    
    public lazy var verticalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        [self.horizontalStack,
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
            verticalStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 5),
            verticalStack.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            verticalStack.rightAnchor.constraint(equalTo: rightAnchor, constant: -8),
            verticalStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
    }
    
    public func configureCell(participant: Participant, raffle: Raffle) {
        
        self.layer.backgroundColor = UIColor.systemGray2.cgColor
        self.buttonImage.alpha = 0 
        
        participantName.text = "\(participant.firstname.capitalized) \(participant.lastname.capitalized)"
        emailLabel.text = participant.email
        
        if raffle.winner_id == participant.id {
            self.layer.backgroundColor = UIColor.systemGreen.cgColor
            self.buttonImage.alpha = 1
        }
        
        if let phoneNumber = participant.phone {
            phonelLabel.text = phoneNumber
        } else {
            phonelLabel.text = "No phone number"
        }
        
        participantId.text = "Participant Id: \(participant.id?.description ?? "")"
    }
}

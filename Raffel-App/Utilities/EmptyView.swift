//
//  Empty View.swift
//  Raffel-App
//
//  Created by Tsering Lama on 5/31/21.
//

import UIKit

class EmptyView: UIView {

    // title and a message
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
        label.textAlignment = .center
        label.text = "No Participants"
        return label
    }()
    
    public lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.numberOfLines = 4
        label.textAlignment = .center
        label.text = "There are no participants currently in this raffle"
        return label
    }()
    
    public lazy var addButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        return button
    }()
    
    public lazy var verticalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fillEqually
        [self.titleLabel,
         self.messageLabel,
         self.addButton
        ].forEach {
            stack.addArrangedSubview($0)
        }
        return stack
    }()
    
    init(title: String, message: String) {
        super.init(frame: UIScreen.main.bounds)
        titleLabel.text = title
        messageLabel.text = message
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
            verticalStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            verticalStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            verticalStack.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 8),
            verticalStack.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -8)
        ])
    }
    
}

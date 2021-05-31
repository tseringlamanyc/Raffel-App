//
//  RaffleCellViewModel.swift
//  Raffel-App
//
//  Created by Tsering Lama on 5/30/21.
//

import UIKit

class RaffleCellViewModel {
    
    private let raffle = Raffle()
    private let cell = RaffleCell()
    
  
    public func configureCell(cell: RaffleCell, raffle: Raffle) {
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "checkmark.circle")
        
        let fullString = NSMutableAttributedString(string: "")
        fullString.append(NSAttributedString(attachment: imageAttachment))
        fullString.append(NSAttributedString(string: " Has a winner"))
        
        cell.layer.cornerRadius = 8.0
        
        cell.layer.borderColor = UIColor.green.cgColor
        cell.layer.borderWidth = 2
        
        if let _ = raffle.winner_id {
            cell.layer.borderColor = UIColor.red.cgColor
            cell.layer.borderWidth = 2
            cell.winnerLabel.attributedText = fullString
            cell.raffledOn.text = "Raffled at: \(raffle.raffled_at?.toDate() ?? "")"
        } else {
            cell.winnerLabel.text = "No winner yet for: \(raffle.id ?? 0)"
            cell.raffledOn.text = "Not raffled"
        }
        
        cell.raffleName.text = "\(raffle.name ?? "") \(raffle.id ?? 0)"
        cell.createdAt.text = "Created: \(raffle.created_at?.toDate() ?? "")"
    }
}

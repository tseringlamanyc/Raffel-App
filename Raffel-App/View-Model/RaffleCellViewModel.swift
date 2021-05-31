//
//  RaffleCellViewModel.swift
//  Raffel-App
//
//  Created by Tsering Lama on 5/30/21.
//

import UIKit

enum SFLabel {
    case name
    case created
    case winner
    case raffleAt
    
    var attachment: UIImage {
        switch self {
        case .name:
            return UIImage(systemName: "pencil.and.ellipsis.rectangle")!
        case .created:
            return UIImage(systemName: "pencil.tip.crop.circle")!
        case .winner:
            return UIImage(systemName: "rosette")!
        case .raffleAt:
            return UIImage(systemName: "barcode")!
        }
    }
}

class RaffleCellViewModel {
    
    private let raffle: Raffle
    
    private let cell = RaffleCell()
    
    public func configureCell(cell: RaffleCell, raffle: Raffle) {
        cell.layer.cornerRadius = 8.0
        
        cell.layer.borderColor = UIColor.green.cgColor
        cell.layer.borderWidth = 2
 
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = SFLabel.name.attachment
        let fullString = NSMutableAttributedString(string: "")
        fullString.append(NSAttributedString(attachment: imageAttachment))
        fullString.append(NSAttributedString(string: " \(raffle.name ?? "")"))
        cell.raffleName.attributedText = fullString

        if let _ = raffle.winner_id {
            cell.layer.borderColor = UIColor.red.cgColor
            cell.layer.borderWidth = 2
            
            let imageAttachment2 = NSTextAttachment()
            imageAttachment2.image = SFLabel.raffleAt.attachment
            let fullString2 = NSMutableAttributedString(string: "")
            fullString2.append(NSAttributedString(attachment: imageAttachment2))
            fullString2.append(NSAttributedString(string: " Raffled At: \(raffle.raffled_at?.toDate() ?? "")"))
            cell.raffledOn.attributedText = fullString2
            
            let imageAttachment3 = NSTextAttachment()
            imageAttachment3.image = SFLabel.winner.attachment
            let fullString3 = NSMutableAttributedString(string: "")
            fullString3.append(NSAttributedString(attachment: imageAttachment3))
            fullString3.append(NSAttributedString(string: " Winner Id: \(raffle.winner_id?.description ?? "")"))
            cell.winnerLabel.attributedText = fullString3
        } else {
            cell.winnerLabel.text = "No winner yet for: \(raffle.id ?? 0)"
            cell.raffledOn.text = "Not raffled"
        }
        
        let imageAttachment4 = NSTextAttachment()
        imageAttachment4.image = SFLabel.created.attachment
        let fullString4 = NSMutableAttributedString(string: "")
        fullString4.append(NSAttributedString(attachment: imageAttachment4))
        fullString4.append(NSAttributedString(string: " Created @ \(raffle.created_at?.toDate() ?? "")"))
        cell.createdAt.attributedText = fullString4
    }
    
}

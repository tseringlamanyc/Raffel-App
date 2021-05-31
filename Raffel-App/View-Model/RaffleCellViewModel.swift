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
    // only show whats needed for the cell
    
}


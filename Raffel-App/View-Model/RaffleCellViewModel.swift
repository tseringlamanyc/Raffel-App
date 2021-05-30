//
//  RaffleCellViewModel.swift
//  Raffel-App
//
//  Created by Tsering Lama on 5/30/21.
//

import Foundation

class RaffleCellViewModel {
    
    private var raffleName = ""
    
    func updateUI(raffle: Raffle) {
        raffleName = raffle.name!
    }
}

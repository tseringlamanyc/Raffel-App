//
//  Raffel.swift
//  Raffel-App
//
//  Created by Tsering Lama on 5/29/21.
//

import Foundation

struct Raffle: Decodable & Encodable {
    var id: Int
    var name: String
    var created_at: String
    var raffled_at: String?
    var winner_id: Int?
}



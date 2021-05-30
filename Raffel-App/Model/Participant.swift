//
//  Participants.swift
//  Raffel-App
//
//  Created by Tsering Lama on 5/29/21.
//

import Foundation

struct Participant: Codable & Hashable {
    var id: Int?
    var raffle_id: Int
    var firstname: String
    var lastname: String
    var email: String
    var phone: Int?
    var registered_at: String?
}

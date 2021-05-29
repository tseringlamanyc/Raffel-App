//
//  Participants.swift
//  Raffel-App
//
//  Created by Tsering Lama on 5/29/21.
//

import Foundation

struct Participants: Decodable {
    var id: Int?
    var raffle_id: Int
    var firstName: String
    var lastName: String
    var email: String
    var phone: Int?
    var registered_at: Date?
}

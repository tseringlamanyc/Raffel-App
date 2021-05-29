//
//  Winner.swift
//  Raffel-App
//
//  Created by Tsering Lama on 5/29/21.
//

import Foundation

struct Winner: Encodable {
    var id: Int
    var raffle_id: Int
    var firstname: String
    var lastname: String
    var email: String
    var phone: Int?
}

//
//  BetterDate.swift
//  Raffel-App
//
//  Created by Tsering Lama on 5/30/21.
//

import Foundation

extension String {
    func toDate() -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime,
                                       .withFractionalSeconds
        ]
        let date = isoFormatter.date(from: self)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, d MMM yyyy h:mm a"
        let string = dateFormatter.string(from: date ?? Date())
        return string
    }
}

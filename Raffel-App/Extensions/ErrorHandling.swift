//
//  ErrorHandling.swift
//  Raffel-App
//
//  Created by Tsering Lama on 5/29/21.
//

import Foundation

enum ApiError: Error {
    case badURL(String)
    case networkError(Error)
    case decodingError(Error)
    case responseError(String)
    case dataError(String)
    case urlStatusError(Int)
}

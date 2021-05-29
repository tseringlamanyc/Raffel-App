//
//  Raffel-APIClient.swift
//  Raffel-App
//
//  Created by Tsering Lama on 5/29/21.
//

import Foundation

struct RaffleAPIClient {
    static func getAllRaffel(completion: @escaping (Result<[Raffle], ApiError>) -> ()) {
        let endpoint = "https://raffle-fs-app.herokuapp.com/api/raffles"
        
        NetworkCall.shared.dataTask(url: endpoint) { result in
            switch result {
            case .failure(let error):
                completion(.failure(.networkError(error)))
            case .success(let data):
                do {
                    let allRaffles = try JSONDecoder().decode([Raffle].self, from: data)
                    completion(.success(allRaffles))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
    }
}

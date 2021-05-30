//
//  Raffel-APIClient.swift
//  Raffel-App
//
//  Created by Tsering Lama on 5/29/21.
//

import Foundation

struct RaffleAPIClient {
    static func getAllRaffle(completion: @escaping (Result<[Raffle], ApiError>) -> ()) {
        let getEndpoint = "https://raffle-fs-app.herokuapp.com/api/raffles"
        
        guard let url = URL(string: getEndpoint) else {
            completion(.failure(.badURL(getEndpoint)))
            return 
        }
        
        let request = URLRequest(url: url)
        
        NetworkCall.shared.dataTask(request: request) { result in
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
    
    static func postARaffle(createdRaffle: Raffle, completion: @escaping (Result<Bool, ApiError>) -> ()) {
        let postEndpoint = "https://raffle-fs-app.herokuapp.com/api/raffles"
        
        guard let url = URL(string: postEndpoint) else {
            completion(.failure(.badURL(postEndpoint)))
            return
        }
        
        do {
            let data = try JSONEncoder().encode(createdRaffle)
            var request = URLRequest(url: url)
            request.httpBody = data
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            NetworkCall.shared.dataTask(request: request) { result in
                switch result {
                case .failure(let error):
                    completion(.failure(.networkError(error)))
                case.success(_):
                    completion(.success(true))
                }
            }
        } catch {
            completion(.failure(.decodingError(error)))
        }
    }
    
    static func postAParticipant(id: Int, participant: Participant, completion: @escaping (Result<Bool, ApiError>) -> ()) {
        let postEndpoint = "https://raffle-fs-app.herokuapp.com/api/raffles/\(id)/participants"
        
        guard let url = URL(string: postEndpoint) else {
            completion(.failure(.badURL(postEndpoint)))
            return
        }
        
        do {
            let data = try JSONEncoder().encode(participant)
            var request = URLRequest(url: url)
            request.httpBody = data
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            NetworkCall.shared.dataTask(request: request) { result in
                switch result {
                case .failure(let error):
                    completion(.failure(.networkError(error)))
                case .success(_):
                    completion(.success(true))
                }
            }
            
        } catch {
            completion(.failure(.decodingError(error)))
        }
    }
    
    static func requestAWinner(token: String, raffleId: Int, completion: @escaping (Result<Bool, ApiError>) -> ()) {
        let putEndpoint = "https://raffle-fs-app.herokuapp.com/api/raffles/\(raffleId)/winner"
        
        guard let url = URL(string: putEndpoint) else {
            completion(.failure(.badURL(putEndpoint)))
            return
        }
        
        do {
            let Token = Token(secret_token: token)
            let data = try JSONEncoder().encode(Token)
            var request = URLRequest(url: url)
            request.httpBody = data
            request.httpMethod = "PUT"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            NetworkCall.shared.dataTask(request: request) { result in
                switch result {
                case .failure(let error):
                    completion(.failure(.networkError(error)))
                case .success(_):
                    completion(.success(true))
                }
            }
        } catch {
            completion(.failure(.decodingError(error)))
        }
    }
    
    static func getAWinner() {
        
    }
}

//
//  APIClient.swift
//  Raffel-App
//
//  Created by Tsering Lama on 5/29/21.
//

import Foundation

class NetworkCall {
    
    static let shared = NetworkCall()
    
    private var session: URLSession
    
    private init() {
        session = URLSession(configuration: .default)
    }
    
    func dataTask(request: URLRequest,
                  completion: @escaping (Result<Data, ApiError>) -> ()) {
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                completion(.failure(.networkError(error)))
            }
            
            guard let urlResponse = response as? HTTPURLResponse else {
                completion(.failure(.responseError("No response from url")))
                return
            }
            
            guard let data = data else {
                completion(.failure(.dataError("No Data Present")))
                return
            }
            
            switch urlResponse.statusCode {
            case 200...299: break
            default:
                completion(.failure(.urlStatusError(urlResponse.statusCode)))
                return
            }
            
            completion(.success(data))
        }
        
        dataTask.resume()
        
    }
    
}

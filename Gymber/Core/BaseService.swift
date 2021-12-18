//
//  BaseService.swift
//  Gymber
//
//  Created by Andrés Guzmán on 18/12/21.
//

import Foundation

class BaseService: GymberService {
    var path: String?
    private let urlSession = URLSession.shared
    private let jsonDecoder = JSONDecoder()
    
    init() {}
    
    func fetch<T: Decodable>(completion: @escaping (Result<T, APIServiceError>) -> Void) {
        guard let urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        guard let url = urlComponents.url else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        // TODO: Use endpoint object instead.
        let endpoint = url.appendingPathComponent(path ?? .empty)
        var request = URLRequest(url: endpoint)
        
        request.allHTTPHeaderFields = ["User-Agent": "OneFit/1.19.0"]
        
        urlSession.dataTask(with: request) { (result) in
            switch result {
            case .success(let (response, data)):
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                    completion(.failure(.invalidResponse))
                    return
                }
                
                do {
                    let values = try self.jsonDecoder.decode(T.self, from: data)
                    completion(.success(values))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(.decodeError))
                }
            case .failure( _):
                completion(.failure(.apiError))
            }
        }.resume()
    }
}

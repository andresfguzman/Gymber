//
//  Service.swift
//  Gymber
//
//  Created by Andrés Guzmán on 18/12/21.
//

import Foundation

enum APIServiceError: Error {
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case decodeError
}

typealias GymberCompletion<Value> = (Result<Value, APIServiceError>) -> Void

protocol GymberService {
    var baseURL: URL { get }
    var path: String? { get set }
    func fetch<T: Decodable>(completion: @escaping GymberCompletion<T>)
}

extension GymberService {
    var baseURL: URL {
        // TODO: Inyect via CI/CD
        return URL(string: "https://api.one.fit")!
    }
}

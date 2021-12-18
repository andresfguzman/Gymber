//
//  URLSession+Utils.swift
//  Gymber
//
//  Created by Andrés Guzmán on 18/12/21.
//

import Foundation

extension URLSession {
    @discardableResult
    func dataTask(with request: URLRequest, result: @escaping (Result<(URLResponse, Data), Error>) -> Void) -> URLSessionDataTask {
        return dataTask(with: request) { (data, response, error) in
            if let error = error {
                DispatchQueue.performUIUpdates {
                    result(.failure(error))
                }
                return
            }
            guard let response = response, let data = data else {
                let error = NSError(domain: "error", code: 0, userInfo: nil)
                DispatchQueue.performUIUpdates {
                    result(.failure(error))
                }
                return
            }
            DispatchQueue.performUIUpdates {
                result(.success((response, data)))
            }
        }
    }
}

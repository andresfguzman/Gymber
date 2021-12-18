//
//  GetGymsService.swift
//  Gymber
//
//  Created by Andrés Guzmán on 18/12/21.
//

import Foundation

final class GetGymsService: BaseService {
    
    func fetchGyms(at city: CityID, onFinished: @escaping GymberCompletion<GymDTO>) {
        // TODO: Adjust endpoint management.
        path = "/v2/en-nl/partners/city/\(city.rawValue)"
        fetch(completion: onFinished)
    }
}

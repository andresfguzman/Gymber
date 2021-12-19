//
//  GetGymsService.swift
//  Gymber
//
//  Created by Andrés Guzmán on 18/12/21.
//

import Foundation

protocol GetGymsService {
    func fetchGyms(at city: CityID, onFinished: @escaping GymberCompletion<GymDTO>)
}

final class GetGymsServiceImpl: BaseService, GetGymsService {
    
    func fetchGyms(at city: CityID, onFinished: @escaping GymberCompletion<GymDTO>) {
        // TODO: Adjust endpoint management.
        path = "/v2/en-nl/partners/city/\(city.rawValue)"
        fetch(completion: onFinished)
    }
}

//
//  GymDTO.swift
//  Gymber
//
//  Created by Andrés Guzmán on 18/12/21.
//

import Foundation

struct GymDTO: Codable {
    let data: [GymData]
    
    struct GymData: Codable {
        
        let id: Int
        let name: String
        let headerImage: HeaderImage
        let locations: [Locations]
        
        enum CodingKeys: String, CodingKey {
            case id
            case name
            case headerImage = "header_image"
            case locations
        }
        
        struct HeaderImage: Codable {
            let mobile: URL
        }
        
        struct Locations: Codable {
            let city: String
            let latitude: Double
            let longitude: Double
        }
    }
}

//
//  CardViewModel.swift
//  Gymber
//
//  Created by Andrés Guzmán on 17/12/21.
//

import Foundation

struct GymLocation {
    let latitude: Double
    let longitude: Double
}

struct GymCardViewModel {
    let cardId: Int
    let title: String
    let image: String
    let location: GymLocation
    var isMatch: Bool
}

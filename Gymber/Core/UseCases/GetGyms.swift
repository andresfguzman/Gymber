//
//  GetGyms.swift
//  Gymber
//
//  Created by Andrés Guzmán on 18/12/21.
//

import Foundation

enum CityID: String {
    case utrecht = "UTR"
    case amsterdam = "AMS"
}

protocol GetGyms {
    func execute(for cityID: CityID, onFinished: @escaping GymberCompletion<[GymCardViewModel]>)
}

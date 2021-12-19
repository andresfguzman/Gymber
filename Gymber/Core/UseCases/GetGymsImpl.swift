//
//  GetGymsImpl.swift
//  Gymber
//
//  Created by Andrés Guzmán on 18/12/21.
//

import Foundation

final class GetGymsImpl: GetGymsUseCase {
    var service: GetGymsService?
    
    private var matchesCount: Int = .zero
    
    init(service: GetGymsService = GetGymsServiceImpl()) {
        self.service = service
    }
    
    func execute(for cityID: CityID, onFinished: @escaping GymberCompletion<[GymCardViewModel]>) {
        service?.fetchGyms(at: cityID, onFinished: { result in
            switch result {
            case .success(let responseDTO):
                let viewModel = responseDTO.data.map({ GymCardViewModel(cardId: $0.id,
                                                                        title: $0.name,
                                                                        image: $0.headerImage.mobile.absoluteString,
                                                                        location: GymLocation(latitude: $0.locations.first?.latitude ?? .zero,
                                                                                              longitude: $0.locations.first?.longitude ?? .zero),
                                                                        isMatch: self.randomMatcher(for: responseDTO.data.count))})
                onFinished(.success(viewModel))
            case .failure(let error):
                onFinished(.failure(error))
            }
        })
    }
    
    private func randomMatcher(for gymsCount: Int) -> Bool {
        // Not always 5% exactly but fairly close every time.
        let matchCount = 5 * gymsCount / 100
        let randomFactor = Int.random(in: .zero...gymsCount)
        return randomFactor <= matchCount
    }
}

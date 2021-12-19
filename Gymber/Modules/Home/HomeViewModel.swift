//
//  HomeViewModel.swift
//  Gymber
//
//  Created by Andrés Guzmán on 18/12/21.
//

import Foundation

protocol HomeViewModelProtocol: AnyObject {
    var view: HomeViewProtocol? { get set }
    var useCase: GetGymsUseCase? { get set }
    
    func fetchModelData()
    func model(at index: Int) -> GymCardViewModel
    func cardsCount() -> Int
}

final class HomeViewModel: HomeViewModelProtocol {
    weak var view: HomeViewProtocol?
    var useCase: GetGymsUseCase?
    
    private var gymCardList: [GymCardViewModel] = [] {
        didSet {
            view?.reloadData()
        }
    }
    
    private var isLoading = true {
        didSet {
            view?.setLoading(isLoading)
        }
    }
    
    func fetchModelData() {
        useCase?.execute(for: .utrecht) { [weak self] result in
            self?.isLoading = false
            switch result {
            case .success(let gymsVM):
                self?.gymCardList = gymsVM
            case.failure(let error):
                self?.view?.showErrorAlert(with: error.localizedDescription)
            }
        }
    }
    
    func model(at index: Int) -> GymCardViewModel {
        return gymCardList[index]
    }
    
    func cardsCount() -> Int {
        return gymCardList.count
    }
}

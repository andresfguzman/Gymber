//
//  HomeViewModelTests.swift
//  GymberTests
//
//  Created by Andrés Guzmán on 16/12/21.
//

import XCTest
@testable import Gymber

class HomeViewModelTests: XCTestCase {

    var sut: HomeViewModel!
    private var mockedHomeView: MockHomeView!
    private var mockedUseCase: MockUseCase!
    
    override func setUpWithError() throws {
        mockedHomeView = MockHomeView()
        mockedUseCase = MockUseCase()
        sut = HomeViewModel()
        sut.view = mockedHomeView
        sut.useCase = mockedUseCase
    }

    override func tearDownWithError() throws {
        sut = nil
        mockedHomeView = nil
        mockedUseCase = nil
    }
    
    func test_fetchModelData_Succeeds_UpdatesDataAndUI() {
        // Given
        mockedUseCase.mockFailure = false
        
        // When
        sut.fetchModelData()
        
        // Then
        XCTAssertEqual(sut.cardsCount(), DummyData.gymCardList.count)
        XCTAssertEqual(mockedHomeView.actions, [.setLoading, .reloadData])
    }
    
    func test_fetchModelData_Fails_UpdatesUI() {
        // Given
        mockedUseCase.mockFailure = true
        
        // When
        sut.fetchModelData()
        
        // Then
        XCTAssertEqual(sut.cardsCount(), .zero)
        XCTAssertEqual(mockedHomeView.actions, [.setLoading, .showErrorAlert])
    }
    
    func test_modelAt_returnsValidObject() {
        // Given
        mockedUseCase.mockFailure = false
        sut.fetchModelData()
        let dummyData = DummyData.gymCardList
        
        // When // Then
        dummyData.enumerated().forEach({ XCTAssertEqual(dummyData[$0.offset].cardId, sut.model(at: $0.offset).cardId) })
    }
}

private extension HomeViewModelTests {
    
    enum DummyData {
        static var gymCardList: [GymCardViewModel] {
            return [GymCardViewModel(cardId: .zero, title: "CardTitle1", image: "www.validurl.com",
                                     location: GymLocation(latitude: .zero, longitude: .zero), isMatch: false),
                    GymCardViewModel(cardId: 1, title: "CardTitle2", image: "www.validurl.com",
                                     location: GymLocation(latitude: .zero, longitude: .zero), isMatch: false),
                    GymCardViewModel(cardId: 2, title: "CardTitle3", image: "www.validurl.com",
                                     location: GymLocation(latitude: .zero, longitude: .zero), isMatch: true),
                    GymCardViewModel(cardId: 3, title: "CardTitle4", image: "www.validurl.com",
                                     location: GymLocation(latitude: .zero, longitude: .zero), isMatch: false),
                    GymCardViewModel(cardId: 4, title: "CardTitle5", image: "www.validurl.com",
                                     location: GymLocation(latitude: .zero, longitude: .zero), isMatch: false)]
            
        }
    }
    
    final class MockUseCase: GetGymsUseCase {
        var service: GetGymsService?
        var mockFailure: Bool = false
        
        func execute(for cityID: CityID, onFinished: @escaping GymberCompletion<[GymCardViewModel]>) {
            onFinished(mockFailure ? .failure(.apiError) : .success(DummyData.gymCardList))
        }
    }
    
    final class MockHomeView: HomeViewProtocol {
        
        enum Action: Comparable {
            case setLoading
            case reloadData
            case showErrorAlert
        }
        
        var actions: [Action] = []
        
        func setLoading(_ isLoading: Bool) {
            actions.append(.setLoading)
        }
        
        func reloadData() {
            actions.append(.reloadData)
        }
        
        func showErrorAlert(with message: String) {
            actions.append(.showErrorAlert)
        }
    }
}

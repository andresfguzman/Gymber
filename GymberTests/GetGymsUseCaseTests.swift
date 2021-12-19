//
//  GetGymsUseCaseTests.swift
//  GymberTests
//
//  Created by Andrés Guzmán on 19/12/21.
//

import XCTest
@testable import Gymber

final class GetGymsUseCaseTests: XCTestCase {
    var sut: GetGymsImpl!
    private var mockedService: MockService!
    
    override func setUpWithError() throws {
        mockedService = MockService()
        sut = GetGymsImpl(service: mockedService)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        mockedService = nil
    }
    
    func test_executeUseCase_Succeeds_ViewModelBuilt() {
        // Given
        mockedService.mockFailure = false
        let successExpectation = expectation(description: "UseCase execution succeeds")
        
        // When // Then
        sut.execute(for: .utrecht) { result in
            switch result {
            case .success(let vm):
                XCTAssertEqual(vm.count, DummyData.gymDTO.data.count)
                successExpectation.fulfill()
            default:
                XCTFail()
            }
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func test_executeUseCase_Fails_CompletesWithError() {
        // Given
        mockedService.mockFailure = true
        let successExpectation = expectation(description: "UseCase execution fails")
        
        // When // Then
        sut.execute(for: .utrecht) { result in
            switch result {
            case .failure:
                successExpectation.fulfill()
            default:
                XCTFail()
            }
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}

private extension GetGymsUseCaseTests {
    final class MockService: GetGymsService {
        
        enum Action: Comparable {
            case fetchGyms
        }
        
        var actions: [Action] = []
        
        var mockFailure: Bool = false
        
        func fetchGyms(at city: CityID, onFinished: @escaping GymberCompletion<GymDTO>) {
            actions.append(.fetchGyms)
            onFinished(mockFailure ? .failure(.apiError) : .success(DummyData.gymDTO))
        }
    }
    
    enum DummyData {
        static var gymDTO: GymDTO {
            return GymDTO(data: [GymDTO.GymData(id: .zero, name: "Name1", headerImage: GymDTO.GymData.HeaderImage(mobile: URL(string: "www.fakeURL.com")!),
                                                locations: [GymDTO.GymData.Locations(city: "XCity", latitude: .zero, longitude: .zero)]),
                                 GymDTO.GymData(id: 1, name: "Name2", headerImage: GymDTO.GymData.HeaderImage(mobile: URL(string: "www.fakeURL.com")!),
                                                locations: [GymDTO.GymData.Locations(city: "XCity", latitude: .zero, longitude: .zero)]),
                                 GymDTO.GymData(id: 2, name: "Name3", headerImage: GymDTO.GymData.HeaderImage(mobile: URL(string: "www.fakeURL.com")!),
                                                locations: [GymDTO.GymData.Locations(city: "XCity", latitude: .zero, longitude: .zero)])])
        }
    }
}

//
//  CakeListViewModelTests.swift
//  CakeList
//
//  Created by Stefan Grandjean-Thomsen on 22/09/2026.
//


@testable import CakeList
import Testing
import Foundation

@MainActor
struct CakeListViewModelTests {
    
    var mockService: MockCakeService!
    var viewModel: CakeListViewModel!
    
    init() {
        mockService = MockCakeService()
        viewModel = CakeListViewModel(service: mockService)
    }
    
    // MARK: - Load Success
    @Test
    func testLoadCakesSuccess() async {
        // Arrange
        let cakes = [
            Cake(title: "Zebra Cake", desc: "Desc", image: "url1"),
            Cake(title: "Apple Cake", desc: "Desc", image: "url2"),
            Cake(title: "Banana Cake", desc: "Desc", image: "url3")
        ]
        mockService.mockCakes = cakes
        
        // Act
        await viewModel.loadCakes()
        
        // Assert
        switch viewModel.viewState {
        case .loaded(let loadedCakes):
            #expect(loadedCakes.count == 3)
            #expect(loadedCakes[0].title == "Apple Cake")      // Sorted
            #expect(loadedCakes[1].title == "Banana Cake")
            #expect(loadedCakes[2].title == "Zebra Cake")
        default:
            #expect(Bool(false), "Expected loaded state")
        }
    }
    
    // MARK: - Load Failure
    @Test
    func testLoadCakesFailure() async {
        // Arrange
        mockService.mockError = NetworkError.genericError
        
        // Act
        await viewModel.loadCakes()
        
        // Assert
        switch viewModel.viewState {
        case .error(let message):
            #expect(!message.isEmpty)
        default:
            #expect(Bool(false), "Expected error state")
        }
    }
    
    // MARK: - Retry
    @Test
    func testRetry() async {
        // Arrange
        let cakes = [Cake(title: "Cake A", desc: "Desc", image: "url1")]
        mockService.mockCakes = cakes
        
        // Act
        await viewModel.retry()
        
        // Assert
        switch viewModel.viewState {
        case .loaded(let loadedCakes):
            #expect(loadedCakes.count == 1)
        default:
            #expect(Bool(false), "Expected loaded state")
        }
    }
    
    // MARK: - Initial State
    @Test
    func testInitialStateIsLoading() {
        switch viewModel.viewState {
        case .loading:
            #expect(Bool(true))
        default:
            #expect(Bool(false), "Expected loading state")
        }
    }
}

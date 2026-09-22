//
//  MockCakeService.swift
//  CakeList
//
//  Created by Stefan Grandjean-Thomsen on 22/09/2026.
//

@testable import CakeList
import Testing
import Foundation

// MARK: - Mock Service
class MockCakeService: CakeServiceProtocol {
    var mockCakes: [Cake] = []
    var mockError: Error?
    
    func fetchCakes() async throws -> [Cake] {
        if let error = mockError {
            throw error
        }
        return mockCakes
    }
}


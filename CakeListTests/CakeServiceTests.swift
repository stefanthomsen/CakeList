//
//  CakeServiceTests.swift
//  CakeServiceTests
//
//  Created by Stefan Grandjean-Thomsen on 22/09/2026.
//

@testable import CakeList
import Testing
import Foundation

@MainActor
struct CakeServiceTests {
    
    var urlSessionSpy: URLSessionSpy!
    var service: CakeService!
    
    init() {
        urlSessionSpy = URLSessionSpy()
        service = CakeService(session: urlSessionSpy)
    }
    
    @Test
    func testFetchCakesSuccess() async throws {
        let jsonData =
                """
                [
                    {"id": "1", "title": "Cake A", "description": "Desc A", "image": null},
                    {"id": "2", "title": "Cake B", "description": "Desc B", "image": null}
                ]
                """.data(using: .utf8)!
        
        urlSessionSpy.mockData = jsonData
        urlSessionSpy.mockResponse = HTTPURLResponse(
            url: URL(string: "url")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        let cakes = try await service.fetchCakes()
        
        #expect(urlSessionSpy.dataWasCalled == true)
        #expect(urlSessionSpy.callCount == 1)
        #expect(cakes.count == 2)
    }
}

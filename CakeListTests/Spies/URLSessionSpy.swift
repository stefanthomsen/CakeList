//
//  MockURLSession.swift
//  CakeList
//
//  Created by Stefan Grandjean-Thomsen on 22/09/2026.
//

@testable import CakeList
import Foundation

final class URLSessionSpy: URLSessionProtocol {
    
    var dataWasCalled = false
    var callCount = 0
    var lastURL: URL?
    var lastRequest: URLRequest?
    
    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        dataWasCalled = true
        callCount += 1
        lastRequest = request
        
        if let error = mockError {
            throw error
        }
        
        let data = mockData ?? Data()
        let response = mockResponse ?? HTTPURLResponse(
            url: request.url!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        
        return (data, response)
    }
}

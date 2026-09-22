//
//  CakeService.swift
//  CakeList
//
//  Created by Stefan Grandjean-Thomsen on 22/09/2026.
//

import Foundation

extension URLSession: URLSessionProtocol {}

protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

protocol CakeServiceProtocol {
    func fetchCakes() async throws -> [Cake]
}

class CakeService: CakeServiceProtocol {
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func fetchCakes() async throws -> [Cake] {
        
        guard let url = URL(string: Constants.API.baseURL + Constants.API.cakesEndpoint) else {
            #if DEBUG
            fatalError("Failed to compose URL")
            #else
            // TODO: send error to crashlytics
            return []
            #endif
        }
        
        let (data, response) = try await session.data(for: URLRequest(url: url))
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.genericError
        }
        
        let decoder = JSONDecoder()
        let cakes = try decoder.decode([Cake].self, from: data)
        
        let uniqueCakes = Array(Set(cakes))
        
        return uniqueCakes

    }
}

enum NetworkError: LocalizedError {
    case genericError
    
    var errorDescription: String? {
        "Ups, Something went wrong!"
    }
}

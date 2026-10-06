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
    private let tokenService: TokenServiceProtocol
    
    init(session: URLSessionProtocol = URLSession.shared,
         tokenService: TokenServiceProtocol = TokenService()) {
        
        self.session = session
        self.tokenService = tokenService
    }
    
    func fetchCakes() async throws -> [Cake] {
    
        try await Task.sleep(for: .milliseconds(3000))
        
        let token = try await tokenService.getToken()
        
        guard let url = URL(string: Constants.API.baseURL + Constants.API.cakesEndpoint) else {
            #if DEBUG
            fatalError("Failed to compose URL")
            #else
            // TODO: send error to crashlytics
            return []
            #endif
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await session.data(for: urlRequest)
        
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

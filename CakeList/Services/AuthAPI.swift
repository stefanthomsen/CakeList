//
//  AuthAPI.swift
//  CakeList
//
//  Created by Stefan Grandjean-Thomsen on 06/10/2026.
//

import Foundation

protocol AuthAPIProtocol{
    func fetchToken() async throws -> AuthToken
}

final class FakeAuthAPI: AuthAPIProtocol {
    func fetchToken() async throws -> AuthToken {
        try await Task.sleep(for: .milliseconds(300))
        return AuthToken(token: "interview-token-123", expiresAt: Date().addingTimeInterval(5 * 60))
    }
}

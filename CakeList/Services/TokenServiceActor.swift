//
//  TokenServiceActor.swift
//  CakeList
//
//  Created by Stefan Grandjean-Thomsen on 06/10/2026.
//

actor TokenServiceActor: TokenServiceProtocol {
    
    private var authToken: AuthToken?
    private var refreshTask: Task<AuthToken, Error>?
    private let api: AuthAPIProtocol

    init(api: AuthAPIProtocol = FakeAuthAPI()) {
        self.api = api
    }

    func getToken() async throws -> String {
        if let authToken, authToken.isValid { return authToken.token }
        if let refreshTask { return try await refreshTask.value.token }

        let task = Task { try await api.fetchToken() }
        refreshTask = task
        defer { refreshTask = nil }

        let newToken = try await task.value
        authToken = newToken
        return newToken.token
    }

    func invalidate() async {
        authToken = nil
    }
}

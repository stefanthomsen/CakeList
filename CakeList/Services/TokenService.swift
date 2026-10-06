//
//  TokenService.swift
//  CakeList
//
//  Created by Stefan Grandjean-Thomsen on 06/10/2026.
//

import Foundation

protocol TokenServiceProtocol {
    func getToken() async throws -> String
    func invalidate() async
}

enum TokenServiceError: Error {
    case genericError
}

nonisolated public final class TokenService: TokenServiceProtocol, @unchecked Sendable {
    
    private var token: AuthToken?
    private let lock = NSLock()
    private let api: AuthAPIProtocol
    private var refreshTask: Task<AuthToken, Error>?
    
    init(api: AuthAPIProtocol = FakeAuthAPI()) {
        self.api = api
    }
    
    func getToken() async throws -> String {
        
        let task: Task<AuthToken, Error> = lock.withLock {
            
            if let token, token.isValid {
                return Task { token }
            }
            
            if let refreshTask {
                return refreshTask
            }
            
            let task = Task {
                [api] in try await api.fetchToken()
            }
            
            refreshTask = task
            
            return task
        }
        
        do {
            let newToken = try await task.value
            lock.withLock {
                token = newToken
                if refreshTask == task {
                    refreshTask = nil
                }
            }
            
            return newToken.token
        } catch {
            lock.withLock {
                if refreshTask == task {
                    refreshTask = nil
                }
            }
            throw error
        }
    }
    
    func invalidate() async {
        lock.withLock {
            token = nil
        }
    }
}


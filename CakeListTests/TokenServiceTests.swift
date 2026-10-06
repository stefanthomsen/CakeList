//
//  TokenServiceTests.swift
//  CakeListTests
//

@testable import CakeList
import Foundation
import os
import Testing

struct TokenServiceTests {

    @Test
    func concurrentCallersShareASingleRefresh() async throws {
        let api = AuthAPISpy()
        let sut = TokenService(api: api)

        let tokens = try await withThrowingTaskGroup(of: String.self) { group in
            for _ in 0..<20 {
                group.addTask { try await sut.getToken() }
            }
            return try await group.reduce(into: [String]()) { $0.append($1) }
        }

        #expect(tokens.count == 20)
        #expect(Set(tokens) == ["token-1"])
        #expect(api.callCount == 1)
    }

    @Test
    func validTokenIsReusedWithoutRefreshing() async throws {
        let api = AuthAPISpy()
        let sut = TokenService(api: api)

        _ = try await sut.getToken()
        _ = try await sut.getToken()

        #expect(api.callCount == 1)
    }

    @Test
    func invalidateForcesANewRefresh() async throws {
        let api = AuthAPISpy()
        let sut = TokenService(api: api)

        let first = try await sut.getToken()
        await sut.invalidate()
        let second = try await sut.getToken()

        #expect(first == "token-1")
        #expect(second == "token-2")
        #expect(api.callCount == 2)
    }

    @Test
    func failedRefreshCanBeRetried() async throws {
        let api = AuthAPISpy(failFirstCall: true)
        let sut = TokenService(api: api)

        await #expect(throws: AuthAPISpy.SpyError.self) {
            try await sut.getToken()
        }
        let token = try await sut.getToken()

        #expect(token == "token-2")
        #expect(api.callCount == 2)
    }
}

/// Counts calls and simulates latency so concurrent callers overlap.
nonisolated final class AuthAPISpy: AuthAPIProtocol, @unchecked Sendable {
    enum SpyError: Error { case failed }

    private let calls = OSAllocatedUnfairLock(initialState: 0)
    private let failFirstCall: Bool

    init(failFirstCall: Bool = false) {
        self.failFirstCall = failFirstCall
    }

    var callCount: Int { calls.withLock { $0 } }

    func fetchToken() async throws -> AuthToken {
        let call = calls.withLock { count -> Int in
            count += 1
            return count
        }
        try await Task.sleep(for: .milliseconds(100))
        if failFirstCall && call == 1 { throw SpyError.failed }
        return AuthToken(token: "token-\(call)", expiresAt: Date.distantFuture)
    }
}

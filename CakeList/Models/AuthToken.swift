//
//  AuthToken.swift
//  CakeList
//
//  Created by Stefan Grandjean-Thomsen on 06/10/2026.
//

import Foundation

struct AuthToken {
    let token: String
    let expiresAt: Date
    var isValid: Bool { expiresAt > .now }
}

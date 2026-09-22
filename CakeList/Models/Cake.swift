//
//  Cake.swift
//  CakeList
//
//  Created by Stefan Grandjean-Thomsen on 22/09/2026.
//

import Foundation

struct Cake: Decodable, Identifiable, Hashable {
    var id: String { title }
    let title: String
    let desc: String
    let image: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(image)
    }
}

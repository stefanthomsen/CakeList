//
//  CakeDetailView.swift
//  CakeList
//
//  Created by Stefan Grandjean-Thomsen on 22/09/2026.
//

import SwiftUI

struct CakeDetailView: View {
    let cake: Cake
    
    var body: some View {
        Text(cake.desc)
    }
}

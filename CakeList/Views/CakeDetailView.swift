//
//  CakeDetailView.swift
//  CakeList
//
//  Created by Stefan Grandjean-Thomsen on 22/09/2026.
//

import SwiftUI

struct CakeDetailView: View {
    let cake: Cake
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 16) {
            // MARK: - Header
            HStack {
                Text("Details")
                    .font(.headline)
                Spacer()
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.gray)
                }
            }
            .padding()

            // MARK: - Image
            AsyncImage(url: URL(string: cake.image)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                default:
                    Color(.systemGray6)
                }
            }
            .frame(height: 200)
            .cornerRadius(12)
            .clipped()
            .padding(.horizontal)

            // MARK: - Title
            Text(cake.title)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)

            // MARK: - Description
            Text(cake.desc)
                .font(.body)
                .foregroundStyle(.secondary)
                .lineLimit(nil)
                .padding(.horizontal)

            Spacer()
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}

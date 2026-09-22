//
//  CakeRowView.swift
//  CakeList
//
//  Created by Stefan Grandjean-Thomsen on 22/09/2026.
//

import SwiftUI

struct CakeRowView: View {

    let cake: Cake

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 12) {
                AsyncImage(url: URL(string: cake.image)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 80, height: 80)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)

                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .cornerRadius(8)
                            .clipped()

                    case .failure:
                        Image(systemName: "photo")
                            .font(.system(size: 24))
                            .frame(width: 80, height: 80)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)

                    @unknown default:
                        Color(.systemGray6)
                            .frame(width: 80, height: 80)
                            .cornerRadius(8)
                    }
                }
                .frame(width: 80, height: 80)

                // MARK: - Title
                Text(cake.title)
                    .font(.headline)
                    .lineLimit(2)

                Spacer()
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 0)

        }
    }
}

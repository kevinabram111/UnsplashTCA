//
//  PhotoListLoadingView.swift
//  UnsplashTCA
//
//  Created by Kevin Abram on 30/04/25.
//

import SwiftUI

struct PhotoListLoadingView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 200)
                .cornerRadius(8)
                .shimmer()

            RoundedRectangle(cornerRadius: 4)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 120, height: 16)
                .shimmer()
        }
        .padding(.vertical, 8)
    }
}

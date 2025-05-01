//
//  ShimmerViewModifier.swift
//  UnsplashTCA
//
//  Created by Kevin Abram on 30/04/25.
//

import SwiftUI

struct ShimmerViewModifier: ViewModifier {
    
    @State private var phase: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    gradient: Gradient(colors: [.clear, Color.white.opacity(0.4), .clear]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .rotationEffect(.degrees(30))
                .offset(x: phase * 300)
                .blendMode(.overlay)
            )
            .mask(content)
            .onAppear {
                withAnimation(
                    Animation.linear(duration: 1.5)
                        .repeatForever(autoreverses: false)
                ) {
                    phase = 1
                }
            }
    }
}

extension View {
    func shimmer() -> some View {
        self.modifier(ShimmerViewModifier())
    }
}

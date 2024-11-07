//
//  RoundedButtonStyle.swift
//  FeedMyRSS
//
//  Created by Marko Vukušić on 07.11.2024.
//

import SwiftUI

struct RoundedButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
    }
}

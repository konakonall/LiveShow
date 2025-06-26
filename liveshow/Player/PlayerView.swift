//
//  PlayerView.swift
//  liveshow
//
//  Created by Liam on 2025/6/26.
//

import SwiftUI

struct PlayerView: View {
    @State private var isAnimating = false
    
    var body: some View {
        Image(systemName: "car.ferry")
            .font(.largeTitle)
            .symbolEffect(.pulse, options: .repeating, isActive: isAnimating)
            .onAppear {
                isAnimating = true
            }
    }
}

#Preview {
    PlayerView()
}

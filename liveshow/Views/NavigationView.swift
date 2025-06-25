//
//  NavigationView.swift
//  liveshow
//
//  Created by Liam on 2025/6/25.
//

import SwiftUI

struct NavigationView: View {
    
    var feed: LiveFeed
    
    var body: some View {
        HStack {
            Image(systemName: "chevron.backward")
                .colorInvert()
                .padding(8)
                .background(Circle().fill(Color.black.opacity(0.3)))
            Text("\(feed.watchingCount)")
                .colorInvert()
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(Color.red)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            Spacer()
            Label("Save Seller", systemImage: "heart")
                .colorInvert()
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(Color.black.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
}

#Preview {
    NavigationView(feed: LiveFeed.mock())
}

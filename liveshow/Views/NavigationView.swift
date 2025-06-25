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
                .padding(8)
                .background(Circle().fill(Color.gray.opacity(0.5)))
            Label("\(feed.watchingCount)", systemImage: "eye.fill")
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                .background(Color.red)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            Spacer()
            Label("Save Seller", systemImage: "heart")
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .padding(.trailing, 28)
                .background(Color.gray.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(alignment: Alignment.trailing) {
                    Image(systemName: "person.fill")
                        .padding(10)
                        .background(Circle().fill(Color.blue.opacity(0.5)))
                }
        }
    }
}

#Preview {
    NavigationView(feed: LiveFeed.mock())
        .preferredColorScheme(.dark)
}

//
//  CommentsView.swift
//  liveshow
//
//  Created by Liam on 2025/6/25.
//

import SwiftUI

struct CommentsView: View {
    @Environment(LiveServiceLocator.self) private var service:
        LiveServiceLocator

    @State private var input: String = ""

    init(feed: LiveFeed) {
    }

    var body: some View {
        HStack {
            TextField(
                "", text: $input,
                prompt: Text("input").foregroundStyle(.black.opacity(0.8))
            )
            .foregroundStyle(.black)
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .padding(.trailing, 16)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white)
            )
            .overlay(alignment: Alignment.trailing) {
                Image(systemName: "heart.fill")
                    .foregroundStyle(.red)
                    .padding(.horizontal, 8)
            }
            Image(systemName: "menucard")
                .colorInvert()
                .padding(8)
                .background(Circle().fill(Color.white))
        }
    }
}

#Preview {
    CommentsView(feed: LiveFeed.mock())
        .preview()
}

//
//  CommentsView.swift
//  liveshow
//
//  Created by Liam on 2025/6/25.
//

import SwiftUI

struct CommentsView: View {
    @State private var input: String = ""
    @State private var viewModel: CommentsViewModel

    init(feed: LiveFeed) {
        self.viewModel = CommentsViewModel(feed: feed)
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
            )
            .overlay(alignment: Alignment.trailing) {
                Image(systemName: "heart.fill")
                    .foregroundStyle(.red)
                    .padding(.horizontal, 8)
            }
            .onSubmit {
                viewModel.addComment(content: input)
            }
            Image(systemName: "menucard")
                .colorInvert()
                .padding(8)
                .background(Circle())
        }
    }
}

#Preview {
    CommentsView(feed: LiveFeed.mock())
        .preview()
}

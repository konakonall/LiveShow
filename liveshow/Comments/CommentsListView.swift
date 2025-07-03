//
//  CommentsListView.swift
//  liveshow
//
//  Created by Liam on 2025/6/26.
//

import SwiftUI

struct CommentsListView: View {
    @State private var viewModel: CommentsViewModel
    
    init(feed: LiveFeed) {
        self.viewModel = CommentsViewModel(feed: feed)
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        ForEach(viewModel.commentsList, id:\.self) { comment in
                            VStack(alignment: .leading) {
                                Text(comment.author.userName)
                                    .font(.headline)
                                Text(comment.content)
                                    .font(.subheadline)
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 4)
                            .id(comment.id)
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .onChange(of: viewModel.commentsList) { _, newComments in
                    if let lastCommentId = newComments.last?.id {
                        withAnimation(.easeInOut(duration: 0.3)) { // 添加动画
                            proxy.scrollTo(lastCommentId, anchor: .bottom)
                        }
                    }
                }
            }

            LinearGradient(
                gradient: Gradient(colors: [.black.opacity(0.9), .clear]),
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 80) // 遮罩高度
            .ignoresSafeArea(.all, edges: .top)
        }
        //FIXME: Not good
        .frame(maxWidth: 300, maxHeight: 300)
        .onAppear {
            viewModel.loadComments()
        }
    }
}

#Preview {
    HStack {
        CommentsListView(feed: LiveFeed.mock())
        Spacer()
    }
        .preview()
}

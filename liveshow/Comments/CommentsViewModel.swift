//
//  CommentsViewModel.swift
//  liveshow
//
//  Created by Liam on 2025/6/26.
//

import Foundation

@MainActor
@Observable class CommentsViewModel: BaseLiveViewModel {
    
    var commentsList: Array<LiveComment> = []
    
    // MARK: - Load Comments List
    
    func loadComments() {
        taskManager.run { [weak self] in
            guard let self = self else { return }
            let comments = try await self.server.getComments(feedId: feed.feedId)
            commentsList += comments
            
            for try await newComments in server.listenForCommentsUpdate(commentsId: comments.last?.id ?? 0, feedId: feed.feedId) {
                commentsList += newComments
            }
        }
    }
    
    
    // MARK: - Add comments
    
    func addComment(content: String) {
        taskManager.run { [weak self] in
            guard let self = self else { return }
            try await self.server.comment(feedId: feed.feedId, content: content)
        }
    }
}

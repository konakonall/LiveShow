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
        guard let server = service?.server else { return }
        
        Task {
            let comments = try await server.getComments(feedId: feed.feedId)
            commentsList += comments
            
            for try await newComments in server.listenForCommentsUpdate(commentsId: comments.last?.id ?? 0, feedId: feed.feedId) {
                commentsList += newComments
            }
        }.store(col: &tasks)
    }
    
    
    // MARK: - Add comments
    
    func addComment() {
        
    }
}

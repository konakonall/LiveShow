//
//  NavigationViewModel.swift
//  liveshow
//
//  Created by Liam on 2025/6/26.
//

import Foundation

@MainActor
@Observable class NavigationViewModel: BaseLiveViewModel {
    
    var isBookmarked: Bool = false
    
    override func setupIfNeeded() {
        super.setupIfNeeded()
        startMonitorWatchCountUpdate(server: server)
        updateBookmark(server: server)
    }
    
    // MARK: - WatchCount
    
    private func startMonitorWatchCountUpdate(server: LiveAppServerProtocol) {
        taskManager.run { [weak self] in
            guard let self = self else { return }
            for try await watchingCount in server.listenForWatchingCountUpdate(feed: feed) {
                feed.watchingCount = watchingCount
            }
        }
    }
    
    // MARK: - Bookmark
    
    private func updateBookmark(server: LiveAppServerProtocol) {
        taskManager.run { [weak self] in
            guard let self else { return }
            let isBookmarked = try await server.isBookmarked(feedId: feed.feedId)
            self.isBookmarked = isBookmarked
        }
    }
    
    func toggleBookmark() {
        self.isBookmarked = !self.isBookmarked
        taskManager.run { [weak self] in
            guard let self else { return }
            let isBookmarked = try await server.toggleBookmarkState(feedId: feed.feedId)
            self.isBookmarked = isBookmarked
        }
    }
}

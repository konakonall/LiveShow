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
    
    override func inject(service: LiveServiceLocator) {
        super.inject(service: service)
        startMonitorWatchCountUpdate(server: service.server)
        updateBookmark(server: service.server)
    }
    
    // MARK: - WatchCount
    
    private func startMonitorWatchCountUpdate(server: LiveAppServerProtocol) {
        Task { [weak self] in
            guard let self else { return }
            for await watchingCount in server.listenForWatchingCountUpdate(feed: feed) {
                feed.watchingCount = watchingCount
            }
        }.store(col: &tasks)
    }
    
    // MARK: - Bookmark
    
    private func updateBookmark(server: LiveAppServerProtocol) {
        Task { [weak self] in
            guard let self else { return }
            let isBookmarked = try await server.isBookmarked(feedId: feed.feedId)
            self.isBookmarked = isBookmarked
        }.store(col: &tasks)
    }
    
    func toggleBookmark() {
        Task { [weak self] in
            guard let self else { return }
            if let isBookmarked = try await service?.server.toggleBookmarkState(feedId: feed.feedId) {
                self.isBookmarked = isBookmarked
            }
        }.store(col: &tasks)
    }
}

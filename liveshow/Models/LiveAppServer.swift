//
//  LiveAppServer.swift
//  liveshow
//
//  Created by Liam on 2025/6/23.
//

import Foundation

protocol LiveAppServerProtocol {
    func fetchConfig() async throws -> AppGlobalConfig
    
    func fetchFeedInfo(feedId: FeedID) async throws -> LiveFeed
    
    func listenForWatchingCountUpdate(feed: LiveFeed) -> AsyncStream<UInt32>
    
    func isBookmarked(feedId: FeedID) async throws -> Bool
    func toggleBookmarkState(feedId: FeedID) async throws -> Bool
    
    func getComments(feedId: FeedID) async throws -> Array<LiveComment>
    func listenForCommentsUpdate(commentsId: UInt64, feedId: FeedID) -> AsyncThrowingStream<Array<LiveComment>, Error>
}

extension LiveAppServerProtocol {
    func fetchConfig() async throws -> AppGlobalConfig {
        throw CancellationError()
    }
    
    func fetchFeedInfo(feedId: FeedID) async throws -> LiveFeed {
        throw CancellationError()
    }
    
    func listenForWatchingCountUpdate(feed: LiveFeed) -> AsyncStream<UInt32> {
        return AsyncStream { _ in
            
        }
    }
    
    func isBookmarked(feedId: FeedID) async throws -> Bool {
        throw CancellationError()
    }
    
    func toggleBookmarkState(feedId: FeedID) async throws -> Bool {
        throw CancellationError()
    }
    
    func getComments(feedId: FeedID) async throws -> Array<LiveComment> {
        throw CancellationError()
    }
    func listenForCommentsUpdate(commentsId: UInt64, feedId: FeedID) -> AsyncThrowingStream<Array<LiveComment>, Error> {
        return AsyncThrowingStream { _ in
            
        }
    }
}

struct MockLiveAppServer: LiveAppServerProtocol {
    private static let NETWORK_SLEEP_SECS = 0.5
    
    private var bookmarkStore: BookmarkStore
    
    init(bookmarkMgr: BookmarkStore) {
        self.bookmarkStore = bookmarkMgr
    }
    
    func fetchConfig() async throws -> AppGlobalConfig {
        return await withCheckedContinuation { continuation in
            DispatchQueue.main.asyncAfter(deadline: .now() + MockLiveAppServer.NETWORK_SLEEP_SECS) {
                continuation.resume(returning: AppGlobalConfig(hello: "Hello User", locale: "ZH"))
            }
        }
    }
    
    func fetchFeedInfo(feedId: FeedID) async throws -> LiveFeed {
        try await sleep()
        return LiveFeed.mock()
    }
    
    func listenForWatchingCountUpdate(feed: LiveFeed) -> AsyncStream<UInt32> {
        var start = feed.watchingCount
        return AsyncStream { continuation in
            let task = Task {
                while true {
                    do {
                        try await self.sleep(1)
                        start += 1
                        continuation.yield(start)
                    } catch {
                        continuation.finish()
                    }
                }
            }
            
            continuation.onTermination = {@Sendable _ in
                task.cancel()
            }
        }
    }
    
    func isBookmarked(feedId: FeedID) async throws -> Bool {
        try await sleep()
        return bookmarkStore.isBookmarked(feedId: feedId)
    }
    
    func toggleBookmarkState(feedId: FeedID) async throws -> Bool {
        try await sleep()
        
        if (bookmarkStore.isBookmarked(feedId: feedId)) {
            bookmarkStore.unBookmark(feedId: feedId)
            return false
        } else {
            bookmarkStore.bookmark(feedId: feedId)
            return true
        }
    }
    
    func getComments(feedId: FeedID) async throws -> Array<LiveComment> {
        try await sleep()
        return LiveComment.mockList(len: 20)
    }
    
    func listenForCommentsUpdate(commentsId: UInt64, feedId: FeedID) -> AsyncThrowingStream<Array<LiveComment>, any Error> {
        return AsyncThrowingStream { continuation in
            var nextCommentIdx = commentsId + 1
            let task = Task {
                while true {
                    do {
                        try await self.sleep(1)
                        continuation.yield([LiveComment.mock(idx: nextCommentIdx)])
                        nextCommentIdx += 1
                    } catch {
                        continuation.finish()
                    }
                }
            }
            
            continuation.onTermination = {@Sendable _ in
                task.cancel()
            }
        }
    }
    
    private func sleep(_ secs: Double = NETWORK_SLEEP_SECS) async throws {
        try await Task.sleep(nanoseconds: UInt64(1_000_000_000 * secs))
    }
}

struct RealLiveAppServer: LiveAppServerProtocol {
}

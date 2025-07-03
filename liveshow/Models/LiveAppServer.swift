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
    func listenForWatchingCountUpdate(feed: LiveFeed) -> AsyncThrowingStream<UInt32, Error>
    
    func isBookmarked(feedId: FeedID) async throws -> Bool
    func toggleBookmarkState(feedId: FeedID) async throws -> Bool
    
    func getComments(feedId: FeedID) async throws -> Array<LiveComment>
    @discardableResult
    func comment(feedId: FeedID, content: String) async throws -> LiveComment
    func listenForCommentsUpdate(commentsId: UInt64, feedId: FeedID) -> AsyncThrowingStream<Array<LiveComment>, Error>
    
    func fetchShopInfo(feedId: FeedID) async throws -> LiveShopInfo
}

// MARK: - Mock Server

class MockLiveAppServer: LiveAppServerProtocol {
    private static let NETWORK_SLEEP_SECS = 0.5
    private var bookmarkedFeed: Set<UInt64> = []
    private var myComments: Array<LiveComment> = []
    
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
    
    func listenForWatchingCountUpdate(feed: LiveFeed) -> AsyncThrowingStream<UInt32, Error> {
        var start = feed.watchingCount
        return AsyncThrowingStream { continuation in
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
    
    private func sleep(_ secs: Double = NETWORK_SLEEP_SECS) async throws {
        try await Task.sleep(nanoseconds: UInt64(1_000_000_000 * secs))
    }
}

// MARK: - Bookmark
extension MockLiveAppServer {
    
    func isBookmarked(feedId: FeedID) async throws -> Bool {
        try await sleep()
        return bookmarkedFeed.contains(feedId)
    }
    
    func toggleBookmarkState(feedId: FeedID) async throws -> Bool {
        try await sleep()
        
        if (bookmarkedFeed.contains(feedId)) {
            bookmarkedFeed.insert(feedId)
            return false
        } else {
            bookmarkedFeed.remove(feedId)
            return true
        }
    }
}

// MARK: - Comment
extension MockLiveAppServer {
    
    func getComments(feedId: FeedID) async throws -> Array<LiveComment> {
        try await sleep()
        return LiveComment.mockList(len: 20)
    }
    
    func comment(feedId: FeedID, content: String) async throws -> LiveComment {
        try await sleep()
        let newComment = LiveComment.mockComment(content: content)
        myComments.append(newComment)
        return newComment
    }
    
    func listenForCommentsUpdate(commentsId: UInt64, feedId: FeedID) -> AsyncThrowingStream<Array<LiveComment>, any Error> {
        return AsyncThrowingStream { continuation in
            var nextCommentIdx = commentsId + 1
            let task = Task {
                while true {
                    do {
                        try await self.sleep(1)
                        var newComments = [LiveComment.mock(idx: nextCommentIdx)]
                        if !myComments.isEmpty {
                            newComments += myComments
                            myComments.removeAll()
                        }
                        continuation.yield(newComments)
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
}

//MARK: - Shop

extension MockLiveAppServer {
    func fetchShopInfo(feedId: FeedID) async throws -> LiveShopInfo {
        try await sleep()
        return LiveShopInfo.mock(feedId: feedId)
    }
}

//
//  LiveShowView.swift
//  liveshow
//
//  Created by Liam on 2025/6/17.
//

import SwiftUI

enum LoadingState {
    case INIT
    case LOADING
    case SUCCESS(LiveFeed)
    case FAILURE(Error)
}

extension View {
    func preview() -> some View {
        let container = DependencyContainer.createForPreview()
        
        return self
            .dependencyContainer(container)
            .preferredColorScheme(.dark)
    }
}

struct LiveShowView: View {
    @Environment(\.dependencyContainer) private var container
    
    let feedId: FeedID
    
    @State private var feed: LiveFeed?
    @State var loadingState: LoadingState = .INIT
    
    var body: some View {
        Group {
            switch loadingState {
            case .INIT:
                loadingView(request: true)
            case .LOADING:
                loadingView()
            case let .SUCCESS(feed):
                feedContentView(feed: feed)
            case let .FAILURE(error):
                errorView(error: error)
            }
        }
    }
}

extension LiveShowView {
    func loadingView(request: Bool = false) -> some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
            .task {
                if (request) {
                    await fetchFeedAndShopInfo(feedId: feedId)
                }
            }
    }
    
    func errorView(error: Error) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.orange)
            
            Text("加载失败")
                .font(.title2.bold())
                .foregroundColor(.white)
            
            Text(error.localizedDescription)
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("重试") {
                loadingState = .LOADING
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .padding()
    }
    
    func feedContentView(feed: LiveFeed) -> some View {
        ZStack {
            PlayerView()
            
            VStack {
                NavigationView(feed: feed)
                
                Spacer()
                
                HStack {
                    Bidding()
                    Spacer()
                }
                
                HStack {
                    CommentsListView(feed: feed)
                    Spacer()
                }
                // 评论输入框
                CommentsView(feed: feed)
                
                if let shopInfo = feed.shopInfo {
                    ShopCard(shopInfo: shopInfo)
                        .padding(.top, 10)
                }
            }
            .padding(.horizontal, 8)
            .safeAreaPadding(.bottom)
        }
    }
}

extension LiveShowView {
    func fetchFeedAndShopInfo(feedId: FeedID) async {
        do {
            // 使用 DependencyContainer 获取服务
            let server = container.resolve(LiveAppServerProtocol.self)
            async let feedInfoFetch = server.fetchFeedInfo(feedId: feedId)
            async let shopInfoFetch = server.fetchShopInfo(feedId: feedId)
            
            do {
                let feed = try await feedInfoFetch
                let shopInfo = try? await shopInfoFetch
                
                feed.shopInfo = shopInfo
                self.feed = feed
                self.loadingState = .SUCCESS(feed)
            } catch {
                self.loadingState = .FAILURE(error)
            }
        } catch {
            self.loadingState = .FAILURE(error)
        }
    }
}

// MARK: - 便利的初始化器

extension LiveShowView {
    
    // 使用自定义容器的初始化器（主要用于测试）
    init(feedId: FeedID, container: DependencyContainer) {
        self.feedId = feedId
        self._container = Environment(\.dependencyContainer)
    }
}
// MARK: - Preview 支持

#Preview("Live Show View") {
    LiveShowView(feedId: 1)
        .preview()
}

#Preview("Loading State") {
    LiveShowView(feedId: 1, loadingState: .LOADING)
        .preview()
}

#Preview("Error State") {
    struct MockError: Error, LocalizedError {
        var errorDescription: String? { "网络连接失败，请检查网络设置" }
    }
    
    return LiveShowView(feedId: 1, loadingState: .FAILURE(MockError()))
        .preview()
}

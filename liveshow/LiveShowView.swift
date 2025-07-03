//
//  LiveShowView.swift
//  liveshow
//
//  Created by Liam on 2025/6/17.
//

import SwiftUI

enum LoadingState {
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
    @State var loadingState: LoadingState = .LOADING
    
    var body: some View {
        Group {
            switch loadingState {
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
    func loadingView() -> some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
            .task {
                do {
                    // 使用 DependencyContainer 获取服务
                    let server = container.resolve(LiveAppServerProtocol.self)
                    let feed = try await server.fetchFeedInfo(feedId: feedId)
                    self.feed = feed
                    self.loadingState = .SUCCESS(feed)
                } catch {
                    self.loadingState = .FAILURE(error)
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
                // 使用 DependencyContainer 创建的 NavigationView
                NavigationView(feed: feed)
                
                Spacer()
                
                HStack {
                    // 使用 DependencyContainer 创建的 CommentsListView
                    CommentsListView(feed: feed)
                    Spacer()
                }
                // 评论输入框
                CommentsView(feed: feed)
            }
            .padding(.horizontal, 8)
            .safeAreaPadding(.bottom)
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
    LiveShowView(feedId: 1, loadingState: .SUCCESS(LiveFeed.mock()))
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

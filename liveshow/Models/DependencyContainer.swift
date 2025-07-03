//
//  DependencyContainer.swift
//  liveshow
//
//  Created by Liam on 2025/7/1.
//

import Foundation
import SwiftUI

// MARK: - 依赖容器协议

protocol DependencyContainerProtocol {
    func resolve<T>(_ type: T.Type) -> T
    func register<T>(_ type: T.Type, factory: @escaping () -> T)
    func registerSingleton<T>(_ type: T.Type, factory: @escaping () -> T)
    func reset()
}

// MARK: - 具体的依赖容器实现

@Observable
class DependencyContainer: DependencyContainerProtocol {
    
    // 存储工厂方法
    private var factories: [String: () -> Any] = [:]
    
    // 存储单例实例
    private var singletons: [String: Any] = [:]
    
    // 标记哪些类型是单例
    private var singletonTypes: Set<String> = []
    // 全局共享容器
    static let shared = DependencyContainer()
    
    // MARK: - 初始化器
    
    // 私有初始化器用于单例
    private convenience init() {
        self.init(registerDefaults: true)
    }
    
    // 公共初始化器用于测试和预览
    init(registerDefaults: Bool = true) {
        if registerDefaults {
            registerDefaultDependencies()
        }
    }
    
    // MARK: - 注册依赖
    
    func register<T>(_ type: T.Type, factory: @escaping () -> T) {
        let key = String(describing: type)
        factories[key] = factory
        singletonTypes.remove(key) // 移除单例标记
    }
    
    func registerSingleton<T>(_ type: T.Type, factory: @escaping () -> T) {
        let key = String(describing: type)
        factories[key] = factory
        singletonTypes.insert(key) // 标记为单例
    }
    
    // MARK: - 解析依赖
    
    func resolve<T>(_ type: T.Type) -> T {
        let key = String(describing: type)
        
        // 如果是单例且已存在，直接返回
        if singletonTypes.contains(key), let singleton = singletons[key] as? T {
            return singleton
        }
        
        // 从工厂创建实例
        guard let factory = factories[key] else {
            fatalError("❌ Dependency '\(key)' not registered in DependencyContainer")
        }
        
        guard let instance = factory() as? T else {
            fatalError("❌ Failed to cast dependency '\(key)' to type \(T.self)")
        }
        
        // 如果是单例，存储实例
        if singletonTypes.contains(key) {
            singletons[key] = instance
        }
        
        return instance
    }
    
    // MARK: - 重置容器
    
    func reset() {
        singletons.removeAll()
        // 保留工厂注册，只清除实例
    }
    
    func resetAll() {
        factories.removeAll()
        singletons.removeAll()
        singletonTypes.removeAll()
        registerDefaultDependencies()
    }
    
    // MARK: - 注册默认依赖
    
    private func registerDefaultDependencies() {
        // 核心服务 - 单例
        
        registerSingleton(LiveAppConfigCenter.self) {
            LiveAppConfigCenter()
        }
        registerSingleton(LiveAppServerProtocol.self) {
            MockLiveAppServer()
        }
    }
}

// MARK: - 便利扩展

extension DependencyContainer {
    
    // 便利方法：获取服务
    var server: LiveAppServerProtocol {
        resolve(LiveAppServerProtocol.self)
    }
    var configCenter: LiveAppConfigCenter {
        resolve(LiveAppConfigCenter.self)
    }
}

// MARK: - 测试支持

#if DEBUG
extension DependencyContainer {
    
    // 创建测试容器的便利方法
    static func createForTesting() -> DependencyContainer {
        let container = DependencyContainer(registerDefaults: false)
        container.setupForTesting()
        return container
    }
    
    // 创建预览容器的便利方法
    static func createForPreview() -> DependencyContainer {
        let container = DependencyContainer(registerDefaults: false)
        container.setupForPreview()
        return container
    }
    
    // 为测试配置 Mock 依赖
    func setupForTesting() {
        reset()
        
        register(LiveAppServerProtocol.self) {
            MockLiveAppServer()
        }
        
        register(LiveAppConfigCenter.self) {
            MockLiveAppConfigCenter()
        }
    }
    
    // 为 Preview 配置依赖
    func setupForPreview() {
        reset()
        
        register(LiveAppServerProtocol.self) {
            PreviewLiveAppServer()
        }
        
        register(LiveAppConfigCenter.self) {
            PreviewLiveAppConfigCenter()
        }
    }
}

class MockLiveAppConfigCenter: LiveAppConfigCenter {
    // Mock 实现
}

class PreviewLiveAppServer: LiveAppServerProtocol {
    func fetchConfig() async throws -> AppGlobalConfig {
        throw CancellationError()
    }
    
    func listenForWatchingCountUpdate(feed: LiveFeed) -> AsyncThrowingStream<UInt32, any Error> {
        return AsyncThrowingStream {_ in 
            
        }
    }
    
    func comment(feedId: FeedID, content: String) async throws -> LiveComment {
        throw CancellationError()
    }
    
    func listenForCommentsUpdate(commentsId: UInt64, feedId: FeedID) -> AsyncThrowingStream<Array<LiveComment>, any Error> {
        return AsyncThrowingStream {_ in 
            
        }
    }
    
    func fetchFeedInfo(feedId: FeedID) async throws -> LiveFeed {
        return LiveFeed.mock()
    }
    
    func getComments(feedId: FeedID) async throws -> [LiveComment] {
        return [
            LiveComment.mockComment(content: "Great live stream!"),
            LiveComment.mockComment(content: "Love this content!"),
            LiveComment.mockComment(content: "Amazing!")
        ]
    }
    
    func listenForCommentsUpdate(commentsId: Int, feedId: FeedID) -> AsyncStream<[LiveComment]> {
        AsyncStream { continuation in
            // Mock 实现
            continuation.finish()
        }
    }
    
    func listenForWatchingCountUpdate(feed: LiveFeed) -> AsyncStream<UInt32> {
        AsyncStream { continuation in
            // Mock 实现
            continuation.finish()
        }
    }
    
    func isBookmarked(feedId: FeedID) async throws -> Bool {
        return true
    }
    
    func toggleBookmarkState(feedId: FeedID) async throws -> Bool {
        return false
    }
}

class PreviewLiveAppConfigCenter: LiveAppConfigCenter {
    // Preview 实现
}
#endif

// MARK: - SwiftUI Environment 集成

private struct DependencyContainerKey: EnvironmentKey {
    static let defaultValue: DependencyContainer = DependencyContainer.shared
}

extension EnvironmentValues {
    var dependencyContainer: DependencyContainer {
        get { self[DependencyContainerKey.self] }
        set { self[DependencyContainerKey.self] = newValue }
    }
}
// MARK: - Property Wrapper

@propertyWrapper
struct Injected<T> {
    private let container: DependencyContainer
    private let type: T.Type
    
    var wrappedValue: T {
        return container.resolve(type)
    }
    
    init(_ type: T.Type, container: DependencyContainer = DependencyContainer.shared) {
        self.type = type
        self.container = container
    }
}

// MARK: - ViewModifier

struct DependencyInjectionModifier: ViewModifier {
    let container: DependencyContainer
    
    func body(content: Content) -> some View {
        content
            .environment(\.dependencyContainer, container)
    }
}

extension View {
    func dependencyContainer(_ container: DependencyContainer) -> some View {
        self.modifier(DependencyInjectionModifier(container: container))
    }
}

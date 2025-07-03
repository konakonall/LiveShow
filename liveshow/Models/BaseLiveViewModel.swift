//
//  BaseLiveViewModel.swift
//  liveshow
//
//  Created by Liam on 2025/6/26.
//

import Foundation

@MainActor
class BaseLiveViewModel {
    
    let feed: LiveFeed
    let container: DependencyContainer
    
    // 保持向后兼容的 tasks 数组
    internal lazy var taskManager: TaskManager = TaskManager(errorHandler: { [weak self] error in
        self?.handleError(error)
    })
    
    // 通过容器注入的依赖 - 使用简单的延迟加载
    lazy var server: LiveAppServerProtocol = container.resolve(LiveAppServerProtocol.self)
    lazy var configCenter: LiveAppConfigCenter = container.resolve(LiveAppConfigCenter.self)
    
    // 标记为 required 以支持子类的静态工厂方法
    required init(feed: LiveFeed, container: DependencyContainer = DependencyContainer.shared) {
        self.feed = feed
        self.container = container
        
        // 依赖注入完成后自动调用设置方法
        setupIfNeeded()
    }
    
    // 子类可以重写此方法来执行初始化逻辑
    open func setupIfNeeded() {
        // 默认实现为空，子类可以重写
    }
    
    // TODO: 这里不知道如何解决
    deinit {
//        taskManager.cancelAll()
    }
}

// MARK: - 测试友好的初始化器

#if DEBUG
extension BaseLiveViewModel {
    
    // 专用于测试的便利初始化器
    convenience init(feed: LiveFeed, testContainer: DependencyContainer) {
        self.init(feed: feed, container: testContainer)
    }
    
    // 便利方法：使用 Mock 依赖创建实例
    static func createForTesting(feed: LiveFeed) -> Self {
        let testContainer = DependencyContainer.createForTesting()
        return Self.init(feed: feed, container: testContainer)
    }
    // 便利方法：使用 Preview 依赖创建实例
    static func createForPreview(feed: LiveFeed) -> Self {
        let previewContainer = DependencyContainer.createForPreview()
        return Self.init(feed: feed, container: previewContainer)
    }
}
#endif

// MARK: - 类型安全的依赖访问

extension BaseLiveViewModel {
    
    // 类型安全的依赖解析方法
    func resolve<T>(_ type: T.Type) -> T {
        return container.resolve(type)
    }
    
    // 便利方法：获取特定类型的服务
    func getService<T>(_ type: T.Type) -> T {
        return container.resolve(type)
    }
}

// MARK: - 错误处理和日志

extension BaseLiveViewModel {
    
    // 统一的错误处理
    func handleError(_ error: Error) {
        print("❌ ViewModel Error: \(error.localizedDescription)")
    }
    
    // 调试信息
    func logDependencyInfo() {
        print("📋 ViewModel Dependencies:")
        print("  - Server: \(type(of: server))")
        print("  - ConfigCenter: \(type(of: configCenter))")
        print("  - Active Tasks: \(String(describing: taskManager.count))")
    }
}

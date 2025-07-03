//
//  liveshowApp.swift
//  liveshow
//
//  Created by Liam on 2025/6/17.
//

import SwiftUI
import Factory

extension Container {
    var server: Factory<LiveAppServerProtocol> {
        self {
            MockLiveAppServer()
        }
    }
}

@main
struct liveshowApp: App {
    @State private var dependencyContainer = DependencyContainer.shared
    
    init() {
        setupDependencies()
    }
    
    private func setupDependencies() {
        // 根据环境配置不同的依赖
        #if DEBUG
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            // Preview 环境 - 使用专门的预览容器
            dependencyContainer = DependencyContainer.createForPreview()
        } else if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil {
            // 测试环境 - 使用专门的测试容器
            dependencyContainer = DependencyContainer.createForTesting()
        }
        // 其他情况使用默认的生产环境配置 (shared)
        #endif
        
        // 初始化配置中心
        let configCenter = dependencyContainer.resolve(LiveAppConfigCenter.self)
        let server = dependencyContainer.resolve(LiveAppServerProtocol.self)
        configCenter.initConfig(server: server)
        // 可以在这里添加其他全局配置
        setupGlobalConfiguration()
    }
    
    private func setupGlobalConfiguration() {
        // 全局配置，如主题、字体等
        // 可以从 configCenter 读取配置
    }
    
    var body: some Scene {
        WindowGroup {
            LiveShowView(feedId: 1)
                .dependencyContainer(dependencyContainer)
                .preferredColorScheme(.dark)
                .onAppear {
                    // App 启动后的初始化逻辑
                    handleAppLaunch()
                }
        }
    }
    
    private func handleAppLaunch() {
        // 应用启动后的处理逻辑
        print("📱 App launched with DependencyContainer")
        
        #if DEBUG
        // 开发环境下的调试信息
        dependencyContainer.logDependencyInfo()
        #endif
    }
}

// MARK: - DependencyContainer 调试扩展

#if DEBUG
extension DependencyContainer {
    
    func logDependencyInfo() {
        print("🔧 DependencyContainer Status:")
        print("  - Server: \(type(of: resolve(LiveAppServerProtocol.self)))")
        print("  - ConfigCenter: \(type(of: resolve(LiveAppConfigCenter.self)))")
    }
}
#endif

// MARK: - 应用生命周期处理

extension liveshowApp {
    
    // 应用进入后台
    func handleAppDidEnterBackground() {
        // 可以在这里暂停一些服务
        print("📱 App entered background")
    }
    
    // 应用回到前台
    func handleAppWillEnterForeground() {
        // 可以在这里恢复一些服务
        print("📱 App will enter foreground")
    }
    
    // 应用即将终止
    func handleAppWillTerminate() {
        // 清理资源
        dependencyContainer.reset()
        print("📱 App will terminate")
    }
}


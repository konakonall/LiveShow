//
//  TaskManager.swift
//  liveshow
//
//  Created by Liam on 2025/7/3.
//

import Foundation

@MainActor
class TaskManager {
    // 保持向后兼容的 tasks 数组
    private var tasks: Dictionary<String, Task<Void, Never>> = [:]
    private let errorHandler: @MainActor (any Error)->Void
    
    init(errorHandler: @escaping (any Error)->Void) {
        self.errorHandler = errorHandler
    }
    
    func run(_ operation: @escaping @isolated(any) () async throws -> Void, name: String = #function) {
        tasks[name]?.cancel()
        
        let task = Task { [weak self] in
            guard let self = self else { return }
            do {
                try await operation()
            } catch {
                self.errorHandler(error)
            }
        }
        tasks[name] = task
    }
    
    nonisolated func cancelAll() {
        Task { [weak self] in
            guard let self = self else { return }
            await internal_cancelAll()
        }
        
    }
    
    private func internal_cancelAll() {
        tasks.values.forEach {
            $0.cancel()
        }
        tasks.removeAll()
    }
    
    func count() -> Int {
        return tasks.count
    }
}



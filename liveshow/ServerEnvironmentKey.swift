//
//  ServerEnvironmentKey.swift
//  liveshow
//
//  Created by Liam on 2025/6/23.
//

import Foundation
import SwiftUICore

struct LiveAppServerKey: EnvironmentKey {
    static var defaultValue: LiveAppServer?
}

extension EnvironmentValues {
    var server: LiveAppServer {
        get { self[LiveAppServerKey.self]! }
        set { self[LiveAppServerKey.self] = newValue }
    }
}

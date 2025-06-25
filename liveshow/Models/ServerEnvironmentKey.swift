//
//  ServerEnvironmentKey.swift
//  liveshow
//
//  Created by Liam on 2025/6/23.
//

import Foundation
import SwiftUICore

struct LiveAppServerKey: EnvironmentKey {
    static var defaultValue: LiveAppServerProtocol = RealLiveAppServer()
}

extension EnvironmentValues {
    var server: LiveAppServerProtocol {
        get { self[LiveAppServerKey.self] }
        set { self[LiveAppServerKey.self] = newValue }
    }
}

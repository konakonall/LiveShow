//
//  LiveShowView.swift
//  liveshow
//
//  Created by Liam on 2025/6/17.
//

import SwiftUI

struct LiveShowView: View {
    @EnvironmentObject private var delegate: LiveAppDelegate
    @EnvironmentObject var configCenter: LiveAppConfigCenter
    @Environment(\.server) var server: LiveAppServer
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text(configCenter.helloMessage)
                .font(.headline)
        }
        .padding()
    }
}

#Preview {
    LiveShowView()
        .environment(\.server, LiveAppServer())
}

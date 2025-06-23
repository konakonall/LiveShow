//
//  LiveAppDelegate.swift
//  liveshow
//
//  Created by Liam on 2025/6/23.
//

import Foundation
import UIKit


class LiveAppDelegate : NSObject, UIApplicationDelegate, ObservableObject {
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        NSLog("applicationDidBecomeActive")
    }
}

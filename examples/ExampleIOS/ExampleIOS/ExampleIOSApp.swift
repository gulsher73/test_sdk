//
//  ExampleIOSApp.swift
//  ExampleIOS
//
//  Created by Gulsher on 10/03/26.
//

import SwiftUI
import TestFlutterSDK

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        TestSDK.initialize()
        return true
    }
}

@main
struct ExampleIOSApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

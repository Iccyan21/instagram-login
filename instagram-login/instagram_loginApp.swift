//
//  instagram_loginApp.swift
//  instagram-login
//
//  Created by 水原　樹 on 2024/10/09.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

@main
struct YourApp: App {

    @Environment(\.openURL) var openURL
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                //ContentView()
                InstagramLoginView()
            }
        }
    }
}

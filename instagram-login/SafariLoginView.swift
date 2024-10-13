//
//  SafariLoginView.swift
//  instagram-login
//
//  Created by 水原　樹 on 2024/10/09.
//

import SwiftUI
import SafariServices
import SwiftUI




//
//struct SafariLoginView: View {
//    @State private var showingSafari = false
//    
//    var body: some View {
//        VStack {
//            Button("Login with Instagram") {
//                showingSafari = true
//            }
//            .sheet(isPresented: $showingSafari) {
//                if let url = URL(string: "https://api.instagram.com/oauth/authorize?client_id=345044888629569&redirect_uri=https://play-archive.com/auth/&scope=user_profile,user_media&response_type=code") {
//                    SafariView(url: url)
//                } else {
//                    Text("Invalid URL")
//                }
//            }
//        }
//    }
//}
//
//#Preview {
//    SafariLoginView()
//}

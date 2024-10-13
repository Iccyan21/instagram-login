//
//  InstagramLoginView.swift
//  instagram-login
//
//  Created by 水原　樹 on 2024/10/09.
//
// iccyan_engineer
// itsuki0221
// https://api.instagram.com/oauth/authorize?client_id=345044888629569&redirect_uri=https://0.0.0.0:8000/accounts/auth/&scope=user_profile,user_media&response_type=code
import SwiftUI
import AuthenticationServices

struct InstagramLoginView: View {
    // ユーザー名を表示するための@Stateプロパティ
    @State private var username: String = ""
    
    var body: some View {
        VStack {
            // Instagramのユーザー名を表示
            if username.isEmpty {
                Text("Login with Instagram") // 認証前のタイトル
            } else {
                Text("Instagram Username: \(username)") // 認証後にユーザー名を表示
            }
            
            Button(action: {
                // ボタンが押された時にInstagramのログイン処理を開始
                InstagramLoginHelper { fetchedUsername in
                    self.username = fetchedUsername // ユーザー名を更新
                }.startInstagramLogin()
            }) {
                Text(username.isEmpty ? "Login with Instagram" : "Logged in as \(username)")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
}

class InstagramLoginHelper: NSObject, ASWebAuthenticationPresentationContextProviding {
    var completion: ((String) -> Void)?
    
    init(completion: @escaping (String) -> Void) {
        self.completion = completion
    }
    
    func startInstagramLogin() {
        let clientID = "XXXXXXXXXX"  // InstagramのクライアントID
        let redirectURI = "https://XXXXXXXXX/accounts/auth/"
        let authURL = "https://api.instagram.com/oauth/authorize?client_id=\(clientID)&redirect_uri=\(redirectURI)&scope=user_profile,user_media&response_type=code"
        let scheme = "XXXXXXXXXX"  // アプリのカスタムスキーム
        
        if let url = URL(string: authURL) {
            let session = ASWebAuthenticationSession(url: url, callbackURLScheme: scheme) { callbackURL, error in
                if let error = error {
                    print("Error during authentication: \(error.localizedDescription)")
                    return
                }
                
                if let callbackURL = callbackURL {
                    if let accessToken = URLComponents(string: callbackURL.absoluteString)?.queryItems?.first(where: { $0.name == "access_token" })?.value {
                        DispatchQueue.main.async {
                            self.useInstagramAccessToken(accessToken)
                        }
                    } else {
                        print("アクセストークンが含まれていません")
                    }
                } else {
                    print("callbackURLがnilです")
                }
            }
            
            session.presentationContextProvider = self
            session.start()
        }
    }
    
    // Instagram APIでアクセストークンを使用してユーザー情報を取得
    func useInstagramAccessToken(_ accessToken: String) {
        let userInfoURL = "https://graph.instagram.com/me?fields=id,username&access_token=\(accessToken)"
        
        guard let url = URL(string: userInfoURL) else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching Instagram user info: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data returned")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let username = json["username"] as? String {
                    print("Instagram Username: \(username)")
                    DispatchQueue.main.async {
                        // 取得したユーザー名をViewに反映
                        self.completion?(username)
                    }
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    // ASWebAuthenticationPresentationContextProvidingの実装
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return UIApplication.shared.windows.first { $0.isKeyWindow } ?? ASPresentationAnchor()
    }
}

#Preview {
    InstagramLoginView()
}

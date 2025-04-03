//
//  GoAnimeApp.swift
//  GoAnime
//
//  Created by Rashad Milton on 3/21/25.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
      
//      // Force sign out for testing 
             do {
                 try Auth.auth().signOut()
             } catch {
                 print("Error signing out: \(error.localizedDescription)")
             }
    return true
  }
}

@main
struct GoAnimeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var favoritesManager = FavoritesManager()
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            if authViewModel.isUserLoggedIn {
                MainTabView()
                    .environmentObject(favoritesManager)
                    .environmentObject(authViewModel)
            } else {
                LoginView()
                    .environmentObject(authViewModel)
            }
        }
    }
}

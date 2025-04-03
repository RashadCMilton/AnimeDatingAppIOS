//
//  MainTabView.swift
//  GoAnime
//
//  Created by Rashad Milton on 3/22/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            NavigationView {
                HomeView()
                Text("Home")
                    .navigationTitle(Text("Home"))
            }
            .tabItem {
                Image(systemName: "house")
                Text("Home")
            }
            
            NavigationView {
                SearchAnimeView()
                Text("Search")
                    .navigationTitle(Text("Search"))
            }
            .tabItem {
                Image(systemName: "magnifyingglass")
                Text("Search")
            }
            NavigationView {
                FavoritesView()
                Text("Favorites")
                    .navigationTitle(Text("Favorites"))
            }
            .tabItem {
                Image(systemName: "star")
                Text("Favorites")
            }
            NavigationView {
                ProfileView()
                Text("Profile")
                    .navigationTitle(Text("Profile"))
            }
            .tabItem {
                Image(systemName: "person.crop.circle")
                Text("Profile")
            }
            NavigationView {
                SimpleMatchingView()
                Text("Matches")
                    .navigationTitle(Text("Your Matches"))
            }
            .tabItem {
                Image(systemName: "heart.fill")
                Text("Matches")
            }
        }
    }
}

#Preview {
    MainTabView()
}

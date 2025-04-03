//
//  FavoritesManager.swift
//  GoAnime
//
//  Created by Rashad Milton on 3/22/25.
//


import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class FavoritesManager: ObservableObject {
    @Published var favorites: [AnimeData] = []
    private let favoritesKey = "savedFavoriteAnimes"
    private let db = Firestore.firestore()
    private var authStateListener: AuthStateDidChangeListenerHandle?
    private var currentUserId: String?
    
    init() {
        // Listen for auth state changes
        authStateListener = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            guard let self = self else { return }
            
            // If user ID changed (sign in/out/switch user)
            if self.currentUserId != user?.uid {
                // Clear local favorites when user changes
                self.favorites = []
                self.currentUserId = user?.uid
                
                // If we have a new user, load their favorites
                if let userId = user?.uid {
                    self.loadFirebaseFavorites(for: userId)
                } else {
                    // No user is logged in - clear favorites
                    UserDefaults.standard.removeObject(forKey: self.favoritesKey)
                }
            }
        }
    }
    
    deinit {
        // Remove auth listener when class is deallocated
        if let listener = authStateListener {
            Auth.auth().removeStateDidChangeListener(listener)
        }
    }
    
    func toggleFavorite(anime: AnimeData) {
        if isFavorite(anime: anime) {
            removeFromFavorites(anime: anime)
        } else {
            addToFavorites(anime: anime)
        }
    }
    
    func addToFavorites(anime: AnimeData) {
        guard !isFavorite(anime: anime) else { return }
        favorites.append(anime)
        saveFavorites()
        updateFirebaseProfile()
    }
    
    func removeFromFavorites(anime: AnimeData) {
        favorites.removeAll { $0.id == anime.id }
        saveFavorites()
        updateFirebaseProfile()
    }
    
    func isFavorite(anime: AnimeData) -> Bool {
        return favorites.contains { $0.id == anime.id }
    }
    
    private func saveFavorites() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Cannot save favorites - no user logged in")
            return
        }
        
        // Use user-specific key for UserDefaults
        let userSpecificKey = "\(favoritesKey)_\(userId)"
        
        do {
            let encodedData = try JSONEncoder().encode(favorites)
            UserDefaults.standard.set(encodedData, forKey: userSpecificKey)
        } catch {
            print("Error saving favorites: \(error.localizedDescription)")
        }
    }
    
    private func loadFavorites() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Cannot load favorites - no user logged in")
            return
        }
        
        // Use user-specific key for UserDefaults
        let userSpecificKey = "\(favoritesKey)_\(userId)"
        
        guard let savedData = UserDefaults.standard.data(forKey: userSpecificKey) else {
            print("No saved favorites found for user \(userId)")
            return
        }
        
        do {
            favorites = try JSONDecoder().decode([AnimeData].self, from: savedData)
            print("Loaded \(favorites.count) favorites from local storage for user \(userId)")
        } catch {
            print("Error loading favorites: \(error.localizedDescription)")
        }
    }
    
    // Function to update Firebase profile with favorites
    private func updateFirebaseProfile() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not logged in - can't update Firebase profile")
            return
        }
        
        // Extract anime IDs or titles for Firebase storage
        let favoriteAnimeTitles = favorites.map { $0.title }
        
        // Update only the favoriteAnime field
        db.collection("profiles").document(userId).updateData([
            "favoriteAnime": favoriteAnimeTitles
        ]) { error in
            if let error = error {
                print("Error updating profile favorites: \(error.localizedDescription)")
            } else {
                print("Successfully updated profile favorites in Firebase")
            }
        }
    }
    
    // Function to load favorites from Firebase
    private func loadFirebaseFavorites(for userId: String) {
        print("Loading favorites from Firebase for user \(userId)")
        
        db.collection("profiles").document(userId).getDocument { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching user profile: \(error.localizedDescription)")
                // Fall back to local storage
                self.loadFavorites()
                return
            }
            
            guard let data = snapshot?.data(),
                  let firebaseFavorites = data["favoriteAnime"] as? [String] else {
                print("No favorites found in Firebase or invalid data format")
                // Fall back to local storage
                self.loadFavorites()
                return
            }
            
            print("Found \(firebaseFavorites.count) favorites in Firebase")
          
            
            //Just load local favorites as fallback
            self.loadFavorites()
        }
    }
}

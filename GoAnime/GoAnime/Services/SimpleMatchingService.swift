//
//  SimpleMatchingService.swift
//  GoAnime
//
//  Created by Rashad Milton on 3/22/25.
//


import Foundation
import FirebaseFirestore
import FirebaseAuth

class SimpleMatchingService: ObservableObject {
    private let db = Firestore.firestore()
    @Published var matches: [UserMatch] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    struct UserMatch: Identifiable {
          let id: String
          let username: String
          let favoriteAnime: [String]
          let matchScore: Int
    }
    func findMatches() {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            errorMessage = "Not logged in"
            return
        }
        
        isLoading = true
        
        // Get current user's favorites
        db.collection("profiles").document(currentUserId).getDocument { [weak self] snapshot, error in
            guard let self = self, let data = snapshot?.data(),
                  let myFavorites = data["favoriteAnime"] as? [String] else {
                self?.isLoading = false
                self?.errorMessage = "Couldn't find your profile"
                return
            }
            
            // Get other users
            self.db.collection("profiles").getDocuments { snapshot, error in
                self.isLoading = false
                
                guard let documents = snapshot?.documents else {
                    self.errorMessage = "Couldn't load users"
                    return
                }
                
                var matches: [UserMatch] = []
                
                for doc in documents {
                    // Skip current user
                    if doc.documentID == currentUserId { continue }
                    
                    guard let username = doc.data()["username"] as? String,
                          let theirFavorites = doc.data()["favoriteAnime"] as? [String] else {
                        continue
                    }
                    
                    // Simple matching - count common anime
                    let common = Set(myFavorites).intersection(Set(theirFavorites))
                    let matchScore = common.count
                    
                    // Only include if they have at least one anime in common
                    if matchScore > 0 {
                        matches.append(UserMatch(
                            id: doc.documentID,
                            username: username,
                            favoriteAnime: Array(common),
                            matchScore: matchScore
                        ))
                    }
                }
                
                // Sort by number of matches (highest first)
                self.matches = matches.sorted(by: { $0.matchScore > $1.matchScore })
            }
        }
    }
}

//
//  AuthViewModel.swift
//  GoAnime
//
//  Created by Rashad Milton on 3/22/25.
//


import FirebaseAuth
import FirebaseFirestore

class AuthViewModel: ObservableObject {
    @Published var isUserLoggedIn: Bool = false
    @Published var currentUser: User?
    @Published var errorMessage: String?
    @Published var isAuthInitialized: Bool = false

    
    private var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?
    private let db = Firestore.firestore()
    
    init() {
        // Listen for authentication state changes
        authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.isUserLoggedIn = user != nil
            self?.currentUser = user
            self?.isAuthInitialized = true
        }
    }
    
    deinit {
        if let handle = authStateDidChangeListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            errorMessage = error.localizedDescription
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
    func createProfile(username: String, bio: String, favoriteAnime: [String]) {
        guard let userId = currentUser?.uid else {
            errorMessage = "User not logged in"
            return
        }
        
        let profileData: [String: Any] = [
            "username": username,
            "bio": bio,
            "favoriteAnime": favoriteAnime,
            "createdAt": Timestamp()
        ]
        
        db.collection("profiles").document(userId).setData(profileData) { [weak self] error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                print("Error creating profile: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchUserProfile(completion: @escaping ([String: Any]?) -> Void) {
        guard let userId = currentUser?.uid else {
            errorMessage = "User not logged in"
            completion(nil)
            return
        }
        
        db.collection("profiles").document(userId).getDocument { snapshot, error in
            if let error = error {
                print("Error fetching profile: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            if let data = snapshot?.data() {
                completion(data)
            } else {
                completion(nil)
            }
        }
    }
}

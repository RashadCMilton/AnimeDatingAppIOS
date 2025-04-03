//
//  ProfileView.swift
//  GoAnime
//
//  Created by Rashad Milton on 3/22/25.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var favoritesManager: FavoritesManager
    
    @State private var username: String = ""
    @State private var bio: String = ""
    @State private var isEditMode: Bool = false
    @State private var profileData: [String: Any]? = nil
    @State private var isLoading: Bool = true
    @State private var isAuthInitialized: Bool = false
    
    
    var body: some View {
        NavigationView {
            ZStack {
                if isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                } else if profileData != nil && !isEditMode {
                    // Display existing profile
                    displayProfileView
                } else {
                    // Create or edit profile
                    editProfileView
                }
            }
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if profileData != nil {
                        Button(isEditMode ? "Cancel" : "Edit") {
                            isEditMode.toggle()
                            if isEditMode == false {
                                loadProfileData()
                            }
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Sign Out") {
                        authViewModel.signOut()
                    }
                }
            }
            .onAppear {
                if authViewModel.isAuthInitialized {
                    loadProfileData()
                }
                
            }
            
            .onChange(of: favoritesManager.favorites) {
                if !isEditMode {
                    loadProfileData()
                }
            }
            .alert(isPresented: Binding<Bool>(
                get: {
                    // Only show the alert after authentication has been confirmed
                    isAuthInitialized && authViewModel.errorMessage != nil
                },
                set: {
                    // Clear the error message when the alert is dismissed
                    if !$0 {
                        authViewModel.errorMessage = nil
                    }
                }
            )) {
                Alert(
                    title: Text("Error"),
                    message: Text(authViewModel.errorMessage ?? "Unknown error"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    private var displayProfileView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                profileHeader
                
                Divider()
                
                Text("Bio")
                    .font(.headline)
                Text(profileData?["bio"] as? String ?? "")
                    .padding(.bottom)
                
                Text("Favorite Anime")
                    .font(.headline)
                ForEach(profileData?["favoriteAnime"] as? [String] ?? [], id: \.self) { anime in
                    HStack {
                        Text("• \(anime)")
                        Spacer()
                    }
                    .padding(.vertical, 4)
                }
            }
            .padding()
        }
    }
    
    private var profileHeader: some View {
        HStack(spacing: 20) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(.blue)
            
            VStack(alignment: .leading) {
                Text(profileData?["username"] as? String ?? "Username")
                    .font(.title)
                    .bold()
                
                if let email = authViewModel.currentUser?.email {
                    Text(email)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
    
    private var editProfileView: some View {
        Form {
            Section(header: Text("User Information")) {
                TextField("Username", text: $username)
                
                VStack(alignment: .leading) {
                    Text("Bio")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    TextEditor(text: $bio)
                        .frame(minHeight: 100)
                }
            }
            
            Section(header: Text("Favorite Anime")) {
                if favoritesManager.favorites.isEmpty {
                    Text("No favorites saved yet")
                        .foregroundColor(.secondary)
                        .italic()
                } else {
                    List {
                        ForEach(favoritesManager.favorites) { anime in
                            Text(anime.title)
                        }
                    }
                }
            }
            
            Section {
                Button(action: saveProfile) {
                    HStack {
                        Spacer()
                        Text(profileData == nil ? "Create Profile" : "Save Changes")
                            .bold()
                        Spacer()
                    }
                }
                .disabled(username.isEmpty)
            }
        }
    }
    
    private func loadProfileData() {
        isLoading = true
        authViewModel.fetchUserProfile { data in
            profileData = data
            
            if let data = data {
                username = data["username"] as? String ?? ""
                bio = data["bio"] as? String ?? ""
                isEditMode = false
            } else {
                // No profile exists yet
                isEditMode = true
            }
            
            isLoading = false
        }
    }
    
    private func saveProfile() {
        // Get anime titles from favorites manager
        let animeTitles = favoritesManager.favorites.map { $0.title }
        
        authViewModel.createProfile(
            username: username,
            bio: bio,
            favoriteAnime: animeTitles
        )
        
        isEditMode = false
        loadProfileData()
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(AuthViewModel())
            .environmentObject(FavoritesManager())
    }
}

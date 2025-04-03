//
//  SignUpView.swift
//  GoAnime
//
//  Created by Rashad Milton on 3/22/25.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct SignUpView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isLoading = false
    @State private var errorMessage = ""
    @State private var showError = false
    @State private var signUpSuccess = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Header
                Text("CREATE ACCOUNT")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 30)
                    .padding(.bottom, 20)
                
                // Sign up form
                TextField("Email", text: $email)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                
                SecureField("Password", text: $password)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                
                SecureField("Confirm Password", text: $confirmPassword)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                
                // Sign up button
                Button(action: signUp) {
                    ZStack {
                        Rectangle()
                            .fill(Color.red)
                            .frame(height: 50)
                            .cornerRadius(8)
                        
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("SIGN UP")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                    }
                }
                .disabled(isLoading)
                .padding(.top, 10)
                
                // Cancel button
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Text("Cancel")
                        .foregroundColor(.gray)
                        .padding(.top, 10)
                }
                
                Spacer()
            }
            .padding(.horizontal, 30)
            .alert(isPresented: $showError) {
                Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
            .alert("Account Created", isPresented: $signUpSuccess) {
                Button("OK") {
                    presentationMode.wrappedValue.dismiss()
                }
            } message: {
                Text("Your account has been created successfully. You can now log in.")
            }
        }
    }
    
    // Firebase Create Account
    private func signUp() {
        // Validate inputs
        if email.isEmpty || password.isEmpty {
            errorMessage = "Please fill in all fields"
            showError = true
            return
        }
        
        if password != confirmPassword {
            errorMessage = "Passwords do not match"
            showError = true
            return
        }
        
        if password.count < 6 {
            errorMessage = "Password must be at least 6 characters"
            showError = true
            return
        }
        
        isLoading = true
        
        // Create account with Firebase
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            isLoading = false
            
            if let error = error {
                errorMessage = error.localizedDescription
                showError = true
                return
            }
            
            // Success
            signUpSuccess = true
        }
    }
}

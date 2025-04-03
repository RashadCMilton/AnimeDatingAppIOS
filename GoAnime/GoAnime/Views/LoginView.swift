//
//  LoginView.swift
//  GoAnime
//
//  Created by Rashad Milton on 3/21/25.
//

import SwiftUI
import Firebase
import FirebaseAuth
import UIKit

// UIKit to SwiftUI bridge
struct ForgotPasswordRepresentable: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let forgotPasswordVC = ForgotPasswordViewController()
        let navigationController = UINavigationController(rootViewController: forgotPasswordVC)
        navigationController.navigationBar.isHidden = true
        return navigationController
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
    
    typealias UIViewControllerType = UINavigationController
}

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var errorMessage = ""
    @State private var showError = false
    @State private var isLoggedIn = false
    @State private var showSignUp = false
    @State private var showForgotPassword = false
    
    var body: some View {
        ZStack {
            // Dark background
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Logo and title
                Image(systemName: "play.circle.fill")
                    .font(.system(size: 70))
                    .foregroundColor(.red)
                    .accessibilityLabel("GoAnime logo")
                
                Text("GoAnime")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 40)
                    .accessibilityLabel("Welcome to GoAnime")
                
                // Login form
                TextField("Email", text: $email)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .accessibilityLabel("Email address")
                    .accessibilityHint("Enter your email")
                
                SecureField("Password", text: $password)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .accessibilityLabel("Password")
                    .accessibilityHint("Enter your password")
                
                // Forgot Password button
                Button(action: { showForgotPassword = true }) {
                    Text("Forgot Password?")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing, 5)
                        .accessibilityLabel("Forgot password button")
                        .accessibilityHint("Tap to reset your password")
                }
                
                // Login button
                Button(action: signIn) {
                    ZStack {
                        Rectangle()
                            .fill(Color.red)
                            .frame(height: 50)
                            .cornerRadius(8)
                        
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .accessibilityLabel("Logging in...")
                        } else {
                            Text("LOGIN")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .accessibilityLabel("Log in button")
                        }
                    }
                }
                .disabled(isLoading)
                .padding(.top, 10)
                .accessibilityHint("Tap to log in to your account")
                
                // Sign up option
                HStack {
                    Text("Don't have an account?")
                        .foregroundColor(.gray)
                        .accessibilityHidden(true)
                    
                    Button(action: { showSignUp = true }) {
                        Text("Sign Up")
                            .fontWeight(.medium)
                            .foregroundColor(.red)
                            .accessibilityLabel("Sign up button")
                            .accessibilityHint("Tap to create a new account")
                    }
                }
                .padding(.top, 20)
                
                Spacer()
            }
            .padding(.horizontal, 30)
            .padding(.top, 60)
            .alert(isPresented: $showError) {
                Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
            .fullScreenCover(isPresented: $isLoggedIn) {
                SearchAnimeView()
                    .accessibilityLabel("Anime search screen")
            }
            .sheet(isPresented: $showSignUp) {
                SignUpView()
                    .accessibilityLabel("Sign up screen")
            }
            .sheet(isPresented: $showForgotPassword) {
                ForgotPasswordRepresentable(isPresented: $showForgotPassword)
                    .accessibilityLabel("Forgot password screen")
            }
        }
    }
    
    // Firebase Authentication
    private func signIn() {
        isLoading = true
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            isLoading = false
            
            if let error = error {
                errorMessage = error.localizedDescription
                showError = true
                return
            }
            
            isLoggedIn = true
        }
    }
}

#Preview {
    LoginView()
}

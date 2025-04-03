//
//  ForgotPasswordViewController.swift
//  GoAnime
//
//  Created by Rashad Milton on 3/29/25.
//

import UIKit
import Firebase
import FirebaseAuth

class ForgotPasswordViewController: UIViewController {
    
    // MARK: - UI Elements
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 70)
        imageView.image = UIImage(systemName: "play.circle.fill", withConfiguration: config)
        imageView.tintColor = .systemRed
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isAccessibilityElement = true
        imageView.accessibilityLabel = "GoAnime logo"
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Reset Password"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isAccessibilityElement = true
        label.accessibilityLabel = "Reset Password"
        return label
    }()
    
    private let instructionLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter your email address to receive a password reset link"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isAccessibilityElement = true
        return label
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        textField.textColor = .white
        textField.layer.cornerRadius = 8
        textField.autocapitalizationType = .none
        textField.keyboardType = .emailAddress
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isAccessibilityElement = true
        textField.accessibilityLabel = "Email address"
        textField.accessibilityHint = "Enter your email"
        return textField
    }()
    
    private let resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("RESET PASSWORD", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isAccessibilityElement = true
        button.accessibilityLabel = "Reset password button"
        button.accessibilityHint = "Tap to send password reset email"
        return button
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Back to Login", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isAccessibilityElement = true
        button.accessibilityLabel = "Back to login"
        button.accessibilityHint = "Tap to return to login screen"
        return button
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.isAccessibilityElement = true
        indicator.accessibilityLabel = "Loading"
        return indicator
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .black
        
        view.addSubview(logoImageView)
        view.addSubview(titleLabel)
        view.addSubview(instructionLabel)
        view.addSubview(emailTextField)
        view.addSubview(resetButton)
        view.addSubview(backButton)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            // Logo constraints
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 70),
            logoImageView.widthAnchor.constraint(equalToConstant: 70),
            
            // Title constraints
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Instruction label constraints
            instructionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            instructionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            instructionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            // Email text field constraints
            emailTextField.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 30),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Reset button constraints
            resetButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 30),
            resetButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            resetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            resetButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Activity indicator constraints
            activityIndicator.centerXAnchor.constraint(equalTo: resetButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: resetButton.centerYAnchor),
            
            // Back button constraints
            backButton.topAnchor.constraint(equalTo: resetButton.bottomAnchor, constant: 20),
            backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupActions() {
        resetButton.addTarget(self, action: #selector(resetPasswordTapped), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func resetPasswordTapped() {
        guard let email = emailTextField.text, !email.isEmpty else {
            showAlert(with: "Error", message: "Please enter your email address")
            return
        }
        
        activityIndicator.startAnimating()
        resetButton.setTitle("", for: .normal)
        resetButton.isEnabled = false
        
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            guard let self = self else { return }
            
            self.activityIndicator.stopAnimating()
            self.resetButton.setTitle("RESET PASSWORD", for: .normal)
            self.resetButton.isEnabled = true
            
            if let error = error {
                self.showAlert(with: "Error", message: error.localizedDescription)
                return
            }
            
            self.showAlert(with: "Success", message: "Password reset link has been sent to your email", completion: {
                self.dismiss(animated: true)
            })
        }
    }
    
    @objc private func backButtonTapped() {
        self.dismiss(animated: true)
    }
    
    // MARK: - Helper Methods
    private func showAlert(with title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

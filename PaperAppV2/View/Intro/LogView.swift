//
//  LoginView.swift
//  PaperApp
//
//  Created by Sothesom on 20/09/1403.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct LogView: View {
    @Binding var isLoggedIn: Bool

    @State private var email = ""
    @State private var password = ""
    @State private var username = ""
    @State private var isSignUp = false
    @State private var errorMessage = ""
    
    @Environment(\.colorScheme) private var colorScheme
    
    @StateObject private var viewModel = AuthenticationMod()

    var body: some View {
        NavigationStack {
            VStack(spacing: 25) {
                Text(isSignUp ? "Create Account" : "Welcome Back")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top)
                
                VStack(spacing: 20) {
                    if isSignUp {
                        // Username field with icon
                        HStack(spacing: 12) {
                            Image(systemName: "person.fill")
                                .foregroundColor(.gray)
                            TextField("Username", text: $username)
                                .textContentType(.username)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 12)
                        .background(.white.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    
                    // Email field with icon
                    HStack(spacing: 12) {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.gray)
                        TextField("Email", text: $email)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                    .background(.white.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    // Password field with icon
                    HStack(spacing: 12) {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.gray)
                        SecureField("Password", text: $password)
                            .textContentType(isSignUp ? .newPassword : .password)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                    .background(.white.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .foregroundColor(.white)
                
                // Login/Signup Button
                Button(action: {
                    if isSignUp {
                        signUp(email: email, password: password, username: username) { result in
                            handleAuthResult(result)
                        }
                    } else {
                        login(email: email, password: password) { result in
                            handleAuthResult(result)
                        }
                    }
                }) {
                    Text(isSignUp ? "Sign Up" : "Login")
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding(.top)
                
                // Divider
                HStack {
                    Rectangle()
                        .fill(.white.opacity(0.5))
                        .frame(height: 1)
                    
                    Text("OR")
                        .foregroundColor(.white.opacity(0.5))
                        .font(.caption)
                    
                    Rectangle()
                        .fill(.white.opacity(0.5))
                        .frame(height: 1)
                }
                .padding(.vertical)
                
                // Google Sign In Button
                Button {
                    Task {
                        if await viewModel.signInWithGoogle() {
                            isLoggedIn = true
                        }
                    }
                } label: {
                    HStack(spacing: 12) {
                        Image("google-logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                        
                        Text("Continue with Google")
                            .font(.callout)
                            .lineLimit(1)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
                // Error Message
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.top, 10)
                }
                
                // Toggle Login/Signup
                Button {
                    withAnimation {
                        isSignUp.toggle()
                        errorMessage = ""
                    }
                } label: {
                    Text(isSignUp ? "Already have an account? Login" : "Don't have an account? Sign Up")
                        .foregroundColor(.white.opacity(0.7))
                        .font(.callout)
                }
                .padding(.top)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [.black, .blue],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .ignoresSafeArea()
            }
            .navigationDestination(isPresented: $isLoggedIn) {
                AsliView()
                    .navigationBarBackButtonHidden()
            }
        }
    }
    
    // Add helper function
    private func handleAuthResult<T>(_ result: Result<T, Error>) {
        switch result {
        case .success(let value):
            if let isVerified = value as? Bool {
                if isVerified {
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    isLoggedIn = true
                } else {
                    errorMessage = "Please verify your email before logging in."
                }
            } else if let message = value as? String {
                errorMessage = message
                isLoggedIn = false
            }
        case .failure(let error):
            errorMessage = error.localizedDescription
        }
    }
}

func login(email: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void) {
    Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
        if let error = error {
            completion(.failure(error))
        } else if let user = authResult?.user {
            user.reload { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    if user.isEmailVerified {
                        completion(.success(true)) // ایمیل تأیید شده
                    } else {
                        completion(.success(false)) // ایمیل تأیید نشده
                    }
                }
            }
        }
    }
}

func signUp(email: String, password: String, username: String, completion: @escaping (Result<String, Error>) -> Void) {
    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
        if let error = error {
            completion(.failure(error))
        } else if let user = authResult?.user {
            // ذخیره اطلاعات کاربر در Firestore
            let db = Firestore.firestore()
            db.collection("users").document(user.uid).setData([
                "email": email,
                "username": username
            ]) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    // ارسال ایمیل تأیید
                    user.sendEmailVerification { error in
                        if let error = error {
                            print("Error sending email verification: \(error.localizedDescription)")
                            completion(.failure(error))
                        } else {
                            print("Verification email sent successfully!")
                            completion(.success("Account created! Please verify your email before logging in."))
                                
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    LogView(isLoggedIn: .constant(false))
}

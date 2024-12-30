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
            VStack {
                if isSignUp {
                    TextField("Username", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                }
                
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Button(isSignUp ? "Sign Up" : "Login") {
                    if isSignUp {
                        signUp(email: email, password: password, username: username) { result in
                            switch result {
                            case .success(let message):
                                errorMessage = message
                                isLoggedIn = false // جلوگیری از ورود
                            case .failure(let error):
                                errorMessage = error.localizedDescription
                            }
                        }
                    } else {
                        login(email: email, password: password) { result in
                            switch result {
                            case .success(let isVerified):
                                if isVerified {
                                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                                    isLoggedIn = true
                                } else {
                                    errorMessage = "Please verify your email before logging in."
                                }
                            case .failure(let error):
                                errorMessage = error.localizedDescription
                            }
                        }
                    }
                }
                .padding(.vertical, 15)
                .frame(maxWidth: .infinity)
                .font(.system(size: 20, weight: .bold))
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)

                HStack {
                    VStack { Divider () }
                    Text ("or")
                    VStack { Divider () }
                }
                
                Button {
                    Task {
                        if await viewModel.signInWithGoogle() {
                            isLoggedIn = true
                        }
                    }
                } label: {
                    Text("Sign in with Google")
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(alignment: .leading) {
                            Image("google-logo")
                                .frame(width: 160, alignment: .center)
                        }
                }
                            .buttonStyle(.bordered)

                
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()

                Button(isSignUp ? "Already have an account? Login" : "Don't have an account? Sign Up") {
                    isSignUp.toggle()
                }
                .padding(.top, 20)
                
                NavigationLink(value: isLoggedIn, label: {
                    EmptyView()
                })
            }
            .navigationDestination(isPresented: $isLoggedIn) {
                AsliView()
                    .navigationBarBackButtonHidden()
            }
            .padding()
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


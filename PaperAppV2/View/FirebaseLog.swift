//
//  LoginView.swift
//  PaperApp
//
//  Created by Sothesom on 20/09/1403.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct FirebaseLog: View {
    @Binding var isLoggedIn: Bool

    @State private var email = ""
    @State private var password = ""
    @State private var username = ""
    @State private var isSignUp = false
    @State private var errorMessage = ""
    
    // برای هدایت به HomeView

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
                                    isLoggedIn = true // هدایت به HomeView
                                } else {
                                    errorMessage = "Please verify your email before logging in."
                                }
                            case .failure(let error):
                                errorMessage = error.localizedDescription
                            }
                        }
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)

                Button {
//                    FirebaseLogGoogle(isLoggedIn: $isLoggedIn)
                } label: {
                    Text("GG")
                }
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
    FirebaseLog(isLoggedIn: .constant(false))
}


// Your existing imports remain the same
import GoogleSignIn
import GoogleSignInSwift
import FirebaseCore

struct FirebaseLogGoogle: View {
    @Binding var isLoggedIn: Bool
    
    func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                // User successfully signed in
                self.isLoggedIn = true
            }
        }
    }
    
    var body: some View {
        Button(action: signInWithGoogle) {
            HStack {
                Image(systemName: "g.circle.fill")
                    .foregroundColor(.red)
                Text("Sign in with Google")
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
        .padding(.top, 20)
        
        // The rest of your view content remains the same
    }
}

// The rest of your code remains the same

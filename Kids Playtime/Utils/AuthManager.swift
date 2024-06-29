//
//  AuthManager.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 24/05/2024.
//

import Foundation
import FirebaseAuth
import GoogleSignIn
import FirebaseCore

public class AuthManager {
    
    static let shared = AuthManager() // Singleton instance
    
    func logoutUser() {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            UserDefaults.standard.setValue(nil, forKey: "name")
            UserDefaults.standard.setValue(nil, forKey: "userEmail")
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
    func resetPassword(for email: String) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            guard error == nil else {
                print("failed to send password reset")
                return
            }
        }
    }
    
    func loginUser(email: String, password: String, completion: @escaping (String) -> Void) {
        
        guard !email.isEmpty else {
            completion("enter email")
            return
        }
        
        let emailPattern =
        #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,64}$"#
        
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailPattern)
        
        guard emailPredicate.evaluate(with: email) else {
            completion("invalid email")
            return
        }
        guard !password.isEmpty else {
            completion("enter password")
            return
        }
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { authResult, error in
            
            guard let result = authResult, error == nil else {
                print("Failed to log in user with email: \(email)")
                completion("Wrong email or password")
                return
            }
            let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
            UserDefaults.standard.set("\(safeEmail)", forKey: "userEmail")
            
            if let userName = result.user.displayName {
                let userFirstName = userName.split(separator: " ").first.map(String.init) ?? userName
                UserDefaults.standard.set("\(userFirstName)", forKey: "name")
                
            } else {
                DatabaseManager.shared.getDataFor(email: safeEmail, completion: { result in
                    switch result {
                    case .success(let data):
                        print("Data result from getDataFor: \(data)")
                        guard let userData = data as? [String: Any],
                              let name = userData["name"] as? String else {
                            return
                        }
                        let firstName = name.split(separator: " ").first.map(String.init) ?? name
                        
                        // save user's name to cachce
                        UserDefaults.standard.set("\(firstName)", forKey: "name")
                        
                    case .failure(let error):
                        print("Failed to read data with error \(error)")
                    }
                })
            }
        })
    }
    
    func registerUser(email: String,
                      firstName: String,
                      lastName: String,
                      password: String) {

        guard !email.isEmpty,
            !password.isEmpty,
            !firstName.isEmpty,
            !lastName.isEmpty,
            password.count >= 6 else {
                return
        }
        
        let lowerCasedEmail = email.lowercased()
        // Firebase Log In
        FirebaseAuth.Auth.auth().createUser(withEmail: lowerCasedEmail, password: password, completion: { authResult, error in
            guard authResult != nil, error == nil else {
                return
            }
            
            DatabaseManager.shared.userExists(with: lowerCasedEmail, completion: { exists in

                guard !exists else {
                    // user already exists
                    return
                }
                let safeEmail = DatabaseManager.safeEmail(emailAddress: lowerCasedEmail)
                UserDefaults.standard.set("\(safeEmail)", forKey: "userEmail")
                UserDefaults.standard.set("\(firstName)", forKey: "name")

                let user = User(firstName: firstName,
                                          lastName: lastName,
                                          emailAddress: lowerCasedEmail)
                DatabaseManager.shared.insertUser(with: user, completion: { success in
                    if success {
                        print("succesfully added user to Database")
                    }
                })
            })
        })
    }
    
    func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow
        GIDSignIn.sharedInstance.signIn(withPresenting: getRootViewController()) { result, error in
            guard error == nil else {
                print("Error while starting the sign in process")
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                print("Error while logging in using google")
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { result, error in
                
                guard let safeUserProfile = user.profile else {
                    return
                }
                
                let firstName = safeUserProfile.name.split(separator: " ").first.map(String.init) ?? safeUserProfile.name
                // save user's name to cachce
                let safeEmail = DatabaseManager.safeEmail(emailAddress: safeUserProfile.email)
                UserDefaults.standard.set("\(safeEmail)", forKey: "userEmail")
                UserDefaults.standard.set("\(firstName)", forKey: "name")
                
                DatabaseManager.shared.userExists(with: safeUserProfile.email, completion: { exists in
                    
                    guard !exists else {
                        print("user already exists in the database")
                        return
                    }
                    
                    let fullName = safeUserProfile.name
                    let components = fullName.split(separator: " ")
                    let (firstName, lastName) = (String(components[0]), String(components[1]))
                    
                    let user = User(firstName: firstName,
                                    lastName: lastName,
                                    emailAddress: safeUserProfile.email)
                
                    DatabaseManager.shared.insertUser(with: user, completion: { success in
                        if success {
                            print("succesfully added user to Database")
                        }
                    })
                    
                })
            }
        }
    }
    
    func deleteUser(email: String, completion: @escaping (Result<Bool, Error>) -> Void) {
            Auth.auth().currentUser?.delete { error in
                if let error = error {
                    print("Failed to delete user from Auth: \(error)")
                    completion(.failure(error))
                    return
                }
            }
        }
    
    private func getRootViewController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return UIApplication.shared.windows.first!.rootViewController!
        }
        return screen.windows.first!.rootViewController!
    }
    
    
}

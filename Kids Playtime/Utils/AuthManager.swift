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
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
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
        // Firebase Log In

        DatabaseManager.shared.userExists(with: email, completion: { [weak self] exists in
            guard let strongSelf = self else {
                return
            }

            guard !exists else {
                // user already exists
                return
            }

            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { authResult, error in
                guard authResult != nil, error == nil else {
                    return
                }

                let user = User(firstName: firstName,
                                          lastName: lastName,
                                          emailAddress: email)
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
                
                DatabaseManager.shared.userExists(with: safeUserProfile.email, completion: { [weak self] exists in
                    
                    guard !exists else {
                        print("user already exists in the database")
                        return
                    }
                    guard let strongSelf = self else {
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
    
    
    
    private func getRootViewController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return UIApplication.shared.windows.first!.rootViewController!
        }
        return screen.windows.first!.rootViewController!
    }
    
    
}

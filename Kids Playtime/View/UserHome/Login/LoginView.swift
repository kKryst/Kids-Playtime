//
//  LoginView.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 23/05/2024.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn
import FirebaseAuth

struct LoginView: View {
    
    @State var loginText = ""
    @State var passwordText = ""
    var body: some View {
        VStack {
            Text("Login")
                .font(AppFonts.amikoRegular(withSize: 48))
                .foregroundStyle(AppColors.darkBlue)
            TextField("Username", text: $loginText)
                .font(AppFonts.amikoRegular(withSize: 18))
                .foregroundStyle(AppColors.darkBlue)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(AppColors.darkBlue, lineWidth: 1)
                )
            SecureField("Password", text: $passwordText)
                .font(AppFonts.amikoRegular(withSize: 18))
                .foregroundStyle(AppColors.darkBlue)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(AppColors.darkBlue, lineWidth: 1)
                )
                .padding(.top, 0)
            Button(action: {}, label: {
                Text("Login")
                    .font(AppFonts.amikoRegular(withSize: 18))
                    .foregroundStyle(AppColors.white)
                    .frame(width: 130)
                    .padding()
                    .background(AppColors.lightBlue)
                    .cornerRadius(20)
            })
            .padding()
            Text("or")
                .font(AppFonts.amikoRegular(withSize: 18))
                .foregroundStyle(AppColors.darkBlue)
                .padding()
            Button(action: {
                signInWithGoogle()
            }, label: {
                Text("Log in using Google")
                    .font(AppFonts.amikoRegular(withSize: 18))
                    .foregroundStyle(AppColors.lightBlue)
            })
            HStack {
                Text("First time?")
                    .font(AppFonts.amikoSemiBold(withSize: 18))
                    .foregroundStyle(AppColors.darkBlue)
                Button(action: {}, label: {
                    Text("Register here")
                        .font(AppFonts.amikoBold(withSize: 18))
                        .foregroundStyle(AppColors.darkBlue)
                })
            }
            .padding()
        }
        .padding()
    }
    
    func getRootViewController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return UIApplication.shared.windows.first!.rootViewController!
        }
        return screen.windows.first!.rootViewController!
    }
    
    func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
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
                
                print("logging in using google succesfull")
            }
        }
    }
}
#Preview {
    LoginView()
}

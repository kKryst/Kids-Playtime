//
//  LoginView.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 23/05/2024.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn

struct LoginView: View {
    
    @State var emailText = ""
    @State var passwordText = ""
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Login")
                    .font(AppFonts.amikoRegular(withSize: 48))
                    .foregroundStyle(AppColors.darkBlue)
                TextField("Email", text: $emailText)
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
                Button(action: {
                    AuthManager.shared.loginUser(email: emailText, password: passwordText)
                    dismiss()
                }, label: {
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
                Button(action: {
                    AuthManager.shared.signInWithGoogle()
                }, label: {
                    Text("Log in using Google")
                        .font(AppFonts.amikoRegular(withSize: 18))
                        .foregroundStyle(AppColors.lightBlue)
                        .padding()
                })
                HStack {
                    Text("First time?")
                        .font(AppFonts.amikoSemiBold(withSize: 18))
                        .foregroundStyle(AppColors.darkBlue)
                    NavigationLink(destination: {
                        RegisterView()
                    }, label: {
                        Text("Register here")
                            .font(AppFonts.amikoBold(withSize: 18))
                            .foregroundStyle(AppColors.darkBlue)
                    })
                }
                .padding()
            }
        }
    }
}
#Preview {
    LoginView()
}

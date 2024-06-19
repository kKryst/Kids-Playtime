//
//  LoginView.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 23/05/2024.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn
import GoogleSignInSwift

struct LoginView: View {
    
    @State var emailText = "test@test.com"
    @State var passwordText =    "123456"
    @State var errorMessage = ""
    @State var emailResetText = ""
    @State var showAlert = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.white
                    .ignoresSafeArea()
                VStack {
                    Text("Log in")
                        .font(AppFonts.amikoRegular(withSize: 48))
                        .foregroundStyle(AppColors.darkBlue)
                        .padding()
                    VStack(spacing: 1) {
                        HStack {
                            Text("Enter your email")
                                .font(AppFonts.amikoRegular(withSize: 16))
                                .foregroundStyle(AppColors.darkBlue)
                            Spacer()
                        }
                        TextField("Email", text: $emailText)
                            .font(AppFonts.amikoRegular(withSize: 18))
                            .foregroundStyle(AppColors.darkBlue)
                            .padding()
                            .autocapitalization(.none)
                            .background(AppColors.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(AppColors.darkBlue, lineWidth: 1)
                            )
                            .padding(.bottom, 16)
                        HStack {
                            Text("Enter your password")
                                .font(AppFonts.amikoRegular(withSize: 16))
                                .foregroundStyle(AppColors.darkBlue)
                            Spacer()
                        }
                        SecureField("Password", text: $passwordText)
                            .font(AppFonts.amikoRegular(withSize: 18))
                            .foregroundStyle(AppColors.darkBlue)
                            .padding()
                            .background(AppColors.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(AppColors.darkBlue, lineWidth: 1)
                            )
                        HStack {
                            Text("\(errorMessage)")
                                .font(AppFonts.amikoRegular(withSize: 16))
                                .foregroundStyle(Color.red)
                            Spacer()
                            Button(action: {
                                showAlert = true
                            }, label: {
                                Text("Forgot password?")
                                    .font(AppFonts.amikoRegular(withSize: 16))
                                    .foregroundStyle(AppColors.darkBlue)
                            })
                            
                        }
                        .padding(8)
                    }
                    
                    Button(action: {
                        AuthManager.shared.loginUser(email: emailText, password: passwordText) { errorResponse in
                            if errorResponse != "" {
                                errorMessage = errorResponse
                            }
                        }
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
                    Text("or")
                        .font(AppFonts.amikoRegular(withSize: 18))
                        .foregroundStyle(AppColors.darkBlue)
                    HStack {
                        GoogleSignInButton(scheme: .dark, style: .icon, state: .normal) {
                            AuthManager.shared.signInWithGoogle()
                        }
                    }
                    
                    HStack {
                        Text("Don't have an acoount?")
                            .font(AppFonts.amikoSemiBold(withSize: 16))
                            .foregroundStyle(AppColors.darkBlue)
                        NavigationLink(destination: {
                            RegisterView()
                        }, label: {
                            Text("Register here")
                                .font(AppFonts.amikoBold(withSize: 16))
                                .foregroundStyle(AppColors.darkBlue)
                        })
                    }
                    .padding()
                }
                .padding()
            }
            .alert("Enter your email", isPresented: $showAlert) {
                TextField("Enter your email", text: $emailResetText)
                    .foregroundStyle(Color.white)
                Button("Cancel", action: {
                    showAlert = false
                })
                Button("Send", action: {
                    if emailResetText != "" {
                        AuthManager.shared.resetPassword(for: emailResetText)
                    }
                })
            }
            .onTapGesture {
                showAlert = false
            }
        }
    }
}
#Preview {
    LoginView()
}

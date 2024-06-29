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
    
    @State private var alertText = ""
    
    @State private var emailText = ""
    @State private var passwordText = ""
    @State private var errorMessage = ""
    @State private var emailResetText = ""
    @State private var showAlert = false
    
    @State private var noInternetAlert = false
    
    @FocusState private var isFirstResponder :Bool
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var networkManager: NetworkManager
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("loginBackground")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                    
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isFirstResponder = false
                    }
                VStack {
                    Text("Log in")
                        .font(AppFonts.amikoRegular(withSize: 48))
                        .foregroundStyle(AppColors.permanentWhite)
                        .padding()
                    
                    VStack(spacing: 16) {
                        HStack {
                            Text("Enter your email")
                                .font(AppFonts.amikoSemiBold(withSize: 16))
                                .foregroundStyle(AppColors.permanentWhite)
                            Spacer()
                        }
                        TextField("Email", text: $emailText)
                            .font(AppFonts.amikoRegular(withSize: 18))
                            .foregroundStyle(AppColors.permanentDarkBlue)
                            .padding()
                            .autocapitalization(.none)
                            .background(AppColors.permanentWhite)
                            .cornerRadius(10)
                            .focused($isFirstResponder)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(AppColors.permanentWhite, lineWidth: 1)
                            )
                            .frame(maxWidth: .infinity)
                        
                        HStack {
                            Text("Enter your password")
                                .font(AppFonts.amikoSemiBold(withSize: 16))
                                .foregroundStyle(AppColors.permanentWhite)
                            Spacer()
                        }
                        SecureField("Password", text: $passwordText)
                            .font(AppFonts.amikoRegular(withSize: 18))
                            .foregroundStyle(AppColors.permanentDarkBlue)
                            .padding()
                            .focused($isFirstResponder)
                            .background(AppColors.permanentWhite)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(AppColors.permanentWhite, lineWidth: 1)
                            )
                            .frame(maxWidth: .infinity)
                        
                        HStack {
                            Text("\(errorMessage)")
                                .font(AppFonts.amikoRegular(withSize: 16))
                                .foregroundStyle(Color.red)
                            Spacer()
                            Button(action: {
                                showAlert = true
                            }, label: {
                                Text("Forgot password?")
                                    .font(AppFonts.amikoSemiBold(withSize: 16))
                                    .foregroundStyle(AppColors.permanentWhite)
                            })
                        }
                        .padding(8)
                    }
                    .padding(.horizontal)
                    
                    Button(action: {
                        guard networkManager.isConnected else {
                            alertText = "Failed to log in. Please check your Internet connection."
                            noInternetAlert = true
                            return
                        }
                        AuthManager.shared.loginUser(email: emailText, password: passwordText) { errorResponse in
                            if errorResponse != "" {
                                errorMessage = errorResponse
                            } else {
                                dismiss()
                            }
                        }
                    }, label: {
                        Text("Login")
                            .font(AppFonts.amikoRegular(withSize: 18))
                            .foregroundStyle(AppColors.permanentWhite)
                            .frame(width: 130)
                            .padding()
                            .background(AppColors.lightBlue)
                            .cornerRadius(20)
                    })
                    Text("or")
                        .font(AppFonts.amikoSemiBold(withSize: 18))
                        .foregroundStyle(AppColors.permanentWhite)
                    HStack {
                        GoogleSignInButton(scheme: .dark, style: .icon, state: .normal) {
                            AuthManager.shared.signInWithGoogle()
                            dismiss()
                        }
                    }
                    
                    HStack {
                        Text("Don't have an account?")
                            .font(AppFonts.amikoSemiBold(withSize: 16))
                            .foregroundStyle(AppColors.permanentWhite)
                        NavigationLink(destination: {
                            RegisterView()
                        }, label: {
                            Text("Register here")
                                .font(AppFonts.amikoBold(withSize: 16))
                                .foregroundStyle(AppColors.permanentWhite)
                        })
                    }
                    .padding()
                }
                .padding()
            }
            .alert(
                "\(alertText)",
                isPresented: $noInternetAlert
            ) {}
            .alert("Enter your email", isPresented: $showAlert) {
                TextField("Enter your email", text: $emailResetText)
                    .foregroundStyle(Color.white)
                Button("Cancel", action: {
                    showAlert = false
                })
                Button("Send", action: {
                    guard networkManager.isConnected else {
                        alertText = "Failed to send the email. Check your internet connection"
                        noInternetAlert = true
                        return
                    }
                    if emailResetText != "" {
                        AuthManager.shared.resetPassword(for: emailResetText)
                    }
                })
            }
            .onTapGesture {
                showAlert = false
            }
        }
        .onAppear {
            viewRouter.shouldDisplayTabView = false
            if viewRouter.shouldNavigateBackTwice {
                viewRouter.shouldNavigateBackTwice = false
                dismiss()
            }
        }
        
    }
}

#Preview {
    LoginView()
}

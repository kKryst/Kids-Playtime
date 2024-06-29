//
//  RegisterView.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 24/05/2024.
//

import SwiftUI

struct RegisterView: View {
    
    @State private var firstNameText = ""
    @State private var lastNameText = ""
    @State private var emailText = ""
    @State private var passwordText = ""
    
    @State private var noInternetAlert = false
    
    @FocusState private var isFirstResponder :Bool
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var networkManager: NetworkManager
    
    var body: some View {
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
                Text("Register")
                    .font(AppFonts.amikoRegular(withSize: 48))
                    .foregroundStyle(AppColors.permanentWhite)
                    .padding()
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
                    .focused($isFirstResponder)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(AppColors.permanentWhite, lineWidth: 1)
                    )
                HStack {
                    Text("Enter your first name")
                        .font(AppFonts.amikoSemiBold(withSize: 16))
                        .foregroundStyle(AppColors.permanentWhite)
                    Spacer()
                }
                TextField("First Name", text: $firstNameText)
                    .font(AppFonts.amikoRegular(withSize: 18))
                    .foregroundStyle(AppColors.permanentDarkBlue)
                    .padding()
                    .background(AppColors.permanentWhite)
                    .cornerRadius(10)
                    .focused($isFirstResponder)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(AppColors.permanentWhite, lineWidth: 1)
                    )
                HStack {
                    Text("Enter your last name")
                        .font(AppFonts.amikoSemiBold(withSize: 16))
                        .foregroundStyle(AppColors.permanentWhite)
                    Spacer()
                }
                TextField("Last Name", text: $lastNameText)
                    .font(AppFonts.amikoRegular(withSize: 18))
                    .foregroundStyle(AppColors.permanentDarkBlue)
                    .padding()
                    .background(AppColors.permanentWhite)
                    .focused($isFirstResponder)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(AppColors.permanentWhite, lineWidth: 1)
                    )
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
                    .background(AppColors.permanentWhite)
                    .focused($isFirstResponder)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(AppColors.permanentWhite, lineWidth: 1)
                    )
                    .padding(.top, 0)
                Button(action: {
                    guard networkManager.isConnected else {
                        noInternetAlert = true
                        return
                    }
                    AuthManager.shared.registerUser(email: emailText, firstName: firstNameText, lastName: lastNameText, password: passwordText)
                    viewRouter.shouldNavigateBackTwice = true
                    dismiss()
                    
                }, label: {
                    Text("Create new account")
                        .font(AppFonts.amikoRegular(withSize: 18))
                        .foregroundStyle(AppColors.permanentWhite)
                        .padding()
                        .background(AppColors.lightBlue)
                        .cornerRadius(20)
                })
                .padding()
            }
            .alert(
                "Failed to register. Please check your Internet connection.",
                isPresented: $noInternetAlert
            ) {}
            .padding(40)
        }
        .onAppear {
            viewRouter.shouldDisplayTabView = false
        }
    }
}

#Preview {
    RegisterView()
}

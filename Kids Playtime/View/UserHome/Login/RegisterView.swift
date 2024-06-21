//
//  RegisterView.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 24/05/2024.
//

import SwiftUI

struct RegisterView: View {
    
    @State var firstNameText = ""
    @State var lastNameText = ""
    @State var emailText = ""
    @State var passwordText = ""
    
    @FocusState private var isFirstResponder :Bool
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewRouter: ViewRouter
    
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
                    .foregroundStyle(AppColors.white)
                    .padding()
                HStack {
                    Text("Enter your email")
                        .font(AppFonts.amikoSemiBold(withSize: 16))
                        .foregroundStyle(AppColors.white)
                    Spacer()
                }
                TextField("Email", text: $emailText)
                    .font(AppFonts.amikoRegular(withSize: 18))
                    .foregroundStyle(AppColors.darkBlue)
                    .padding()
                    .autocapitalization(.none)
                    .background(Color.white)
                    .focused($isFirstResponder)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(AppColors.darkBlue, lineWidth: 1)
                    )
                HStack {
                    Text("Enter your first name")
                        .font(AppFonts.amikoSemiBold(withSize: 16))
                        .foregroundStyle(AppColors.white)
                    Spacer()
                }
                TextField("First Name", text: $firstNameText)
                    .font(AppFonts.amikoRegular(withSize: 18))
                    .foregroundStyle(AppColors.darkBlue)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .focused($isFirstResponder)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(AppColors.darkBlue, lineWidth: 1)
                    )
                HStack {
                    Text("Enter your last name")
                        .font(AppFonts.amikoSemiBold(withSize: 16))
                        .foregroundStyle(AppColors.white)
                    Spacer()
                }
                TextField("Last Name", text: $lastNameText)
                    .font(AppFonts.amikoRegular(withSize: 18))
                    .foregroundStyle(AppColors.darkBlue)
                    .padding()
                    .background(Color.white)
                    .focused($isFirstResponder)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(AppColors.darkBlue, lineWidth: 1)
                    )
                HStack {
                    Text("Enter your password")
                        .font(AppFonts.amikoSemiBold(withSize: 16))
                        .foregroundStyle(AppColors.white)
                    Spacer()
                }
                SecureField("Password", text: $passwordText)
                    .font(AppFonts.amikoRegular(withSize: 18))
                    .foregroundStyle(AppColors.darkBlue)
                    .padding()
                    .background(Color.white)
                    .focused($isFirstResponder)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(AppColors.darkBlue, lineWidth: 1)
                    )
                    .padding(.top, 0)
                Button(action: {
                    AuthManager.shared.registerUser(email: emailText, firstName: firstNameText, lastName: lastNameText, password: passwordText)
                    viewRouter.shouldNavigateBackTwice = true
                    dismiss()
                    
                }, label: {
                    Text("Create new account")
                        .font(AppFonts.amikoRegular(withSize: 18))
                        .foregroundStyle(AppColors.white)
                        .padding()
                        .background(AppColors.lightBlue)
                        .cornerRadius(20)
                })
                .padding()
            }
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

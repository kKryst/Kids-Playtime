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
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Text("Register")
                .font(AppFonts.amikoRegular(withSize: 48))
                .foregroundStyle(AppColors.darkBlue)
            TextField("Email", text: $emailText)
                .font(AppFonts.amikoRegular(withSize: 18))
                .foregroundStyle(AppColors.darkBlue)
                .padding()
                .autocapitalization(.none)
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(AppColors.darkBlue, lineWidth: 1)
                )
            TextField("First Name", text: $firstNameText)
                .font(AppFonts.amikoRegular(withSize: 18))
                .foregroundStyle(AppColors.darkBlue)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(AppColors.darkBlue, lineWidth: 1)
                )
            TextField("Last Name", text: $lastNameText)
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
                AuthManager.shared.registerUser(email: emailText, firstName: firstNameText, lastName: lastNameText, password: passwordText)
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
        .padding()
    }
}

#Preview {
    RegisterView()
}

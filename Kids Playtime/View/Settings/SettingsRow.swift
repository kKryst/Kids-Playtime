//
//  SettingsRow.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 28/01/2024.
//

import SwiftUI

enum SettingType {
    case toggle, action
}

struct SettingsRow: View {
    
    let title: String
    let imageName: String
    var isOn: Binding<Bool>?
    var destinationView: (() -> AnyView)?
    var action: (() -> Void)?
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .foregroundStyle(AppColors.orange)
                .padding(.horizontal, 28)
                .padding(.vertical)
            
            if let isOnBinding = isOn {
                Toggle(isOn: isOnBinding, label: {
                    Text(title)
                        .font(AppFonts.amikoSemiBold(withSize: 16))
                        .foregroundStyle(AppColors.darkBlue)
                })
                .padding(.horizontal)
                .toggleStyle(SwitchToggleStyle(tint: AppColors.orange))
            } else {
                Text(title)
                    .font(AppFonts.amikoSemiBold(withSize: 16))
                    .foregroundStyle(AppColors.darkBlue)
                    .padding(.horizontal)
                    .frame(minWidth: 100)
                
                Spacer()
                
                if let destinationView = destinationView {
                    NavigationLink(destination: destinationView()) {
                        EmptyView()
                    }.frame(width: 0).opacity(0)
                    
                    Image(systemName: "chevron.right")
                        .foregroundStyle(AppColors.orange)
                        .padding(.horizontal)
                }
                if let action = action {
                    Button(action: action) {
                        Image(systemName: "chevron.right")
                            .foregroundStyle(AppColors.orange)
                            .padding(.horizontal)
                    }
                }
                
            }
        }
        .background(RoundedRectangle(cornerRadius: 25).fill(AppColors.lightBlue.opacity(0.1)))
    }
}

#Preview {
    SettingsRow(title: "Report a bug", imageName: "moon", destinationView: {AnyView(TermsAndConditionsView())})
}

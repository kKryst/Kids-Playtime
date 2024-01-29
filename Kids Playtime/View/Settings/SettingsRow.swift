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
                
                Spacer()
                
                if let action = action {
                    Button(action: action, label: {
                        Image(systemName: "chevron.right")
                            .foregroundStyle(AppColors.orange)
                            .padding(.horizontal, 28)
                    })
                }
            }
        }
        .background(RoundedRectangle(cornerRadius: 25).fill(AppColors.lightBlue.opacity(0.1)))
    }
}

#Preview {
    SettingsRow(title: "Dark mode", imageName: "moon", isOn: .constant(true))
}

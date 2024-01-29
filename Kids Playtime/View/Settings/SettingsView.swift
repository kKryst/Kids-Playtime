//
//  SettingsView.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 14/01/2024.
//

import SwiftUI

struct SettingsView: View {
    
    @State var darkModeToggle: Bool = false
    @State var notificationsOn: Bool = false
    
    var body: some View {
        ZStack {
            AppColors.white.ignoresSafeArea()
            VStack {
                List {
                    Section(
                        header: Text("Settings").font(AppFonts.amikoSemiBold(withSize: 20)).foregroundStyle(AppColors.darkBlue))
                    {
                        SettingsRow(title: "Dark mode", imageName: "moon", isOn: $darkModeToggle)
                            .listRowInsets(EdgeInsets())
                            .listRowSeparator(.hidden)
                            .padding(.vertical, 8)
                        SettingsRow(title: "Notifications", imageName: "bell", isOn: $notificationsOn)
                            .listRowInsets(EdgeInsets())
                            .listRowSeparator(.hidden)
                            .padding(.vertical, 8)
                        SettingsRow(title: "Report a bug", imageName: "exclamationmark.triangle", action: {print("Action on report a bug pressed")})
                            .listRowInsets(EdgeInsets())
                            .listRowSeparator(.hidden)
                            .padding(.vertical, 8)
                        SettingsRow(title: "Logout", imageName: "rectangle.portrait.and.arrow.right", action: {print("Logout pressed")})
                            .listRowInsets(EdgeInsets())
                            .listRowSeparator(.hidden)
                            .padding(.vertical, 8)
                        
                    }
                    
                    .scrollContentBackground(.hidden)
                    .background(AppColors.white)
                }
                .scrollContentBackground(.hidden)
                .background(AppColors.white)
                .padding(.vertical)
            }
        }
    }
}

#Preview {
    SettingsView()
}



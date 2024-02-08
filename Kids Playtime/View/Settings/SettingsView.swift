//
//  SettingsView.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 14/01/2024.
//

import SwiftUI

struct SettingsView: View {
    
    @AppStorage("isDarkMode") private var darkModeToggle: Bool = false
    @AppStorage("isNotificationsOn") private var notificationsOn: Bool = false
    
    var body: some View {
        NavigationStack {
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
                            
                            SettingsRow(title: "About App", imageName: "info.circle", destinationView: {
                                AnyView(TermsAndConditionsView())
                            })
                            .listRowInsets(EdgeInsets())
                            .listRowSeparator(.hidden)
                            .padding(.vertical, 8)
                            
                            SettingsRow(title: "Terms & Conditions", imageName: "text.book.closed", destinationView: {
                                AnyView(TermsAndConditionsView())
                            })
                            .listRowInsets(EdgeInsets())
                            .listRowSeparator(.hidden)
                            .padding(.vertical, 8)
                            
                            SettingsRow(title: "Report a bug", imageName: "exclamationmark.triangle", destinationView: {
                                AnyView(TermsAndConditionsView())
                            })
                            .listRowInsets(EdgeInsets())
                            .listRowSeparator(.hidden)
                            .padding(.vertical, 8)
                            
//                            SettingsRow(title: "Logout", imageName: "rectangle.portrait.and.arrow.right", action: {print("Logout button pressed")})
//                            .listRowInsets(EdgeInsets())
//                            .listRowSeparator(.hidden)
//                            .padding(.vertical, 8)
                            
                        }
                        
                        .scrollContentBackground(.hidden)
                        .background(AppColors.white)
                    }
                    
                    .buttonStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .background(AppColors.white)
                    .padding(.vertical)
                }
            }
        }
        .tint(AppColors.darkBlue)
    }
}

#Preview {
    SettingsView()
}



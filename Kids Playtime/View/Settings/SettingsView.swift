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
//                            SettingsRow(title: "Notifications", imageName: "bell", isOn: $notificationsOn)
//                                .listRowInsets(EdgeInsets())
//                                .listRowSeparator(.hidden)
//                                .padding(.vertical, 8)
                        }
                        .scrollContentBackground(.hidden)
                        .background(AppColors.white)
                        
                        Section(
                            header: Text("Other").font(AppFonts.amikoSemiBold(withSize: 20)).foregroundStyle(AppColors.darkBlue))
                        {
                            SettingsRow(title: "About App", imageName: "info.circle", destinationView: {
                                AnyView(AboutAppView())
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
                            
                            SettingsRow(title: "Report a bug", imageName: "exclamationmark.triangle", action: {
                                openEmailApp(toEmail: "krystiankonieczko2@gmail.com", subject: "Bug report", body: "")
                            })
                            .listRowInsets(EdgeInsets())
                            .listRowSeparator(.hidden)
                            .padding(.vertical, 8)
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
    
    func openEmailApp(toEmail: String, subject: String, body: String) {
        guard
            let subject = subject.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
            let body = "Describe the bug here".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        else {
            print("Error: Can't encode subject or body.")
            return
        }
        
        let urlString = "mailto:\(toEmail)?subject=\(subject)&body=\(body)"
        let url = URL(string:urlString)!
        
        UIApplication.shared.open(url)
    }
}

#Preview {
    SettingsView()
}



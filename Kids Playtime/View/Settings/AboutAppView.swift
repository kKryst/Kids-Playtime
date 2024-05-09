//
//  AboutAppView.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 10/02/2024.
//

import SwiftUI

struct AboutAppView: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        ZStack {
            AppColors.white.ignoresSafeArea()
            VStack {
                Image("imag")
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 17.0))
                    .padding(8)
                    .frame(width: 200, height: 200)
                Text("Kids Playtime")
                    .font(AppFonts.amikoBold(withSize: 24))
                    .foregroundStyle(AppColors.darkBlue)
                Text("Version 1.0")
                    .font(AppFonts.amikoSemiBold(withSize: 18))
                    .foregroundStyle(AppColors.darkBlue)
                Text("Welcome to Kids Playtime. This simple mobile app is designed to help you find new ideas to spend some time with your children.")
                    .padding()
            }
        }
        .onAppear {
            viewRouter.shouldDisplayTabView = false
        }
        .onDisappear(perform: {
            viewRouter.shouldDisplayTabView = true
        })
    }
}

#Preview {
    AboutAppView()
}

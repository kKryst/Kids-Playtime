//
//  NoInternetView.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 29/06/2024.
//

import SwiftUI

struct NoInternetView: View {
    var body: some View {
        ZStack {
            AppColors.white.ignoresSafeArea()
            VStack {
                Image("noInternetConnection")
                Text("Oooops!")
                    .font(AppFonts.amikoBold(withSize: 36))
                    .foregroundStyle(AppColors.darkBlue)
                Text("No internet connection found!")
                    .font(AppFonts.amikoBold(withSize: 18))
                    .foregroundStyle(AppColors.darkBlue)
                Text("Please check your Internet connection and try again")
                    .font(AppFonts.amikoSemiBold(withSize: 18))
                    .foregroundStyle(AppColors.darkBlue)
                    .multilineTextAlignment(.center)
                    
            }
            .padding()
        }
    }
}

#Preview {
    NoInternetView()
}

//
//  TermsAndConditionsView.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 02/02/2024.
//

import SwiftUI

struct TermsAndConditionsView: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        ZStack {
            AppColors.white.ignoresSafeArea()
            VStack {
                Text("Terms and conditions here...")
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
    TermsAndConditionsView()
}

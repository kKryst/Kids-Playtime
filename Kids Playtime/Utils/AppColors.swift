//
//  AppColors.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 14/01/2024.
//

import SwiftUI

struct AppColors {
    // background
    static let gradientColor = Color.init(hexString: "d9e8e2")
    static let background = LinearGradient(gradient: Gradient(colors: [AppColors.white, AppColors.pink]), startPoint: .bottom, endPoint: .top)
    static let alertBackground = LinearGradient(gradient: Gradient(colors: [AppColors.lightBlue, AppColors.orange]), startPoint: .bottom, endPoint: .top)
    
    // app colors
    static let orange = Color("AppOrange")
    static let lightBlue = Color("AppLightBlue")
    static let darkBlue = Color("AppDarkBlue")
    static let white = Color("AppWhite")
    static let pink = Color("AppPink")
    static let tabColor = Color("AppTabColor")
    static let tabForegroundColor = Color("AppTabForegroundColor")
    static let permanentWhite = Color("AppPermanentWhite")
    static let permanentDarkBlue = Color("AppPermanentDarkBlue")
    
    static let wheelColors = [AppColors.pink, AppColors.lightBlue, AppColors.orange, AppColors.white]
}

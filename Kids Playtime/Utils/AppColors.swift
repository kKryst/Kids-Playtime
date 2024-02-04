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
    static let orange = Color("orange")
    static let lightBlue = Color("lightBlue")
    static let darkBlue = Color("darkBlue")
    static let white = Color("white")
    static let pink = Color("pink")
    static let tabColor = Color("tabColor")
    static let tabForegroundColor = Color("tabForegroundColor")
}
